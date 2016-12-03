--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/20
-- Time: 14:04
-- To change this template use File | Settings | File Templates.
--

local SquareScene = class("SquareScene", BaseScene.create)

cc.exports.TAG_RANK = 1
cc.exports.TAG_MARKET = 2
cc.exports.TAG_SETTING = 3

cc.exports.TAG_ROOM_ADD = 1
cc.exports.TAG_ROOM_CREATE = 2
cc.exports.TAG_ROOM_FRESHMAN = 3
cc.exports.TAG_ROOM_MID = 4
cc.exports.TAG_ROOM_MASTER = 5


function SquareScene.create()
    local scene = SquareScene.new()
    return scene
end

function SquareScene:ctor()
    self:addChild(self:createSquareLayer())
end

function SquareScene:createSquareLayer()
    local layer = cc.Layer:create()
    SquareScene.layer = layer

    -- background
    self:createBackground(layer)

    -- user head
    self:createUserHead(layer)

    -- infomation button
    self:createInfomationButton(layer)

    -- back
    self:createBack(layer)

    -- player
    --self:createPlayer(layer)

    -- button
    self:createEnterRoomButton(layer)

    return layer
end

-- background
function SquareScene:createBackground(layer)
    local background = cc.Sprite:create("square/background.png")
    SizeUtils.resize(background)
    background:setPosition(display.cx,display.cy)
    layer:addChild(background)
end

-- player
function SquareScene:createPlayer(layer)
    local rank = layer:getChildByTag(TAG_RANK)
    local player = cc.Sprite:create("square/player.png")
    local player_pos = PositionUtils.getRelativePosition(rank,RIGHT,TOP,Size.AutoSize(40),Size.AutoSize(0))
    player:setPosition(player_pos)
    player:setAnchorPoint(cc.p(1,0))
    layer.player = player
    layer:addChild(player,1)
end

-- infomation button
function SquareScene:createInfomationButton(layer)
    local function ShowInfomation(sender)
        local tag = sender:getTag()
        if not tag then
            return
        end
        if tag == TAG_RANK then
            print("rank")
        elseif tag == TAG_MARKET then
            print("market")
        elseif tag == TAG_SETTING then
            print("setting")
            local setting = Setting.create()
            layer:addChild(setting,999)
        end
    end

    local fontSetting = LabelUtils.createFontSetting(nil,14,display.COLOR_RED)
    local offset = cc.p(0,0)

    -- rank
    local rank_param = SpriteUtils.createSpriteParam(
        "square/rank.png",
        cc.p(display.cx,Size.AutoSize(30)),
        cc.p(0.5,0),
        TAG_RANK,
        "square/rank_pressed.png",
        ShowInfomation)
    local rank = SpriteUtils.createSprite(rank_param)
    offset.y = -1*(rank:getContentSize().height / 2 + Size.AutoSize(8))
    LabelUtils.attachTextToNode(rank,"战绩",fontSetting,offset)
    layer:addChild(rank,1)

    -- setting
    local setting = cc.Sprite:create("square/setting.png")
    local setting_pos = PositionUtils.getRelativePosition(rank,RIGHT,BOTTOM,Size.AutoSize(80),Size.AutoSize(0))
    setting:setPosition(setting_pos)
    setting:setAnchorPoint(cc.p(0,0))
    setting:setTag(TAG_SETTING)
    layer:addChild(setting,1)
    ClickUtils.setOnClickListener(setting,ShowInfomation,"square/setting_pressed.png")
    LabelUtils.attachTextToNode(setting,"设置",fontSetting,offset)

    -- market
    local market = cc.Sprite:create("square/market.png")
    local market_pos = PositionUtils.getRelativePosition(rank,LEFT,BOTTOM,Size.AutoSize(-80),Size.AutoSize(0))
    market:setPosition(market_pos)
    market:setAnchorPoint(cc.p(1,0))
    market:setTag(TAG_MARKET)
    layer:addChild(market,1)
    ClickUtils.setOnClickListener(market,ShowInfomation,"square/market_pressed.png")
    offset.x = offset.x + Size.AutoSize(5)
    LabelUtils.attachTextToNode(market,"商城",fontSetting,offset)

end

-- enter room button
function SquareScene:createEnterRoomButton(layer)
    local roomButton = RoomButton.create().target
    roomButton:setPosition(cc.p(display.cx,Size.AutoSize(180)))
    roomButton:setAnchorPoint(cc.p(0,0))
    layer:addChild(roomButton,1)
end

-- user infomation
function SquareScene:createUserHead(layer)
    local user = UserHead.create()
    user.target:setPosition(cc.p(Size.AutoSize(40),display.height - Size.AutoSize(20)))
    user.target:setAnchorPoint(cc.p(0,1))
    layer.user = user
    layer:addChild(user.target,1)
end

-- back
function SquareScene:createBack(layer)
    local back = cc.Sprite:create("square/back.png")
    back:setPosition(cc.p(display.width - Size.AutoSize(20),display.height - Size.AutoSize(20)))
    back:setAnchorPoint(cc.p(1,1))
    layer:addChild(back,1)

    local function goBack(sender)
        display.popScene()
    end

    ClickUtils.setOnClickListener(back, goBack, "square/back_pressed.png")
end

return SquareScene

