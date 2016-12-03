--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/19
-- Time: 17:10
-- To change this template use File | Settings | File Templates.
--


local utils = {}

function utils.createEditBox(background, editBackground, edge,fontSetting)
    local function handler(strEventName,sender)

        if strEventName == "began" then
            --sender:setPlaceHolder("")
        elseif strEventName == "ended" then
        elseif strEventName == "return" then
        elseif strEventName == "changed" then
        end
    end

    local background = cc.Sprite:create(background)
    local accountBackgroundSize = background:getContentSize()
    background:setPosition(display.center)

    local editboxSize = cc.size(accountBackgroundSize.width - edge - 5,accountBackgroundSize.height - 5)
    local editbox = cc.EditBox:create(editboxSize,editBackground)
    editbox:setFontSize(fontSetting.fontSize)
    editbox:setFontColor(fontSetting.fontColor)
    --local editBoxPos = background:convertToWorldSpace(cc.p(edge + editboxSize.width/2 ,accountBackgroundSize.height / 2))
    --editbox:setPosition(editBoxPos)
    editbox:setPosition(cc.p(edge + editboxSize.width/2 ,accountBackgroundSize.height / 2))
    editbox:registerScriptEditBoxHandler(handler)
    background:addChild(editbox,1)
    return editbox,background
end

return utils