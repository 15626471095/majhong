--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/29
-- Time: 14:27
-- To change this template use File | Settings | File Templates.
--

local CardList = class("CardList",function()
    return {}
end)

function CardList.create(player)
    return CardList.new(player)
end

function CardList:ctor(player)
    local list = ListView.create()
    self.list = list
    self.player = player
    self.position = player.Position
    self:setItemOffset(MajhongView.getItemOffset(player.Position))
    if self.position == Position_Self or self.position == Position_Front then
        list:setDirection(Direction_Horizontal)
    else
        list:setDirection(Direction_Vertical)
    end

    list:insertItem(self:getBlankLayout())
    list:insertItem(self:getBlankLayout())
    self.divideIndex = 1
    self.endIndex = 2

    local array = player:getSideCards()
    for i=1,#array do
        self:insertSide(array[i],nil,false)
    end

    array = player:getHandCards()
    for i=1,#array do
        self:insertHand(array[i],nil,false)
    end

end

function CardList:setPosition(point)
   self.list:setPosition(point)
end

function CardList:setItemOffset(offset)
    self.list:setItemOffset(offset)
end

function CardList:setAnchorPoint(point)
    self.list:setAnchorPoint(point)
end

function CardList:setDirection(direction)
    self.list:setDirection(direction)
end

function CardList:setZOrderMode(isIncrease)
    self.list:setItemOrder(isIncrease)
end

function CardList:setOppsiteDraw()
    self.list.oppsite = true
end

function CardList:draw()
    self.list:draw()
end

function CardList:getContentSize()
    return self.list:getContentSize()
end

function CardList:insertSide(card,count,isDraw)
    count = count or 3
    isDraw = isDraw or true
    local index = self.divideIndex
    local offset = Size.AutoSize(20)

    card.Out = false
    card.Side = true
    local item = CardItem.create(card,self.position)
    for i=1,count do
        self.list:insertItem(item,index,isDraw)
        index = index + 1
        item = CardItem.create(card,self.position)
    end
    self.divideIndex = self.divideIndex + count
    self.endIndex = self.endIndex + count
end

function CardList:insertHand(card,index,isDraw)
    isDraw = isDraw or true
    if index then
        index = index + self.divideIndex
    else
        index = self.endIndex
    end
    local offset = Size.AutoSize(20)
    card.Out = false
    card.Side = false
    local item = CardItem.create(card,self.position)
    self.list:insertItem(item,index,isDraw)
    if index <= self.endIndex then
        self.endIndex = self.endIndex + 1
    end
end

function CardList:removeHand(card)
    local index
    if type(card) == "number" then
        index = card
    else
        index = self:find(card,self.divideIndex+1)
    end
    if not index then
        print("index is nil")
        return
    end
    self.list:removeItem(index)
    if index < self.endIndex then
        self.endIndex = self.endIndex - 1
    end
end

function CardList:sortHand(isDraw)
    isDraw = isDraw or false
    self.list:sort(self.divideIndex+1,self.endIndex-1)
    if isDraw then
        self.list:update(self.divideIndex+1)
    end
end

function CardList:insertTake()
    local take = self.list:getItem(self.endIndex+1)
    if take and take.card then
        local index = self:getInsertIndex(take.card)
        self:insertHand(take.card,index)
        self.list:removeItem(take)
    end
end

function CardList:getInsertIndex(card)
    local items = self.list:getItems()
    local index = self.endIndex
    for i=self.divideIndex+1,self.endIndex-1 do
        local compare = card:compareTo(items[i].card)
        if compare <= 0 then
            index = i
            break;
        end
    end
    index = index - self.divideIndex
    return index
end

function CardList:getBlankLayout()
    local position = self.position
    local size
    if position == Position_Self then
        size = cc.size(Size.AutoSize(20),Size.AutoSize(10))
    elseif position == Position_Right then
        size = cc.size(Size.AutoSize(30),Size.AutoSize(30))
    elseif position == Position_Left then
        size = cc.size(Size.AutoSize(30),Size.AutoSize(30))
    elseif position == Position_Front then
        size = cc.size(Size.AutoSize(20),Size.AutoSize(15))
    end
    local blank = ccui.Layout:create()
    blank:setContentSize(size)
    return blank
end

function CardList:find(card,beginIndex,endIndex)
    local items = self.list:getItems()
    endIndex = endIndex or #items
    beginIndex = beginIndex or 1
    for i=beginIndex,endIndex do

        if items[i].card and items[i].card:compare(card) then
            return i
        end
    end
    return nil
end

function CardList:setDrawMode()
    if self.list.oppsite then
        self.list:setItemOrder(true)
    else
        self.list:setItemOrder(false)
    end
end

function CardList:match(card,count)
    local matchIndex = {}
    local curIndex = self.divideIndex + 1
    local isMatch = true
    for i=1,count do
        local target = self:find(card,curIndex)
        print("target",target)
        if target then
            matchIndex[i] = target
            curIndex = target + 1
        else
            isMatch = false
            break;
        end
    end
    if isMatch then
        for i=1,count do
            self:removeHand(matchIndex[i] - (i-1))
        end
        self:insertSide(card,count+1)
        self:setDrawMode()
    else
        if count == 2 then
            print("Can not Peng!")
        else
            print("Can not Gang!")
        end
    end
    return isMatch
end

function CardList:getSelectedCard()
    local items = self.list:getItems()
    local cards = {}
    for i = self.divideIndex,#items do
        if items[i].isSelected == true then
            cards[#cards+1] = items[i].card
        end
    end
    return cards
end

function CardList:Peng(card)
    return self:match(card,2)
end

function CardList:Gang(card)
    return self:match(card,3)
end

function CardList:Take(card)
    local isSelf = (self.position == Position_Self)
    local index = self.endIndex - self.divideIndex
    if isSelf then
        index = self.endIndex - self.divideIndex+1
    end
    self:insertHand(card,index,true)
end

function CardList:Play(index)
    if index then
        index = index + self.divideIndex
        local item = self.list:getItem(index).card
        self:removeHand(item)
        self:insertTake()
        return item
    end
    local selected = self:getSelectedCard()
    print(#selected)
    if #selected ~= 1 then
        print("Can not play!")
        return nil
    end
    self:removeHand(selected[1])
    if self.position == Position_Self then
        self:insertTake()
    end
    return selected[1]
end

function CardList:Hu()
    for i=1,self.list:getItemCount() do
        local item = self.list:getItem(i)
        if item.refresh then
            item:refresh()
        end
    end
    self.list:update()
    self:setDrawMode()
end

return CardList