--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/12/1
-- Time: 15:34
-- To change this template use File | Settings | File Templates.
--

local OpperationLayer = class("OpperationLayer",function()
    return ccui.Layout:create()
end)

function OpperationLayer.create(types,callbacks)
    return OpperationLayer.new(types,callbacks)
end

function OpperationLayer:ctor(types,callbacks)
    self.types = types
    self.callbacks = callbacks
    self:createButtons()
end

cc.exports.TAG_PENG = 1
cc.exports.TAG_GANG = 2
cc.exports.TAG_HU = 3
cc.exports.TAG_PLAY = 4

function OpperationLayer:createButtons()

    local intervalOffset = Size.AutoSize(50)
    local fontSetting = LabelUtils.createFontSetting(nil,50,display.COLOR_YELLOW)

    local point = cc.p(0,0)
    local size = cc.size(0,0)
    for i=1,#(self.types) do
        local type = self.types[i]

        local param =  SpriteUtils.createSpriteParam(
            "game/btn_background.png",
            point,
            cc.p(0,0),
            type,
            "game/btn_background_pressed.png",
            self.callbacks[i]
        )
        local button = SpriteUtils.createSprite(param)
        self:addChild(button,1)
        local names = {"碰","杠","胡","出牌"}
        LabelUtils.attachTextToNode(button,names[type],fontSetting)
        local buttonSize = button:getContentSize()
        point.x = point.x + intervalOffset + buttonSize.width
        if buttonSize.height > size.height then
            size.height = buttonSize.height
        end
        size.width =  size.width + buttonSize.width
        if i ~= #(self.types) then
            size.width = size.width + intervalOffset
        end
    end
    print(size.width,size.height)
    self:setContentSize(size)
end

return OpperationLayer