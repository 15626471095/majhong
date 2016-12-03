
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

-- model
cc.exports.Size = require("model.AutoSize")
cc.exports.Card = require("model.Card")
cc.exports.UserInfo = require("model.UserInfo")
cc.exports.Player = require("model.Player")

-- manager
cc.exports.WifiManager = require("manager.WifiManager")
cc.exports.PowerManager = require("manager.PowerManager")
cc.exports.SpriteCacheManager = require("manager.SpriteCacheManager")
cc.exports.UserSettingManager = require("manager.UserSettingManager")

-- widget
cc.exports.UserHead = require("app.widget.UserHead")
cc.exports.BaseScene = require("app.widget.BaseScene")
cc.exports.MessageBox = require("app.widget.MessageBox")
cc.exports.RoomButton = require("app.widget.RoomButton")
cc.exports.SettingItem = require("app.widget.SettingItem")
cc.exports.Setting = require("app.widget.Setting")
cc.exports.CardItem = require("app.widget.CardItem")
cc.exports.ListView = require("app.widget.ListView")
cc.exports.CardList = require("app.widget.CardList")
cc.exports.OutCards = require("app.widget.OutCards")
cc.exports.OpperationLayer = require("app.widget.OpperationLayer")
cc.exports.Clock = require("app.widget.Clock")
cc.exports.MajhongView = require("app.widget.MajhongView")


-- utils
cc.exports.SizeUtils = require("utils.SizeUtils")
cc.exports.PositionUtils = require("utils.PositionUtils")
cc.exports.ClickUtils = require("utils.ClickUtils")
cc.exports.LabelUtils = require("utils.LabelUtils")
cc.exports.SpriteUtils = require("utils.SpriteUtils")
cc.exports.EditUtils = require("utils.EditBoxUtils")

-- load scene
cc.exports.LoginScene = require("app.views.LoginScene")
cc.exports.SquareScene = require("app.views.SquareScene")
cc.exports.GameScene = require("app.views.GameScene")
cc.exports.RegisterScene = require("app.views.RegisterScene")

-- Engine
cc.exports.LoginEngine = require("network.LoginEngine")
cc.exports.GameEngine = require("network.GameEngine")
cc.exports.GameController = require("manager.GameController")

function MainScene:onCreate()
    self:addChild(self:createLayer())
end

function MainScene:createLayer()
    local layer = cc.Layer:create()

    -- background
    local background = cc.Sprite:create("login/background.png")
    SizeUtils.resize(background)
    background:setPosition(display.cx,display.cy)
    layer:addChild(background)

    local function callback(sender)
        local loginScene = LoginScene.create()
        display.runScene(loginScene,"RANDOM")
    end

    ClickUtils.setOnClickListener(background, callback)
    local acf = cc.CallFunc:create(callback)
    layer:runAction(acf)

    return layer
end

return MainScene
