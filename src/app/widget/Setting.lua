--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/26
-- Time: 15:02
-- To change this template use File | Settings | File Templates.
--

local Setting = class("Setting",function()
    return cc.Layer:create()
end)

function Setting.create()
    local setting = Setting.new()
    return setting
end

function Setting:ctor()
    local bg = display.newSprite("widget/setting/background.png")
    bg:setPosition(display.cx,display.cy)
    self:addChild(bg)
    self.bg = bg
    self:createSettingItem()
    self:createClose()
    self:createButtons()

    local listener = cc.EventListenerTouchOneByOne:create()
    local function onTouchBegan(touch, event)
        return self:onTouchBegan(touch,event)
    end
    local function onTouchMoved(touch,event)
        self:onTouchMoved(touch,event)
    end
    local function onTouchEnded(touch,event)
        self:onTouchEnded(touch,event)
    end
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
    listener:setSwallowTouches(true)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

end

function Setting:onTouchBegan(touch, event)
    return true
end

function Setting:onTouchMoved(touch, event)

end

function Setting:onTouchEnded(touch, event)
    local curLocation = self:convertToNodeSpace(touch:getLocation())
    local rect = self.bg:getBoundingBox()
    if cc.rectContainsPoint(rect, curLocation) then
        print("point in rect")
    else
        self:removeFromParent(true)
    end
end

function Setting:createSettingItem()
    local UserSetting = UserSettingManager.getUserSetting()

    local offset = Size.AutoSize(75)

    local effect = SettingItem.create("widget/setting/effect.png","音效",UserSetting.effect,SettingItem.TYPE_EFFECT)
    effect:setPosition(cc.p(display.cx,display.cy + offset))
    self:addChild(effect,1)

    local music = SettingItem.create("widget/setting/music.png","音乐", UserSetting.music,SettingItem.TYPE_MUSIC)
    music:setPosition(cc.p(display.cx,display.cy))
    self:addChild(music,1)

    local varbate = SettingItem.create("widget/setting/varbate.png","震动", UserSetting.varbate,SettingItem.TYPE_VARBATE)
    varbate:setPosition(cc.p(display.cx, display.cy - offset))
    self:addChild(varbate,1)

end

function Setting:createButtons()
    local function Buttons(sender)
        print("buttons")
    end

    local btn_bg = "widget/setting/btn.png"
    local btn_bg_pressed = "widget/setting/btn_pressed.png"
    local fontSetting = {
        fontName = "Arial",
        fontSize = "32",
        fontColor = cc.c3b(234,232,48)
    }

    local pos = cc.p(display.cx,Size.AutoSize(150))

    local param = SpriteUtils.createSpriteParam(
        btn_bg,
        pos,
        cc.p(0.5,0.5),
        nil,
        btn_bg_pressed,
        Buttons
    )
    local feedback = SpriteUtils.createSprite(param)
    LabelUtils.attachTextToNode(feedback,"反馈",fontSetting)
    self:addChild(feedback,1)

    local pos_left = cc.p(pos.x - Size.AutoSize(160),pos.y)
    local pos_right = cc.p(pos.x + Size.AutoSize(160),pos.y)

    param = SpriteUtils.createSpriteParam(
        btn_bg,
        pos_left,
        cc.p(0.5,0.5),
        nil,
        btn_bg_pressed,
        Buttons
    )
    local rule = SpriteUtils.createSprite(param)
    LabelUtils.attachTextToNode(rule,"规则",fontSetting)
    self:addChild(rule,1)

    param = SpriteUtils.createSpriteParam(
        btn_bg,
        pos_right,
        cc.p(0.5,0.5),
        nil,
        btn_bg_pressed,
        Buttons
    )
    local about = SpriteUtils.createSprite(param)
    LabelUtils.attachTextToNode(about,"关于",fontSetting)
    self:addChild(about,1)
end

function Setting:createClose()
    local function Close(sender)
        self:removeFromParent(true)
    end

    local offset = cc.p(Size.AutoSize(200),Size.AutoSize(140))
    local param = SpriteUtils.createSpriteParam(
        "widget/setting/close.png",
        cc.p(display.width - offset.x,display.height - offset.y),
        cc.p(1,1),
        nil,
        "widget/setting/close_pressed.png",
        Close
    )
    local close = SpriteUtils.createSprite(param)
    self:addChild(close,1)
end

return Setting

