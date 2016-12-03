--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/20
-- Time: 17:16
-- To change this template use File | Settings | File Templates.
--

local GameScene = class("GameScene", BaseScene.create)

function GameScene.create()
    local scene = GameScene.new()
    return scene
end

function GameScene:ctor()
    self:addChild(self:createGameLayer())
end

function GameScene:createGameLayer()
    local layer = cc.Layer:create()
    self.layer = layer

    -- background
    self:createBackground()

    -- top layer
    self:createTopLayer()

    -- bottom layer
    self:createBottomLayer()

    -- back
    self:createBack()

    -- majhong view
    self:createMajhongView()

    -- opp button
    --self:createOppButton()

    return layer
end


-- opp button
function GameScene:createOppButton()
    local buttons = OpperationLayer.create(4,{1,2,3,4})
    buttons:setPosition(cc.p(0,0))
    buttons :setAnchorPoint(cc.p(0,0))
    self:addChild(buttons,100)
end

-- background
function GameScene:createBackground()
    local background = cc.Sprite:create("game/background.png")
    SizeUtils.resize(background)
    background:setPosition(display.cx,display.cy)
    self.layer:addChild(background)
end

-- back
function GameScene:createBack()
    local function goBack(sender)
        self:removeAllChildren()
        display.popScene()
    end

    local sideOffset = Size.AutoSize(10)

    local param = SpriteUtils.createSpriteParam(
        "game/back.png",
        cc.p(display.width-sideOffset,display.height-sideOffset),
        cc.p(1,1),
        nil,
        "game/back_pressed.png",
        goBack
    )
    local back = SpriteUtils.createSprite(param)
    self.layer:addChild(back,1)
end

-- top layer
function GameScene:createTopLayer()
    -- top layer background
    local param = SpriteUtils.createSpriteParam(
        "game/top.png",
        cc.p(display.cx,display.height),
        cc.p(0.5,1)
    )
    local background = SpriteUtils.createSprite(param)
    background:setScale(0.8)
    self.layer:addChild(background,1)
    self.layer.TopLayer = background

    local top_size = background:getContentSize()
    local sideOffset = Size.AutoSize(50)
    local intervalOffset = Size.AutoSize(35)
    local top_midBaseline = top_size.height / 2

    local battery = PowerManager.newSprite()
    battery:setPosition(cc.p(sideOffset,top_midBaseline))
    battery:setAnchorPoint(cc.p(0,0.5))
    background:addChild(battery,1)

    -- setting
    local function settingCallback(sender)
        GameController.getInstance():Loop()
        print("setting")
    end

    param = SpriteUtils.createSpriteParam(
        "game/setting.png",
        cc.p(top_size.width - sideOffset,top_midBaseline),
        cc.p(1,0.5),
        nil,
        "game/setting_pressed.png",
        settingCallback
    )
    local setting = SpriteUtils.createSprite(param)
    background:addChild(setting,1)

    local size = battery:getContentSize()
    local ops = battery:convertToWorldSpace(cc.p(size.width,size.height / 2))

    local wifi = WifiManager.newSprite()
    wifi:setPosition(background:convertToNodeSpace(cc.p(ops.x + intervalOffset,ops.y)))
    wifi:setAnchorPoint(cc.p(0,0.5))
    background:addChild(wifi,1)

    size = wifi:getContentSize()
    ops = wifi:convertToWorldSpace(cc.p(size.width,size.height / 2))

    -- room state
    local roomFontSetting = LabelUtils.createFontSetting(nil,26,cc.c3b(61,191,173))
    local roomLabel = LabelUtils.createText("房间：1 2 3 4 5 6", roomFontSetting)
    roomLabel:setPosition(background:convertToNodeSpace(cc.p(ops.x + intervalOffset,ops.y)))
    roomLabel:setAnchorPoint(cc.p(0,0.5))
    background.setRoomNumber = function(number)
        if not number then
            return
        end
        roomLabel:setString(string.format("房间："..number))
    end
    background:addChild(roomLabel,1)
end

-- bottom layer
function GameScene:createBottomLayer()
    local param = SpriteUtils.createSpriteParam(
        "game/bottom.png",
        cc.p(display.cx,0),
        cc.p(0.5,0)
    )
    local background = SpriteUtils.createSprite(param)
    background:setScale(0.8)
    self.layer:addChild(background,1)
    self.layer.BottomLayer = background

    local sideOffset = Size.AutoSize(50)
    local bottomOffset = Size.AutoSize(10)
    local intervalOffset = Size.AutoSize(35)

    -- gold conis
    param = SpriteUtils.createSpriteParam(
        "game/gold_coin.png",
        cc.p(sideOffset,bottomOffset),
        cc.p(0,0)
    )
    local gold_icon = SpriteUtils.createSprite(param)
    background:addChild(gold_icon,1)

    local ttfColor = display.COLOR_YELLOW
    local shadow = cc.c4b(0,0,0,160)
    local shadowOffset = cc.size(4,-4)
    local config = LabelUtils.createTTFConfig("fonts/simhei.ttf",50)

    local size = gold_icon:getContentSize()
    local ops = gold_icon:convertToWorldSpace(cc.p(size.width,size.height/2))

    -- gole coin label
    local gold_coin_countLabel = cc.Label:createWithTTF(config,"12000")
    gold_coin_countLabel:setPosition(background:convertToNodeSpace(cc.p(ops.x + 5,ops.y)))
    gold_coin_countLabel:setAnchorPoint(cc.p(0,0.5))
    gold_coin_countLabel:setColor(ttfColor)
    gold_coin_countLabel:enableShadow(shadow,shadowOffset)
    background.setCoins = function(coins)
        if not coins then
            return
        end
        gold_coin_countLabel:setString(coins)
    end
    background:addChild(gold_coin_countLabel,1)

    -- zhuang label
    local zhuang = cc.Label:createWithTTF(config,"庄")
    zhuang:setPosition(cc.p(background:getContentSize().width / 2,bottomOffset))
    zhuang:setAnchorPoint(cc.p(0.5,0))
    zhuang:setColor(ttfColor)
    zhuang:enableShadow(shadow,shadowOffset)
    background:addChild(zhuang,1)

    size = zhuang:getContentSize()
    ops = zhuang:convertToWorldSpace(cc.p(size.width,size.height/2))
    -- flower
    param = SpriteUtils.createSpriteParam(
        "game/flower.png",
        cc.p(background:convertToNodeSpace(cc.p(ops.x + Size.AutoSize(30),ops.y))),
        cc.p(0,0.5)
    )
    local flower = SpriteUtils.createSprite(param)
    background:addChild(flower,1)

    size = flower:getContentSize()
    ops = flower:convertToWorldSpace(cc.p(size.width,size.height/2))

    -- rate label
    local rate = cc.Label:createWithTTF(config,"6")
    rate:setPosition(background:convertToNodeSpace(cc.p(ops.x + Size.AutoSize(10),ops.y)))
    rate:setAnchorPoint(cc.p(0,0.5))
    rate:setColor(ttfColor)
    rate:enableShadow(shadow,shadowOffset)
    background.setRate = function(rates)
        if not rates then
            return
        end
        rate:setString(rates)
    end
    background:addChild(rate,1)

end

function GameScene:createMajhongView()
    local view = MajhongView.create(self.layer)
    view:setPosition(cc.p(0,0))
    view:setAnchorPoint(cc.p(0,0))
    self.layer:addChild(view,2)
    self.majhong = view
end

return GameScene

