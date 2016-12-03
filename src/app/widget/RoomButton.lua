--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/26
-- Time: 13:28
-- To change this template use File | Settings | File Templates.
--

local RoomButton = class("RoomButton", function()
    return {}
end)

function RoomButton.create()
    local buttons = RoomButton.new()
    return buttons
end

function RoomButton:ctor()
    local bg = "widget/empty.png"
    local bg = display.newSprite(bg)
    self:createButtons(bg)
    self.target = bg
end

function RoomButton:createButtons(bg)
    local fontSetting = {
        fontName = "Arial",
        fontSize = 28,
        fontColor = display.COLOR_YELLOW
    }

    -- button gloabl
    local btn_bg = "square/btn_bg.png"
    local btn_bg_pressed = "square/btn_bg_pressed.png"
    local btn_size = cc.Sprite:create(btn_bg):getContentSize()
    local interval_size = cc.size(Size.AutoSize(30),Size.AutoSize(30))
    local origin = cc.p(0,0)

    local x = 0
    local y = 0
    local master = cc.Sprite:create(btn_bg)
    master:setPosition(cc.p(x,y))
    master:setAnchorPoint(origin)
    master:setTag(TAG_ROOM_MASTER)
    LabelUtils.attachTextToNode(master,"高级场",fontSetting,cc.p(0,5))
    bg:addChild(master,1)
    ClickUtils.setOnClickListener(master,RoomButton.EnterRoom,btn_bg_pressed)

    y = y + btn_size.height + interval_size.height
    local mid = cc.Sprite:create(btn_bg)
    mid:setPosition(cc.p(x,y))
    mid:setAnchorPoint(origin)
    mid:setTag(TAG_ROOM_MID)
    LabelUtils.attachTextToNode(mid,"中级场",fontSetting, cc.p(0,5))
    bg:addChild(mid,1)
    ClickUtils.setOnClickListener(mid,RoomButton.EnterRoom,btn_bg_pressed)

    y = y + btn_size.height + interval_size.height
    local freshman =  cc.Sprite:create(btn_bg)
    freshman:setPosition(cc.p(x,y))
    freshman:setAnchorPoint(origin)
    freshman:setTag(TAG_ROOM_FRESHMAN)
    LabelUtils.attachTextToNode(freshman,"新手场",fontSetting,cc.p(0,5))
    bg:addChild(freshman,1)
    ClickUtils.setOnClickListener(freshman,RoomButton.EnterRoom,btn_bg_pressed)

    x = x + btn_size.width + interval_size.width
    local enterRoom = cc.Sprite:create(btn_bg)
    enterRoom:setPosition(cc.p(x,y))
    enterRoom:setAnchorPoint(origin)
    enterRoom:setTag(TAG_ROOM_ADD)
    LabelUtils.attachTextToNode(enterRoom,"加入房间",fontSetting,cc.p(0,5))
    bg:addChild(enterRoom, 1)
    ClickUtils.setOnClickListener(enterRoom,RoomButton.EnterRoom,btn_bg_pressed)

    y = y - (btn_size.height + interval_size.height)
    local createRoom = cc.Sprite:create(btn_bg)
    createRoom:setPosition(cc.p(x ,y))
    createRoom:setAnchorPoint(origin)
    createRoom:setTag(TAG_ROOM_CREATE)
    LabelUtils.attachTextToNode(createRoom,"创建房间",fontSetting,cc.p(0,5))
    bg:addChild(createRoom, 1)
    ClickUtils.setOnClickListener(createRoom,RoomButton.EnterRoom,btn_bg_pressed)

    y = y - (btn_size.height + interval_size.height)
    local quickGame = cc.Sprite:create("square/btn1_bg.png")
    quickGame:setPosition(cc.p(x ,y))
    quickGame:setAnchorPoint(origin)
    quickGame:setTag(TAG_ROOM_CREATE)
    LabelUtils.attachTextToNode(quickGame,"快速开始",fontSetting,cc.p(0,5))
    bg:addChild(quickGame, 1)
    ClickUtils.setOnClickListener(quickGame,RoomButton.EnterRoom,"square/btn1_bg_pressed.png")

    -- resize bg
    local width = btn_size.width * 2 + interval_size.width + 10
    local height = btn_size.height * 3 + interval_size.height * 2 + 10
    bg:setTextureRect(cc.rect(0,0,width,height))
end

function RoomButton.EnterRoom(sender)
    local tag = sender:getTag()
    if tag == nil then
        return
    end
    if tag == TAG_ROOM_ADD then
        print("add")
    elseif tag == TAG_ROOM_CREATE then
        print("create")
    elseif tag == TAG_ROOM_FRESHMAN then
        print("freshman")
    elseif tag == TAG_ROOM_MID then
        print("mid")
    elseif tag == TAG_ROOM_MASTER then
        print("master")
    end
    local scene = GameScene.create()
    display.pushScene(scene, "RANDOM")
end

return RoomButton

