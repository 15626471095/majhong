--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/12/1
-- Time: 14:31
-- To change this template use File | Settings | File Templates.
--

local GameController = class("GameController",function()
    return {}
end)

function GameController.getInstance()
    if not GameController.instance then
        GameController.instance = GameController.new()
    end
    return GameController.instance
end

function GameController:ctor()
    self.isInit = false
end

function GameController:init(majhongView)
    self.view = majhongView
    local Players = {}
    Players[1] = majhongView.Self
    Players[2] = majhongView.Right
    Players[3] = majhongView.Front
    Players[4] = majhongView.Left
    self.Players = Players
    self.OutCards = majhongView.OutCards
    self.Clock = majhongView.Clock
    self.isInit = true
    self.turns = 1
    print("GameController init!")
end

function GameController:clear()
    self.view = nil
    self.Players = nil
    self.OutCards = nil
    self.Clock = nil
    self.isInit = false
    self.turns = 1
    print("GameController clear!")
end

function GameController:Loop()
    local count = #(self.Players)
    self.turns = self.turns or 1
    local index  = self.turns
    print("loop:",index)


    --local hand = self.Players[index]
    --local card = self:getRandomCard()
    --hand:Take(card)
    --self:showPlayView()
    self.Clock:Turns()

end

function GameController:Next()
    self.turns =  self.turns + 1
    if self.turns > count then
        self.turns = self.turns - count
    end
end

function GameController:showPlayView()
    local types = {3 }
    local callbacks = self:createCallbacks(types)
    self.view:showButtons(types,callbacks)
end

function GameController:createCallbacks(types)
    local target = self.target
    target = Card.create(CardType_Feng,CardType_Feng_Zhong,false,false)
    local callbacks = {}
    for i=1,#types do
        local type = types[i]
        if type == TAG_PENG then
            callbacks[i] = function(sender)
                local result = self.Players[self.turns]:Peng(target)
                if not result then
                    print("Peng Failed!")
                end
            end
        elseif type == TAG_GANG then
            callbacks[i] = function(sender)
                local result = self.Players[self.turns]:Gang(target)
                if not result then
                    print("Gang Failed!")
                end
            end
        elseif type == TAG_HU then
            callbacks[i] = function(sender)
                for i=1,4 do
                    self.Players[i]:Hu(target)
                end
            end
        elseif type == TAG_PLAY then
            callbacks[i] = function(sender)
                local card = self.Players[self.turns]:Play(1)
                if card then
                    self.OutCards:Push(card,self.turns)
                end
            end
        end
    end
    return callbacks
end

function GameController:getRandomCard()
    local types = {"tong","tiao","wang","feng" }
    local feng = {"dong","nan","xi","bei","zhong","fa","bai" }
    local type = math.random(1,4)
    type = types[type]
    local number
    if type == "feng" then
        number = feng[math.random(1,7)]
    else
        number = math.random(1,9)
    end
    print("card",type,number)
    local card = Card.create(type,number,false,false)
    return card
end

return GameController
