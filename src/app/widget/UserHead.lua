--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/23
-- Time: 15:58
-- To change this template use File | Settings | File Templates.
--

local UserHead = class("UserHead",function()
    return {}
end)

cc.exports.USERHEAD = {
    Head_Size = {
        width = 80,
        height = 80
    },
    Head_Layer_Width = 300,

    TAG_USER_IMG = 1,
    TAG_USER_INFO_STR1 = 2,
    TAG_USER_INFO_STR2 = 3,
    TAG_USER_INFO_STR3 = 4,
}

function UserHead.create()
    local userhead = UserHead.new()
    return userhead
end

function UserHead:ctor()
    local bg =  "widget/empty.png"
    local target = cc.Sprite:create(bg,cc.rect(0,0,USERHEAD.Head_Layer_Width,USERHEAD.Head_Size.height))
    target.currentWidth = USERHEAD.Head_Layer_Width
    self:createUserHead(target)
    self.target = target
end

function UserHead:createUserHead(target)

    local userhead = cc.Sprite:create("widget/userhead.png")
    --SizeUtils.resizeTo(userhead,USERHEAD.Head_Size)
    target.headSize = userhead:getContentSize()
    userhead:setPosition(0,0)
    userhead:setAnchorPoint(cc.p(0,0))
    target.img = userhead
    target:addChild(userhead,1)

    local fontSetting = {
        fontColor = display.COLOR_YELLOW,
        fontSize = 20
    }

    local size = userhead:getContentSize()
    local userhead_pos_rightTop = cc.p(size.width,size.height)
    local userhead_pos_rightBottom = cc.p(size.width, 0)
    local str_offset = Size.AutoSize(10)

    -- username
    local str1 = LabelUtils.createText("用户名", fontSetting)
    str1:setPosition(cc.p(userhead_pos_rightTop.x + str_offset,userhead_pos_rightTop.y))
    str1:setAnchorPoint(cc.p(0,1))
    target:addChild(str1,1)
    target.str1 = str1
    local width1 = str1:getContentSize().width

    -- gold coins
    local str2 = LabelUtils.createText("金币 ： 123456",fontSetting)
    str2:setPosition(cc.p(userhead_pos_rightTop.x + str_offset,(userhead_pos_rightTop.y + userhead_pos_rightBottom.y)/2) )
    str2:setAnchorPoint(cc.p(0,0.5))
    target:addChild(str2,1)
    target.str2 = str2
    local width2 = str2:getContentSize().width

    -- room cards
    local str3 = LabelUtils.createText("房卡 ： 5张",fontSetting)
    str3:setPosition(cc.p(userhead_pos_rightBottom.x + str_offset, userhead_pos_rightBottom.y))
    str3:setAnchorPoint(cc.p(0,0))
    target:addChild(str3,1)
    target.str3 = str3
    local width3 = str3:getContentSize().width

    local width = size.width + math.max(width1,width2,width3)
    local cwidth = target.currentWidth
    if(width > cwidth) then
        target:setTextureRect(cc.rect(0,0,width,USERHEAD.Head_Size.height))
    end
end

function UserHead:setHeadImage(img)
    local s = cc.Sprite:create(img);
    SizeUtils.resizeTo(s,self.target.headSize)
    self.target.img:setSpriteFrame(s:getSpriteFrame())
end

function UserHead:setStr(str,index)
    local target = self.target
    local s
    index = index or 1
    if index == 1 then
        s = target.str1
    elseif index == 2 then
        s = target.str2
    elseif index == 3 then
        s = target.str3
    end
    s:setString(str)
end

-- set user infomation
function UserHead:setUserInfo(img,str1,str2,str3)
    local target = self.target
    local frame = cc.Sprite:create(img):getSpriteFrame()
    target.img:setSpritFrame(frame)
    target.str1:setText(str1)
    target.str2:setText(str2)
    target.str3:setText(str3)
end

return UserHead