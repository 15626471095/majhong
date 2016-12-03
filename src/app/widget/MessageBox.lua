--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/22
-- Time: 14:23
-- To change this template use File | Settings | File Templates.
--

local MSG_BOX_OK = 1
local MSG_BOX_OK_CANCEL =2


local msgBoxLayer = class("msgBoxLayer",function()
    return cc.Layer:create()
end)


function msgBoxLayer.create(dtype, text, callbackfunc)
    local layer = msgBoxLayer.new(dtype,text,callbackfunc)
    return layer
end

--初始化
function msgBoxLayer:ctor(dtype,text,callbackfunc)
    print("MsgBox:ctor_dtype=",dtype,"MsgBox:ctor_text=",text,"MsgBox:ctor_callback",callbackfunc)
    self.dtype = dtype
    self.text = text
    self.callbackfunc = callbackfunc
    self.winSize = cc.Director:getInstance():getWinSize()
    self:setVisible(true)
    self:setLocalZOrder(999)
    self:setContentSize(self.winSize)
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
    self:createMsgBox()
end

function msgBoxLayer:createMsgBox()
    local background = cc.Scale9Sprite:create("widget/background.png")
    self.bg = background
    local label = ccui.Text:create()
    label:setTextAreaSize(cc.size(350,0))
    label:setFontName("Arial")
    label:setColor(cc.c3b(0,255,255))
    label:setFontSize(20)
    label:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
    label:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
    label:setString(self.text)
    local labelContentSize = label:getTextAreaSize();

    local msgBoxHeight = labelContentSize.height + 200
    background:setContentSize(cc.size(400,msgBoxHeight))
    background:setPosition(cc.p(self.winSize.width/2,self.winSize.height/2))
    self:addChild(background)

    local contentSize = background:getContentSize()
    label:setPosition(cc.p(labelContentSize.width-150,msgBoxHeight-50))
    background:addChild(label,1)

    --关闭弹出框
    local function cancelMsgBoxEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            self:removeFromParent(true)
        end
    end
    --执行回调函数，并关闭弹出框
    local function okMsgBoxEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            if self.callbackfunc then
                self.callbackfunc()
            end
            self:removeFromParent(true)
        end
    end

    --创建只有确定按钮的弹出框
    if self.dtype == MSG_BOX_OK then

        local okButton = ccui.Button:create()
        background:addChild(okButton)
        okButton:loadTextures("widget/btn_background.png","widget/btn_background_pressed.png","")
        okButton:setPosition(cc.p(contentSize.width/2,50))
        okButton:setTouchEnabled(true)
        okButton:addTouchEventListener(cancelMsgBoxEvent)
        local okButtonSize = okButton:getContentSize()
        local okButtonLabel = cc.Sprite:create()
        okButtonLabel:setTexture("widget/confirm.png")
        okButtonLabel:setPosition(cc.p(okButtonSize.width/2,okButtonSize.height/2))
        okButton:addChild(okButtonLabel)

        --创建具有确定和取消按钮的弹出框
    elseif self.dtype == MSG_BOX_OK_CANCEL then
        local okButton = ccui.Button:create()
        background:addChild(okButton)
        okButton:loadTextures("widget/btn_background.png","widget/btn_background_pressed.png","")
        okButton:setTouchEnabled(true)
        okButton:setPosition(cc.p(contentSize.width/2+100,50))
        okButton:addTouchEventListener(okMsgBoxEvent)
        local okButtonSize = okButton:getContentSize()
        local okButtonLabel = cc.Sprite:create()
        okButtonLabel:setTexture("widget/confirm.png")
        okButtonLabel:setPosition(cc.p(okButtonSize.width/2,okButtonSize.height/2))
        okButton:addChild(okButtonLabel)

        local cancelButton = ccui.Button:create()
        background:addChild(cancelButton)
        cancelButton:loadTextures("widget/btn_background.png","widget/btn_background_pressed.png","")
        cancelButton:setTouchEnabled(true)
        cancelButton:setPosition(cc.p(contentSize.width/2-100,50))
        cancelButton:addTouchEventListener(cancelMsgBoxEvent)
        local cancelButtonSize = cancelButton:getContentSize()
        local cancelButtonLabel = cc.Sprite:create()
        cancelButtonLabel:setTexture("widget/cancel.png")
        cancelButtonLabel:setPosition(cc.p(cancelButtonSize.width/2,cancelButtonSize.height/2))
        cancelButton:addChild(cancelButtonLabel)
    end
end

function msgBoxLayer:onTouchBegan(touch, event)
    return true
end

function msgBoxLayer:onTouchEnded(touch, event)
    local curLocation = self:convertToNodeSpace(touch:getLocation())
    local rect = self.bg:getBoundingBox()
    if cc.rectContainsPoint(rect, curLocation) then
        print("point in rect")
    else
        self:removeFromParent(true)
    end
end

function msgBoxLayer:onTouchMoved(touch, event)

end

return msgBoxLayer

