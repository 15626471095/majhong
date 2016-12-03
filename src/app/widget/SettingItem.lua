--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/26
-- Time: 16:19
-- To change this template use File | Settings | File Templates.
--

local SettingItem = class("SettingItem",function()
    SpriteCacheManager.addSpriteFrame("widget/setting/toggle_on.png")
    SpriteCacheManager.addSpriteFrame("widget/setting/toggle_off.png")
    return {}
end)

SettingItem.toggle_on = "widget/setting/toggle_on.png"
SettingItem.toggle_off = "widget/setting/toggle_off.png"

SettingItem.fontSetting = {
    fontName = "Arial",
    fontSize = "32",
    fontColor = cc.c3b(81,179,53)
}

SettingItem.TYPE_EFFECT = 1
SettingItem.TYPE_MUSIC = 2
SettingItem.TYPE_VARBATE = 3

function SettingItem.create(icon,text,state,type)
    local  item = SettingItem.new(icon,text,state,type)
    return item.target
end

function SettingItem:ctor(icon,text,state,type)
    self.icon = icon
    self.text = text
    self.state = state
    self.type = type
    local bg = display.newSprite("widget/empty.png")
    bg:setTextureRect(cc.rect(0,0,270,50))
    self.target = bg
    self:createItem()
end

function SettingItem:createItem()
    local target = self.target
    local size = target:getContentSize()

    local icon = display.newSprite(self.icon)
    icon:setPosition(cc.p(0,size.height/2))
    icon:setAnchorPoint(cc.p(0,0.5))
    target:addChild(icon,1)

    local icon_size = icon:getContentSize()
    local text = LabelUtils.createText(self.text,SettingItem.fontSetting)
    text:setPosition(cc.p(icon_size.width+Size.AutoSize(20),size.height/2))
    text:setAnchorPoint(cc.p(0,0.5))
    target:addChild(text,1)

    local state
    if self.state == true then
        state = SettingItem.toggle_on
    else
        state = SettingItem.toggle_off
    end
    local toggle = cc.Sprite:createWithSpriteFrame(SpriteCacheManager.getSpriteFrame(state))
    toggle:setPosition(cc.p(size.width,size.height/2))
    toggle:setAnchorPoint(cc.p(1,0.5))
    target:addChild(toggle,1)
    self.toggle = toggle
    self:addToggleListener()
    -- click listener to add

end

function SettingItem:addToggleListener()
    local function onTouchBegan(touch,event)
        local target = event:getCurrentTarget()
        local locationInNode = target:convertToNodeSpace(touch:getLocation())
        local size = target:getContentSize()
        local rect = cc.rect(0,0,size.width, size.height)
        if cc.rectContainsPoint(rect, locationInNode) then
            local state
            if self.state == true then
                self.state = false
                state = SettingItem.toggle_off
            else
                self.state = true
                state = SettingItem.toggle_on
            end
            UserSettingManager.set(self.type,self.state)
            target:setSpriteFrame(SpriteCacheManager.getSpriteFrame(state))
            return true
        end
        return false
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)

    local enentDispatcher = cc.Director:getInstance():getEventDispatcher()
    enentDispatcher:addEventListenerWithSceneGraphPriority(listener,self.toggle)
end

return SettingItem
