--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/27
-- Time: 17:38
-- To change this template use File | Settings | File Templates.
--

local GameEngine = class("GameEngine", function()
    return {}
end)

GameEngine.instance = nil

function GameEngine.getInstance()
    local engine = GameEngine.instance
    engine = engine or GameEngine.new()
    return engine
end

function GameEngine:GetPlayerData()
    local c = {}
    c[1] = Card.create()

    c[2] = Card.create(CardType_Tong,2,false,false)
    c[3] = Card.create(CardType_Tong,2,true,false)
    c[4] = Card.create(CardType_Tong,2,false,true)

    c[5] = Card.create(CardType_Tiao,5,false,false)
    c[6] = Card.create(CardType_Tiao,5,true,false)
    c[7] = Card.create(CardType_Tiao,5,false,true)

    c[8] = Card.create(CardType_Wang,9,false,false)
    c[9] = Card.create(CardType_Wang,9,true,false)

    c[10] = Card.create(CardType_Feng,CardType_Feng_Nan ,false,false)
    c[11] = Card.create(CardType_Feng,CardType_Feng_Nan,true,false)

    c[12] = Card.create(CardType_Feng,CardType_Feng_Dong,false,false)
    c[13] = Card.create(CardType_Feng,CardType_Feng_Dong,true,false)

    c[14] = Card.create(CardType_Feng,CardType_Feng_Zhong,false,false)
    c[15] = Card.create(CardType_Feng,CardType_Feng_Zhong,false,false)
    c[16] = Card.create(CardType_Feng,CardType_Feng_Zhong,false,false)
    c[17] = Card.create(CardType_Feng,CardType_Feng_Zhong,true,false)

    local user = UserInfo.create()
    return Player.create(Position_Right,c,user)
end

return GameEngine
