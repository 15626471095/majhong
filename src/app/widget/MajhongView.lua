--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/26
-- Time: 19:37
-- To change this template use File | Settings | File Templates.
--

local MajhongView = class("MajhongView",function()
    local path = "widget/majhong/"
    display.loadSpriteFrames(path.."1.plist",path.."1.png")
    display.loadSpriteFrames(path.."1_out.plist",path.."1_out.png")
    display.loadSpriteFrames(path.."2.plist",path.."2.png")
    display.loadSpriteFrames(path.."3.plist",path.."3.png")
    display.loadSpriteFrames(path.."4.plist",path.."4.png")
    display.loadSpriteFrames(path.."other.plist",path.."other.png")
    return cc.Layer:create()
end)

function MajhongView.create(parent)
    local layer = MajhongView.new(parent)
    return layer
end

function MajhongView:ctor(parent)
    self.parent = parent
    self.insideBorder = {}
    local player = GameEngine.getInstance():GetPlayerData()

    self:createSelf(player)
    self:createRight(player)
    self:createLeft(player)
    self:createFront(player)

    local players = {}
    players[1] = player
    self:createOutCardView(players)

    self:createClock()

    GameController.getInstance():init(self)
end

function MajhongView:createSelf(player)
    -- self player
    player.Position = Position_Self
    local obj = self.parent.BottomLayer
    local height = obj:getContentSize().height + 10
    local handList = self:createView(player,cc.p(display.cx,height),cc.p(0.5,0),true,false)
    self.insideBorder.bottom = height + handList:getContentSize().height
    self.Self = handList
    self:addChild(handList.list,1)
end

function MajhongView:createRight(player)
    player.Position = Position_Right
    local x = display.width - 100
    local handList = self:createView(player,cc.p(x,20),cc.p(1,0),false,false)
    self.insideBorder.right = display.width - x + handList:getContentSize().width
    self.Right = handList
    self:addChild(handList.list,1)
end

function MajhongView:createLeft(player)
    player.Position = Position_Left
    local x = 100
    local handList = self:createView(player,cc.p(x,20),cc.p(0,0),true,true)
    self.insideBorder.left = x + handList:getContentSize().width
    self.Left = handList
    self:addChild(handList.list,1)
end

function MajhongView:createFront(player)
    player.Position = Position_Front
    local obj = self.parent.TopLayer
    local height = display.height - obj:getContentSize().height + 10
    local handList = self:createView(player,cc.p(display.cx,height),cc.p(0.5,1),true,true)
    self.insideBorder.top = display.height - height + handList:getContentSize().height
    self.Front = handList
    self:addChild(handList.list,1)
end

function MajhongView:createView(player,position,anchor,orderMode,oppsite)
    local handList = CardList.create(player)
    if oppsite then
        handList:setOppsiteDraw()
    end
    handList:setPosition(position)
    handList:setAnchorPoint(anchor)
    handList:sortHand()
    handList:draw()
    handList:setZOrderMode(orderMode)
    if oppsite then
        handList.list:update(handList.list:getItemCount())
    end
    return handList
end

function MajhongView:update()

end

function MajhongView:createOutCardView(players)
    local out = OutCards.create(self.insideBorder,players)
    self:addChild(out,1)
    self.OutCards = out
end

function MajhongView.getItemOffset(position)
    local offset = 0
    if position == Position_Self then
        offset = Size.AutoSize(3)
    elseif position == Position_Right then
        offset = Size.AutoSize(15)
    elseif position == Position_Left then
        offset = Size.AutoSize(15)
    elseif position == Position_Front then
        offset = Size.AutoSize(3)
    end
    return offset
end

function MajhongView:showButtons(types,callbacks)
    if not types or not callbacks then
        prinnt("Buttons Wrong args!")
        return
    end
    if self.Buttons then
        self:hideButtons()
    end
    local buttons = OpperationLayer.create(types,callbacks)
    buttons:setPosition(display.center)
    buttons:setAnchorPoint(cc.p(0.5,0.5))
    buttons:setTag(10086)
    self:addChild(buttons,100)
    self.Buttons = buttons
end

function MajhongView:hideButtons()
    if self.Buttons then
        self:removeChildByTag(10086)
        self.Buttons = nil
    end
end

function MajhongView:createClock()
    local clock = Clock.create()
    clock:setPosition(display.center)
    self.Clock = clock
    self:addChild(clock,10)
end

return MajhongView
