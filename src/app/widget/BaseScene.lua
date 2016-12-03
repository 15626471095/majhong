--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/22
-- Time: 14:58
-- To change this template use File | Settings | File Templates.
--

local BaseScene = {}

function BaseScene.create()
    local scene = cc.Scene:create()
    function scene:showMessageBox(dtype,text,callback)
        local messageBox = MessageBox.create(dtype,text,callback)
        self:addChild(messageBox, 100)
    end
    return scene
end

return BaseScene