--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/12/1
-- Time: 14:31
-- To change this template use File | Settings | File Templates.
--

local GameController = class("GameController",function()
    return {}
end)

function GameController.getInstance()
    if not GameController.instance then
        GameController.instance = GameController.new()
    end
    return GameController.instance
end

function GameController:ctor()
    self.isInit = false
end

function GameController:init(majhongView,room_number,order)
    self.view = majhongView
    self.isInit = true
    self.isFirstTurn = true
    self.isWaitForGang = false
    self.order = order
    self.turns = self:getTurns(order)
    self.room_number = room_number
    Client.addPacketListener(self)
    print("GameController init!")
end

function GameController:clear()
    if self.isInit then
        self.turns = nil
        self.view:onClear()
        self.view = nil
        self.isInit = false
        self.isFirstTurn = true
        self.isWaitForGang = false
        self.room_number = nil
        self.order = nil
        Client.removePacketListener(self)
        print("GameController clear!")
    end
end

function GameController:Start()
    AudioManager.getInstance():playEffect("start")
    self.view:hideAllReadyTips()
    self:Turns(self.turns)
    -- 准备
    self.view:setRemainCard(84)
    self.view.RemainCard:setVisible(true)
    self.view.Users[self.turns]:showZhuang()
end

function GameController:Resume()
    self:init(self.view,self.room_number,self.order)
    self.view:Resume()
end

function GameController:getTurns(order)
    local turns
    if order ~= 1 then
        turns = 6 - order
    else
        turns = 1
    end
    return turns
end

function GameController:getOtherTurns(order)
    local turns = 1 + order-self.order
    if turns <= 0 then
        turns = turns + 4
    end
    return turns
end

function  GameController:getRoomInfo(onSuccess,onFailed)
    local this = self
    local phone = UserManager.getInstance():getUserInfo().phone
    print(phone)
    Client.GetRoomInfo(phone,function(args)
        if args.status == "success" then
            print(args.room_number)
            print(args.order)
            if onSuccess then
                onSuccess(args.room_number,args.order)
            end
            local other_users = args.other_users
            if other_users then
                print("other_user count:",#other_users)
                for i=1,#other_users do
                    local temp = {}
                    temp.order = other_users[i].order
                    temp.user_info = other_users[i].info
                    temp.ready = other_users[i].ready
                    self:inform_other_user_info(temp)
                end
            end
        else
            print(args.erorr_msg)
            if onFailed then
                onFailed(args.erorr_msg)
            end
        end
    end)
end

function GameController:inform_other_user_info(args)
    print("inform_other_user_info",args.order,args.user_info.name,args.ready)
    local turns = self:getOtherTurns(args.order)
    local user = args.user_info
    local ready = args.ready
    --[[
    user.name = "test"
    user.sex = 1
    user.gold = 1000
    user.matches = 2343
    user.win = 1000
    --]]
    user = User.create():set(user.name,user.sex,user.gold,user.matches,user.win)
    UserManager.getInstance():setOtherUserInfo(turns,user)
    self.view.Users[turns]:setUserInfo(user)
    if ready == 1 then
        self.view:showReadyTip(turns)
    end
end

function GameController:changeReadyState(onSuccess,onFailed)
    local room_number = self.room_number
    local order = self.order
    if not room_number or not order then
        cc.Director:getInstance():getRunningScene():showMessageBox(1,"获取房间信息失败，请重试！")
        onFailed()
        return 
    end
    Client.Change_ready_state(room_number,order,function(args)
        if args.status == "success" then
            if onSuccess then
                onSuccess()
            end
        else
            print(args.erorr_msg)
            if onFailed then
                onFailed(args.erorr_msg)
            end
        end
    end)
end

function GameController:other_ready_state_change(args)
    local turn = self:getOtherTurns(args.order)
    print("other_ready_state_change",turn)
    local isReady = args.state
    if isReady == 1 then
        self.view:showReadyTip(turn)
    else
        self.view:hideReadyTip(turn)
    end
end

function GameController:send_card_list(args,session,response)
    --table.sort(args.card_list)
    --print(table.concat(args.card_list, ", "))

    local cards = {}
    for i=1,#(args.card_list) do
        local card = Card.create()
        card:set(args.card_list[i])
        cards[i] = card
    end

    local player = Player.create(cards)
    self.view:createSelf(player)

    local temp = {}
    for i=1,13 do
        temp[i] = Card.create()
        temp[i]:setEmpty()
    end
    player = Player.create(temp)
    self.view:createRight(player)
    self.view:createLeft(player:clone())
    self.view:createFront(player:clone())
    self.view:createOutCardView()
    self.view:hideButtons()
    self.view.ResponseTip:setVisible(false)

    self:Start()    
end

function GameController:draw_and_play(args,session,response)
    self:Next()
    print("draw_and_play", self.turns,"get card:", args.card)
    if self.turns ~= Position_Self then
        print("turns error!")
        return
    end
    local position = Position_Self
    local card = Card.create()
    card:set(args.card)

    local can_win = args.can_win
    local can_4_ming = args.ming_4
    local can_4_an = args.an_4
    local an_4_list = args.an_4_list

    self.view:TakeCard(card,position,function()
        local playcard = self.view:PlayCard(1,position)
        if playcard then
            self.view.Clock:Stop()
            Client.PlayCard(playcard:toNumber(),false,false,response)
            print("timeout ! auto play the 1st card!")
            self.view:hideButtons()
        end
    end)
    local types = {}
    local callbacks = {}
    types[1] = TAG_PLAY
    callbacks[1] = function(sender)
        local playcard = self.view:PlayCard(nil,position)
        if playcard then
            self.view.Clock:Stop()
            Client.PlayCard(playcard:toNumber(),false,false,response)
        else
            cc.Director:getInstance():getRunningScene():showMessageBox(1,"请选择一张牌!")
            --print("please selected a card!!!!!")
            self.view:showButtons(types,callbacks)
        end
    end
    if can_win then
        types[#types+1] = TAG_HU
        callbacks[#callbacks+1] = function (sender)
            Client.PlayCard(0,true,false,response)
            --self:Next()
        end
    end
    local can_4 = can_4_an or can_4_ming
    if can_4 then
        local gang_list = {}
        if can_4_ming then
            gang_list[#gang_list+1] = card
        end
        if can_4_an and an_4_list then
            for i=1,#an_4_list do
                local c = Card.create():set(an_4_list[i])
                gang_list[#gang_list+1] = c
            end
        end
        print("gang count:",#gang_list)
        for k,v in pairs(gang_list) do
            print(k,v)
        end
        types[#types+1] = TAG_GANG
        callbacks[#callbacks+1] = function (sender)
            if an_4_list and #an_4_list > 1 then
                self.view.Clock:Count(10,Position_Self,function()
                    self.view:autoSelectingCard()
                end)
                self.view:showCardSelectView(gang_list,function(selectedCard)
                    print("select card:",selectedCard:toNumber())
                    self.view:Gang(selectedCard,Position_Self,Position_Self)
                    self:Turns(Position_Self)
                    self.isWaitForGang = true
                    Client.PlayCard(selectedCard:toNumber(),false,true,response)
                end)
            else
                self.view:Gang(card,Position_Self,Position_Self)
                self:Turns(Position_Self)
                self.isWaitForGang = true
                Client.PlayCard(card:toNumber(),false,true,response)
            end            
        end
    end
    self.view:showButtons(types,callbacks)
end

function GameController:win(args)
    print("win",args.order, #args.other_cards)
    local win_turns = self:getOtherTurns(args.order)
    local other_cards = args.other_cards
    local cards = {}
    for i=1,#other_cards do
        local player_card = other_cards[i]
        local order = player_card.order
        local turn = self:getOtherTurns(order)
        if order ~= self.order then
            cards[turn] = player_card.card_list
        end
    end
    self.view:Hu(win_turns,cards)
    self.view.Clock:stopSchedule()
    self.view.Clock:Hide()
    self.view.Users[win_turns]:showZimo()

    local temp_gold_change = {}
    for i=1,#(args.gold_change) do
        local temp = args.gold_change[i]
        local turn = self:getOtherTurns(temp.order)
        temp_gold_change[turn] = temp.change
    end
    self.view:showWinDetailLayer(win_turns,temp_gold_change)
    local types = {TAG_RESUME,TAG_WIN_DETAIL}
    local callbacks = {function()
        self:Resume()
    end,function()
        self.view:showWinDetailLayer(win_turns,temp_gold_change)
    end}
    self.view:showButtons(types,callbacks,true)
end

function GameController:flow()
    print("flow")
end

function GameController:peng(args,session,response)
    print("peng")
    self:Turns(Position_Self)
    self.view.Clock:Count(30,Position_Self,function (sender)
        local playcard = self.view:PlayCard(1,position)
        if playcard then
            self.view.Clock:Stop()
            Client.Peng(playcard:toNumber(),response)
            self.view:hideButtons()
            print("timeout ! auto play the 1st card!")
        end
    end)
    local types = {}
    local callbacks = {}
    types[1] = TAG_PLAY
    callbacks[1] = function(sender)
        local playcard = self.view:PlayCard(nil,self.turns)
        if playcard then
            Client.Peng(playcard:toNumber(),response)
        else
            cc.Director:getInstance():getRunningScene():showMessageBox(1,"请选择一张牌!")
            --print("please selected a card!!!!!")
            self.view:showButtons(types,callbacks)
        end
    end
    self.view:showButtons(types,callbacks)
end

function GameController:inform_other(args)
    local order = args.order
    local stype = args.type
    local turns = self:getOtherTurns(order)
    local card = args.card
    print("inform_other",stype,"card:",card,"turns",turns,"self turns:",self.turns)
    if stype == "draw" then
        self:Next()
        self.view:TakeCard(nil,self.turns)
    elseif stype == "peng" then
        self.view:Peng(nil,self.turns,turns)
        self.view.Clock:Count(30,turns)
        self:Turns(turns)
    elseif stype == "gang" then
        local temp = Card.create()
        temp:set(card)
        self.view:Gang(temp,self.turns,turns)
        self.view.Clock:Count(30,turns)
        self:Turns(turns)
        self.isWaitForGang = true
    end
end

function GameController:other_play(args,session,response)
    local card = Card.create()
    card:set(args.card)
    self.view:PlayCard(card,self.turns)
    local peng = args.can_3
    --local peng = self:canPeng(args.card)
    local gang = args.can_4
    print("other_play:",args.card,"can_3:",peng,"can_4:",gang)
    local responseTime = 10
    if peng or gang then
        self.view.Clock:Count(responseTime,Position_Self,function (sender)
            Client.Other_play_response(false,false,response)
            self.view:hideButtons()
        end)
        local types = {}
        local callbacks = {}
        if peng then
            types[#types+1] = TAG_PENG
            callbacks[#callbacks+1] = function (sender)
                self.view:Peng(nil,self.turns,Position_Self)
                Client.Other_play_response(true,false,response)
            end
        end
        if gang then
            types[#types+1] = TAG_GANG
            callbacks[#callbacks+1] = function (sender)
                self.view:Gang(nil,self.turns,Position_Self)
                self:Turns(Position_Self)
                self.isWaitForGang = true
                Client.Other_play_response(false,true,response)
            end
        end
        types[#types+1] = TAG_CANCEL
        callbacks[#callbacks+1] = function (sender)
            Client.Other_play_response(false,false,response)
        end
        self.view:showButtons(types,callbacks)
    else
        Client.Other_play_response(false,false,response)
        --self.view:WaitForResponse(self.turns,responseTime)
        --self.view.Clock:Count(responseTime,self.turns)
    end
end

function GameController:Turns(nextTurns)
    self.view:Turns(nextTurns)
    self.turns = nextTurns
end

function GameController:Next()
    --self.view:hideButtons()
    if self.isFirstTurn or self.isWaitForGang then 
        self.isFirstTurn = false
        self.isWaitForGang = false
        return
    end
    local count = 4
    local turns = self.turns + 1
    if turns > count then
        turns = turns - count
    end
    self:Turns(turns)
end

function GameController:getRandomCard()
    local types = {"tong","tiao","wang","feng" }
    local feng = {"dong","nan","xi","bei","zhong","fa","bai" }
    local type = math.random(1,4)
    type = types[type]
    local number
    if type == "feng" then
        number = feng[math.random(1,7)]
    else
        number = math.random(1,9)
    end
    local card = Card.create(type,number,false,false)
    return card
end

return GameController
