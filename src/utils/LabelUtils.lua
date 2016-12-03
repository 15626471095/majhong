--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/20
-- Time: 14:38
-- To change this template use File | Settings | File Templates.
--

local utils = {}

function utils.attachTextToNode(node, text, fontSetting, offset)
    if(node == nil or text == nil) then
        return
    end
    offset = offset or cc.p(0,0)
    fontSetting = utils.fontSettingBuffered(fontSetting)
    local textLabel = cc.LabelTTF:create(text, fontSetting.fontName, fontSetting.fontSize)
    local size = node:getContentSize()
    textLabel:setColor(fontSetting.fontColor)
    textLabel:setAnchorPoint(cc.p(0.5,0.5))
    textLabel:setPosition(cc.p(size.width / 2 + offset.x,size.height / 2 + offset.y))
    node:addChild(textLabel,1)
end

function utils.createText(text,fontSetting)
    fontSetting = utils.fontSettingBuffered(fontSetting)
    local label = cc.LabelTTF:create(text, fontSetting.fontName, fontSetting.fontSize)
    label:setColor(fontSetting.fontColor)
    return label
end


function utils.fontSettingBuffered(fontSetting)
    fontSetting = fontSetting or {
        fontName = display.DEFAULT_TTF_FONT,
        fontSize = display.DEFAULT_TTF_FONT_SIZE,
        fontColor = display.COLOR_BLACK
    }
    fontSetting.fontName = fontSetting.fontName or display.DEFAULT_TTF_FONT
    fontSetting.fontSize = fontSetting.fontSize or display.DEFAULT_TTF_FONT_SIZE
    fontSetting.fontColor = fontSetting.fontColor or display.COLOR_BLACK
    return fontSetting
end

function utils.createFontSetting(fontName, fontSize, fontColor)
    local setting = {}
    setting.fontName = fontName;
    setting.fontSize = fontSize;
    setting.fontColor = fontColor
    return utils.fontSettingBuffered(setting)
end

function utils.createTTFConfig(fontfile,fontSize,outlineSize,distanceFieldEnabled)
    local config = {}
    config.fontFilePath = fontfile;
    config.fontSize = fontSize or display.DEFAULT_TTF_FONT_SIZE
    config.glyphs = cc.GLYPHCOLLECTION_DYNAMIC
    config.outlineSize = outlineSize or 0
    config.distanceFieldEnabled = distanceFieldEnabled or false
    return config
end

return utils
