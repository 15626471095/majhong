--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/20
-- Time: 13:09
-- To change this template use File | Settings | File Templates.
--

local utils = {}

local cache = cc.SpriteFrameCache:getInstance()

function utils.setOnClickListener(node,callback, pressed_file)
    local press = false
    local normal_file
    if pressed_file then
        press = true
        local pressedFrame = cc.Sprite:create(pressed_file):getSpriteFrame()
        local normalFrame = node:getSpriteFrame()
        normal_file = string.sub(pressed_file,1,-13)
        cache:addSpriteFrame(normalFrame, normal_file)
        cache:addSpriteFrame(pressedFrame, pressed_file)
    end

    local function onTouchBegan(touch, event)
        local target = event:getCurrentTarget()
        local locationInNode = target:convertToNodeSpace(touch:getLocation())
        local size = target:getContentSize()
        local rect = cc.rect(0,0,size.width, size.height)
        if cc.rectContainsPoint(rect, locationInNode) then
            if(press == true)then
                target:setSpriteFrame(cache:getSpriteFrame(pressed_file))
            end
            return true;
        end
        return false
    end

    local function onTouchEnd(touch, event)
        local target = event:getCurrentTarget()
        if(press)then
            target:setSpriteFrame(cache:getSpriteFrame(normal_file))
        end
        callback(target)
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchEnd,cc.Handler.EVENT_TOUCH_ENDED)

    local enentDispatcher = cc.Director:getInstance():getEventDispatcher()
    enentDispatcher:addEventListenerWithSceneGraphPriority(listener,node)
end

return utils
