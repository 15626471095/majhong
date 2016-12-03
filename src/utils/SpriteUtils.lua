--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/21
-- Time: 13:38
-- To change this template use File | Settings | File Templates.
--

local utils = {}

function utils.createSprite(param)
    local sprite = display.newSprite(param.normal)
    sprite:setPosition(param.position)
    sprite:setAnchorPoint(param.anchor)
    if param.tag then
        sprite:setTag(param.tag)
    end
    if param.pressed and param.onClick then
        ClickUtils.setOnClickListener(sprite,param.onClick,param.pressed)
    end
    return sprite
end

function utils.createSpriteParam(normal_file,position,anchorPoint,tag,pressed_file,onClick)
    local param = {}
    normal_file = normal_file or "HelloWorld.png"
    position = position or display.center
    anchorPoint = anchorPoint or display.CENTER

    param.normal = normal_file
    param.pressed = pressed_file
    param.onClick = onClick
    param.position = position
    param.anchor = anchorPoint
    param.tag = tag

    return param
end

return utils

