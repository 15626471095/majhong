--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/27
-- Time: 12:46
-- To change this template use File | Settings | File Templates.
--

local UserInfo = class("UserInfo",function()
    return {}
end)

function UserInfo.create(head,name,coins)
    return UserInfo.new(head,name,coins)
end

function UserInfo:ctor(head,name,coins)
    self.Head = head or "widget/userhead.png"
    self.Name = name or "白白"
    self.Coins = coins or 10086
end

function UserInfo:setInfo(head,name,coins)
    self.Head = head or self.Head
    self.Name = name or self.Name
    self.Coins = coins or self.Conis
end

return UserInfo
