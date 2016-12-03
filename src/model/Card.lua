--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/27
-- Time: 13:54
-- To change this template use File | Settings | File Templates.
--

local Card = class("Card", function()
    return {}
end)

cc.exports.Position_Self = 1
cc.exports.Position_Right = 2
cc.exports.Position_Front = 3
cc.exports.Position_Left = 4

cc.exports.CardType_Tong = "tong"
cc.exports.CardType_Tiao = "tiao"
cc.exports.CardType_Wang = "wang"
cc.exports.CardType_Feng = "feng"

cc.exports.CardType_Feng_Dong = "dong"
cc.exports.CardType_Feng_Nan = "nan"
cc.exports.CardType_Feng_Xi = "xi"
cc.exports.CardType_Feng_Bei = "bei"
cc.exports.CardType_Feng_Zhong = "zhong"
cc.exports.CardType_Feng_Fa = "fa"
cc.exports.CardType_Feng_Bai = "bai"

function Card.create(type,number,out,side)
    return Card.new(type,number,out,side)
end

function Card:ctor(type,number,out,side)
    self.Type = type or CardType_Tong
    self.Number = number or 1
    self.Out = out or false
    self.Side = side or false
end

function Card:getFrameName(position)
    local frameName
    local isShow = self.Out or self.Side
    if isShow or position == Position_Self then
        local s
        if self.Type == CardType_Feng then
            s = self.Number
        else
            s = string.format("%s_%d",self.Type,self.Number)
        end
        frameName = string.format("%d_%s",position,s)
        if position == Position_Self  and isShow then
            frameName = frameName.."_out"
        end
    else
        if position == Position_Left then
            frameName = "left"
        elseif position == Position_Right then
            frameName = "right"
        elseif position == Position_Front then
            frameName = "front"
        end
    end
    frameName = frameName..".png"
    return frameName
end

function Card:getFrameSize(position)
    local size
    local width = Size.AutoSize(60)
    local height = Size.AutoSize(80)
    if position == Position_Self then
        size = cc.size(40,60)
    elseif position == Position_Right then
        if not self.Out and not self.Side then
            size = cc.size(30,50)
        else
            size = cc.size(50,50)
        end
    elseif position == Position_Left then
        if not self.Out and not self.Side then
            size = cc.size(30,50)
        else
            size = cc.size(50,50)
        end
    elseif position == Position_Front then
        size = cc.size(40,60)
    end
    return size
end

function Card:compare(card)
    return self.Type == card.Type and self.Number == card.Number
end

function Card:getTypeOrder()
    local type = self.Type
    local order = 0
    if type == CardType_Tiao then
        order = 1
    elseif type == CardType_Tong then
        order = 2
    elseif type == CardType_Wang then
        order = 3
    elseif type == CardType_Feng then
        order = 4
    end
    return order
end

function Card:getNumberOrder()
    local type = self.Type
    local number = self.Number
    local order = 0
    if type == CardType_Feng then
        if number == CardType_Feng_Dong then
            order = 1
        elseif number == CardType_Feng_Nan then
            order = 2
        elseif number == CardType_Feng_Xi then
            order = 3
        elseif number == CardType_Feng_Bei then
            order = 4
        elseif number == CardType_Feng_Zhong  then
            order = 5
        elseif number == CardType_Feng_Fa then
            order = 6
        elseif number == CardType_Feng_Bai then
            order = 7
        end
        return order
    else
        return number
    end
end

function Card:compareTo(card)
    local order1 = self:getTypeOrder()
    local order2 = card:getTypeOrder()
    if order1 == order2 then
        local number1 = self:getNumberOrder()
        local number2 = card:getNumberOrder()
        if number1 == number2 then
            return 0
        elseif number1 > number2 then
            return 1
        else
            return -1
        end
    elseif order1 > order2 then
        return 1
    else
        return -1
    end
end

return Card
