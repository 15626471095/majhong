--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/29
-- Time: 12:30
-- To change this template use File | Settings | File Templates.
--

local CardItem = class("CardItem",function()
    CardItem.anchor = cc.p(0,0)
    return ccui.Layout:create()
end)

function CardItem.create(card,position)
    return CardItem.new(card,position)
end

function CardItem:ctor(card,position)
    self.card = card
    self.position = position
    self.isSelected = false
    self:createSprite(card,position)
end

function CardItem:createSprite(card,position)
    local frame = card:getFrameName(position)
    local item = display.newSprite("#"..frame)
    SizeUtils.resizeTo(item,card:getFrameSize(position))
    local pos = cc.p(0,0)
    item:setPosition(pos)
    item:setAnchorPoint(CardItem.anchor)
    item.pos = pos

    self:addChild(item)
    item:setTag(10086)
    self.item = item
    self:setContentSize(item:getContentSize())
    self:setClickListener(item,position)
    local offset = Size.AutoSize(20)
    if position == Position_Self then
        if card.Side then
            self:setMargin(TOP,offset)
        elseif not card.Out then
            self:setMargin(BOTTOM,offset)
        else
            -- Out
        end
    elseif position == Position_Right then
        if card.Side then

        elseif not card.Out then
            self:setMargin(TOP,10)
        else
            -- Out
        end
    elseif position == Position_Left then
        if card.Side then

        elseif not card.Out then
            self:setMargin(TOP,10)
        else
            -- Out
        end
    elseif position == Position_Front then
        if card.Side then
            self:setMargin(BOTTOM,5)
        elseif not card.Out then

        else
            -- Out
        end
    end
end

function CardItem:refresh()
    self:removeChildByTag(10086)
    self.card.Side = true
    self:createSprite(self.card,self.position)
end

function CardItem:setClickListener(item,position)
    if position == Position_Self then
        ClickUtils.setOnClickListener(self,function(sender)
            local point = item.pos
            if self.isSelected then
                item:setPosition(point)
            else
                item:setPosition(point.x,point.y+10)
            end
            self.isSelected = not self.isSelected
        end)
    end
end

function CardItem:setMargin(direction,offset)
    direction = direction or TOP
    local size = self:getContentSize()
    local point = self.item.pos
    if direction == TOP then
        size.height = size.height + offset
    elseif direction == RIGHT then
        size.width = size.width + offset
    elseif direction == BOTTOM then
        size.height = size.height + offset
        point.y = point.y + offset
    elseif direction == LEFT then
        size.width = size.width + offset
        point.x = point.x + offset
    end
    self:setContentSize(size)
    self.item:setPosition(point)
    self.item.pos = point
end

function CardItem:compareTo(target)
    return self.card:compareTo(target.card)
end

return CardItem