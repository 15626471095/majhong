--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/19
-- Time: 18:25
-- To change this template use File | Settings | File Templates.
--

local utils = {}

cc.exports.RIGHT = 1;
cc.exports.LEFT = 2;
cc.exports.TOP = 3;
cc.exports.BOTTOM = 4;

function utils.getRelativePosition(node, directionX, directionY,offsetX , offsetY)
    if(node == nil) then
        return nil
    end
    local size = node:getContentSize()
    local pos = cc.p(0,0)
    if(directionX == RIGHT)then
        pos.x = size.width
        print(pos.x)
    end
    pos.x = pos.x + offsetX
    if(directionY == TOP)then
        pos.y = size.height
    end
    pos.y = pos.y + offsetY
    return node:convertToWorldSpace(pos)
end

return utils
