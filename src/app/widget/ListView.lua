--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/28
-- Time: 11:21
-- To change this template use File | Settings | File Templates.
--

local ListView = class("ListView",function()
    return ccui.Layout:create()
end)

function ListView.create()
    return ListView.new()
end

cc.exports.Direction_Horizontal = 0
cc.exports.Direction_Vertical = 1

function ListView:ctor()
    self.items = {}
    self.model = nil
    self.direction = Direction_Horizontal
    self.oppsite = false
    self.size = cc.size(0,0)
    self.anchor = cc.p(0,0)
    self.itemOffset = 0
    self.singleLine = true
    self.lineWidth = 0
end

function ListView:setModelItem(model)
    self.model = model
end

function ListView:setOppsite(oppsite)
    oppsite = oppsite or false
    self.oppsite = oppsite
end

function ListView:setSingleLine(mode)
    mode = mode or false
    self.singleLine = mode
end

function ListView:setLineWidth(count)
    self.lineWidth = count
end

function ListView:setDirection(direction)
    self.direction = direction
    if #(self.items) ~= 0 then
        self:draw()
    end
end

function ListView:setItemOffset(offset)
    offset = offset or 0
    self.itemOffset = offset
end

function ListView:insertItem(item,index,update)
    local length = #(self.items)
    index = index or (length + 1)
    table.insert(self.items,index,item)
    update = update or false
    if update then
        self:update(index)
    end
    self:autoAdjustSize(item)
end

function ListView:autoAdjustSize(item,isRemove)
    isRemove = isRemove or false
    local factor
    if isRemove then
        factor = -1
    else
        factor = 1
    end
    local s = item:getContentSize()
    if self.direction == Direction_Horizontal then
        self.size.width = self.size.width + factor * (s.width - self.itemOffset)
        if self.size.height < s.height then
            self.size.height = s.height
        end
    else
        self.size.height = self.size.height + factor * (s.height - self.itemOffset)
        if self.size.width < s.width then
            self.size.width = s.width
        end
    end
end

function ListView:insertDefaultItem(index)
    self:insertItem(self.model,index)
end

function ListView:removeAllItems()
    self:removeAllChildren()
    self.items = {}
    self.size = cc.size(0,0)
    self:removeAllChildren()
end

function ListView:removeItem(index)
    local item = index
    if type(index) == "number" then
        item = self.items[index]
    else
        for i=1,#(self.items) do
            if self.items[i] == index then
                index = i
                break
            end
        end
    end
    if not index or not item then
        print("item not find")
        return
    end
    item.isDraw = nil
    self:autoAdjustSize(item,true)
    self:removeChild(item)
    table.remove(self.items,index)
    self:update(index)
end

function ListView:getItem(index)  -- from 1 to N
    return self.items[index]
end

function ListView:getItemCount()
    return #(self.items)
end

function ListView:getItems()
    return self.items
end

function ListView:draw()
    if #(self.items) == 0 then
        return
    end
    if self.oppsite then
        self:update(#(self.items),true)
    else
        self:update(1,true)
    end
end

function ListView:sort(beginIndex,endIndex,isIncreaseOrder)
    isIncreaseOrder = isIncreaseOrder or false
    beginIndex = beginIndex or 1
    endIndex = endIndex or #(self.items)
    for i=beginIndex,endIndex do
        for j=i+1,endIndex do
            local a = self.items[i]
            local b = self.items[j]
            local compare = a:compareTo(b)
            local isSwap = false
            if (isIncreaseOrder and compare < 0) or (not isIncreaseOrder and compare > 0)  then
                isSwap = true
            end
            if isSwap then
                self.items[i] = b
                self.items[j] = a
            end
        end
    end
end

function ListView:getLine(index)
    if self.singleLine then
        return 1
    end
    local max = self.lineWidth
    local line = 1
    if index % max == 0 then
        line = math.floor(index / max)
    else
        line = math.ceil(index / max)
    end
    return line
end

function ListView:getNextPoint(lastPoint,lastItemIndex)
    local nextPoint

    if self.singleLine then
        local lastItemSize = (self.items[lastItemIndex]):getContentSize()
        nextPoint = cc.p(lastPoint.x,lastPoint.y)
        if self.direction == Direction_Horizontal then
            nextPoint.x = nextPoint.x + lastItemSize.width - self.itemOffset
        else
            nextPoint.y = nextPoint.y + lastItemSize.height - self.itemOffset
        end
    else

    end
    return nextPoint
end

function ListView:update(index,isFirst)
    if index == 0 then
        return
    end
    if not index then
        if self.oppsite then
            index = #(self.items)
        else
            index = 1
        end
    end
    isFirst = isFirst or false
    local point
    local item
    local lastIndex
    if self.oppsite then
        lastIndex = index + 1
    else
        lastIndex = index - 1
    end
    item = self.items[lastIndex]
    if item then
        point = self:getNextPoint(item.pos,lastIndex)
    else
        point = cc.p(0,0)
    end
    local items = self.items
    local length = #items

    local beginIndex
    local endIndex
    local interval
    if self.oppsite then
        if isFirst then
            beginIndex = length
            endIndex = index
            interval = -1
        else
            beginIndex = index
            endIndex = 1
            interval = -1
        end

    else
        beginIndex = index
        endIndex = length
        interval = 1
    end
    for i=beginIndex,endIndex,interval do
        local item = items[i]
        assert(item,"ListView item is nil")
        item:setPosition(point)
        item.pos = point
        item:setAnchorPoint(self.anchor)
        self:addItem(item)
        point = self:getNextPoint(point,i)
    end
    self:setContentSize(self.size)
end

function ListView:setItemOrder(isIncrease)
    local max = 50
    isIncrease = isIncrease or false
    for i=1,#(self.items) do
        if isIncrease then
            self.items[i]:setLocalZOrder(i)
        else
            self.items[i]:setLocalZOrder(max - i)
        end
    end

end

function ListView:addItem(item)
    item.isDraw = item.isDraw or false
    if not item.isDraw then
        self:addChild(item)
        item.isDraw = true
    end
end

return ListView

