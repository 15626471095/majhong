--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/27
-- Time: 12:47
-- To change this template use File | Settings | File Templates.
--

local Player = class("Player",function()
    return {}
end)

function Player.create(position,cards,user)
    return Player.new(position,cards,user)
end

function Player:ctor(position,cards,user)
    self.Cards = cards
    self.UserInfo = user
    self.Position = position
end

function Player:getFrames(cards)
    local frames = {}
    for i=1,#cards do
        frames[i] = cards[i]:getFrameName(self.Position)
    end
    return frames
end

function Player:getHandCards()
    local cards = {}
    for i=1,#(self.Cards) do
        local card = self.Cards[i]
        if (not card.Out) and (not card.Side) then
            cards[#cards+1] = self.Cards[i]
        end
    end
    return cards
end

function Player:getOutCards()
    local cards = {}
    for i=1,#(self.Cards) do
        local card = self.Cards[i]
        if card.Out then
            cards[#cards+1] = self.Cards[i]
        end
    end
    return cards
end

function Player:getSideCards()
    local cards = {}
    for i=1,#(self.Cards) do
        local card = self.Cards[i]
        if (not card.Out) and card.Side then
            cards[#cards+1] = self.Cards[i]
        end
    end
    return cards
end


return Player
