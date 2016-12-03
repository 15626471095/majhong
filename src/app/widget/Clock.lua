--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/12/3
-- Time: 11:09
-- To change this template use File | Settings | File Templates.
--

local Clock = class("Clock" ,function()
   return ccui.Layout:create()
end)

function Clock.create()
    return Clock.new()
end

function Clock:ctor()
    local sprite = display.newSprite("widget/majhong/clock.png")
    sprite:setTag(10086)
    sprite:setRotation(-90)
    self:addChild(sprite)
    self:setContentSize(sprite:getContentSize())
end

function Clock:Turns(turn)
    print("turn")
    self:setRotation(180)
end

function Clock:Show()
    self:setVisible(true)
end

function Clock:Hide()
    self:setVisible(false)
end

return Clock