--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/22
-- Time: 14:06
-- To change this template use File | Settings | File Templates.
--

local engine = {}

function engine.Login(account, password)
    print("start login")
    if account and account ~= "" and password == "123" then
        print("login success")
        return true
    else
        print("login failed")
        return false
    end
end

function engine.Register(account,password)
    print("register login")
    if account and account ~= "" and password == "123" then
        print("register success")
        return true
    else
        print("register failed")
        return false
    end
end

cc.exports.LOGIN_WAY = {
    qq = 1,
    wechat = 2,
    weibo = 3
}

function engine.LoginViaOther(way)
    print(way)
    return true
end

function engine.GetDynamicCode(phone)
    if(engine.PhoneNumberCheck(phone)) then
        -- send request
        return true
    else
        return false
    end
end

function engine.PhoneNumberCheck(phone)
    return true
end

return engine

