--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/30
-- Time: 18:19
-- To change this template use File | Settings | File Templates.
--

local OutCards = class("OutCards",function()
    return ccui.Layout:create()
end)



function OutCards.create(border,players)
    return OutCards.new(border,players)
end

function OutCards:ctor(border,players)
    local offset = Size.AutoSize(20)
    local point = cc.p(border.left + offset,border.bottom + offset)
    local size = cc.size(display.width - border.left - border.right - 2*offset, display.height - border.top - border.bottom - 2*offset)
    self.size = size
    self.x = self.size.width/2 - 12*40/2
    self.y = 0
    self:setPosition(point)
    self:setContentSize(size)
    self:setAnchorPoint(cc.p(0,0))
    self.lineWidth = 11

    self.Self = {}
    self.Right = {}
    self.Front = {}
    self.Left = {}
end

function OutCards:createList(player,position,anchor,orderMode,oppsite)
    local outList = ListView.create()
    outList:setItemOffset(MajhongView.getItemOffset(player.Position))
    --outList:setSingleLine(false)
    outList:setLineWidth(11)
    if oppsite then
        outList:setOppsite(true)
    end
    if player.Position == Position_Self or player.Position == Position_Front then
        outList:setDirection(Direction_Horizontal)
    else
        outList:setDirection(Direction_Vertical)
    end
    if player and player.getOutCards then
        local outs = player:getOutCards()
        for i=1,#outs do
            local item = CardItem.create(outs[i],player.Position)
            outList:insertItem(item)
        end
    end
    outList:draw()
    outList:setPosition(position)
    outList:setAnchorPoint(anchor)
    outList:setItemOrder(orderMode)
    if oppsite then
        outList:update(outList:getItemCount())
    end
    return outList
end

function OutCards:addList(player,position)
    player = player or {}
    player.Position = position
    local pos
    local anchor
    local drawMode
    local oppsite

    if position == Position_Self then
        drawMode = false
        oppsite = false
        anchor = cc.p(0,0)
        local count = #(self.Self)
        if count == 0 then
            pos = cc.p(self.x,0)
        elseif count == 1 then
            pos = cc.p(self.x,self.Self[count].size.height-10)
        end
        local list = self:createList(player,pos,anchor,drawMode,oppsite)
        self:addChild(list,2-count)
        self.Self[count+1] = list
    elseif position == Position_Right then
        drawMode = false
        oppsite = false
        anchor = cc.p(1,0)
        local count = #(self.Right)
        if count == 0 then
            pos = cc.p(self.size.width,self.y)
        elseif count == 1 then
            pos = cc.p(self.size.width - self.Right[count].size.width,self.y)
        end
        local list = self:createList(player,pos,anchor,drawMode,oppsite)
        self:addChild(list,2-count)
        self.Right[count+1] = list
    elseif position == Position_Front then
        drawMode = true
        oppsite = true
        anchor = cc.p(1,1)
        local count = #(self.Front)
        if count == 0 then
            pos = cc.p(self.size.width -self.x,self.size.height)
        elseif count == 1 then
            pos = cc.p(self.size.width -self.x,self.size.height-self.Front[count].size.height + 10)
        end
        local list = self:createList(player,pos,anchor,drawMode,oppsite)
        self:addChild(list,count+1)
        self.Front[count+1] = list
    elseif position == Position_Left then
        drawMode = true
        oppsite = true
        anchor = cc.p(0,1)
        local count = #(self.Left)
        if count == 0 then
            pos = cc.p(0,self.size.height-self.y)
        elseif count == 1 then
            pos = cc.p(self.Left[count].size.width,self.size.height-self.y)
        end
        local list = self:createList(player,pos,anchor,drawMode,oppsite)
        self:addChild(list,count+1)
        self.Left[count+1] = list
    end

end

function OutCards:PushSelf(card)
    self:Push(card,Position_Self)
end

function OutCards:PushRight(card)
    self:Push(card,Position_Right)
end

function OutCards:PushLeft(card)
    self:Push(card,Position_Left)
end

function OutCards:PushFront(card)
    self:Push(card,Position_Front)
end

function OutCards:getTargetList(position)
    local target
    if position == Position_Self then
        target = self.Self
    elseif position == Position_Right then
        target = self.Right
    elseif position == Position_Left then
        target = self.Left
    elseif position == Position_Front then
        target = self.Front
    end
    if #target == 0 then
        self:addList(nil,position)
    elseif #target == 1 and target[1]:getItemCount() >= target[1].lineWidth then
        self:addList(nil,position)
    end
    return target[#target]
end

function OutCards:Push(card,position)
    card.Out = true
    card.Side = false
    local item = CardItem.create(card,position)
    local target = self:getTargetList(position)
    if target.oppsite then
        target:insertItem(item)
        target:update(target:getItemCount())
        target:setItemOrder(true)
    else
        target:insertItem(item,nil,false)
        target:setItemOrder(false)
        target:update(1)
    end

end

return OutCards
