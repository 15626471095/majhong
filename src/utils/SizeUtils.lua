--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/19
-- Time: 15:46
-- To change this template use File | Settings | File Templates.
--

local utils = {}


function utils.resize(node,scale)
    if(node == nil) then
        return
    end
    if(scale == nil) then
        local size = node:getContentSize()
        local scaleX = display.width / size.width
        local scaleY = display.height / size.height
        node:setScale(scaleX,scaleY)
    else
        node:setScale(scale)
    end
end

function utils.getScale(originalSize, toSize)
    if originalSize and toSize then
        return toSize / originalSize
    end
    return 1
end

function utils.resizeTo(node,size)
    if node == nil or size == nil then
        return
    end
    local s = node:getContentSize()
    local xScale
    if size.width == 0 then
        xScale = 1
    else
        xScale = size.width / s.width
    end
    local yScale
    if size.height == 0 then
        yScale = 1
    else
        yScale = size.height / s.height
    end
    node:setScale(xScale,yScale)
    node:setContentSize(cc.size(s.width*xScale,s.height*yScale))
end

return utils

