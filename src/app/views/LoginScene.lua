--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/20
-- Time: 12:01
-- To change this template use File | Settings | File Templates.
--

local LoginScene = class("LoginScene",BaseScene.create)

cc.exports.TAG_LOGIN_BTN = 1
cc.exports.TAG_REGISTER_TIP = 2
cc.exports.TAG_FORGET_PASSWORD_TIP = 3
cc.exports.TAG_WECHAT_LOGIN = 4
cc.exports.TAG_QQ_LOGIN = 5
cc.exports.TAG_WEIBO_LOGIN = 6
cc.exports.TAG_ACCOUNT_SPRITE = 7
cc.exports.TAG_ACCOUNT_TEXT = 8
cc.exports.TAG_PASSWORD_SPRITE = 9
cc.exports.TAG_PASSWORD_TEXT = 10
cc.exports.TAG_PASSWORD_CONFIRM_SPRITE = 11
cc.exports.TAG_PASSWORD_CONFIRM_TEXT = 12
cc.exports.TAG_DYNAMIC_CODE_SPRITE = 13
cc.exports.TAG_DYNAMIC_CODE_TEXT = 14
cc.exports.TAG_DYNAMIC_CODE_BTN = 14

function LoginScene.create()
    local scene = LoginScene.new()
    return scene
end

function LoginScene:ctor()
    self:addChild(self:createLoginLayer())
end

function LoginScene:createLoginLayer()
    local layer = cc.Layer:create()

    -- background
    self:createBackground(layer)

    -- input editbox
    self:createInputEditBox(layer)

    -- login button
    self:createLoginButton(layer)

    -- password tip
    self:createTip(layer)

    -- other login
    self:createOtherLogin(layer)

    return layer
end

-- background
function LoginScene:createBackground(layer)
    local background = cc.Sprite:create("login/background.png")
    SizeUtils.resize(background)
    background:setPosition(display.cx,display.cy)
    layer:addChild(background)
end

-- account and password editbox
function LoginScene:createInputEditBox(layer)
    local placeHolderSize = 28
    local fontSetting = LabelUtils.createFontSetting(nil,26,display.COLOR_BLACK)

    -- account
    local edit,account = EditUtils.createEditBox("login/account.png","login/edit.png",Size.AutoSize(60),fontSetting)
    local accountPos = cc.p(display.cx,display.height - Size.AutoSize(180))
    account:setPosition(accountPos)
    account:setAnchorPoint(cc.p(0.5,1))
    account:setTag(TAG_ACCOUNT_SPRITE)
    edit:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    edit:setMaxLength(20)
    edit:setPlaceHolder("手机号码")
    edit:setPlaceholderFontSize(placeHolderSize)
    edit:setTag(TAG_ACCOUNT_TEXT)
    layer:addChild(account,1)

    -- password
    local edit,password = EditUtils.createEditBox("login/password.png","login/edit.png",Size.AutoSize(60),fontSetting)
    password:setPosition(PositionUtils.getRelativePosition(account,LEFT,BOTTOM,Size.AutoSize(0),Size.AutoSize(-10)))
    password:setAnchorPoint(cc.p(0,1))
    password:setTag(TAG_PASSWORD_SPRITE)
    edit:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    edit:setMaxLength(20)
    edit:setPlaceHolder("密码")
    edit:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    edit:setPlaceholderFontSize(placeHolderSize)
    edit:setTag(TAG_PASSWORD_TEXT)
    layer:addChild(password,1)
end

-- login button
function LoginScene:createLoginButton(layer)
    local function login(sender)
        local account = layer:getChildByTag(TAG_ACCOUNT_SPRITE):getChildByTag(TAG_ACCOUNT_TEXT):getText()
        local password = layer:getChildByTag(TAG_PASSWORD_SPRITE):getChildByTag(TAG_PASSWORD_TEXT):getText()
        print(account,password)
        local result = LoginEngine.Login(account,password)
        result = result or false
        if(result == true) then
            self:onLoginSuccess()
        else
            self:showMessageBox(1,"帐号或者密码错误，请重新登录！")
        end
    end

    local target = layer:getChildByTag(TAG_PASSWORD_SPRITE)
    local loginBtn = cc.Sprite:create("login/loginBtn.png")
    loginBtn:setPosition(PositionUtils.getRelativePosition(target,LEFT,BOTTOM,Size.AutoSize(0),Size.AutoSize(-10)))
    loginBtn:setAnchorPoint(cc.p(0,1))
    layer:addChild(loginBtn,1)
    loginBtn:setTag(TAG_LOGIN_BTN)
    ClickUtils.setOnClickListener(loginBtn,login, "login/loginBtn_pressed.png")
end

-- password tip
function LoginScene:createTip(layer)
    local function tip(sender)
        local tag = sender:getTag()
        if tag == TAG_REGISTER_TIP then
            local registerScene = RegisterScene.create(LOGIN_SCENE_TYPE.type_register)
            display.pushScene(registerScene)
        elseif tag == TAG_FORGET_PASSWORD_TIP then
            local findPasswordScene = RegisterScene.create(LOGIN_SCENE_TYPE.type_find_password)
            display.pushScene(findPasswordScene)
        end
    end

    -- register tip
    local target = layer:getChildByTag(TAG_LOGIN_BTN)
    local register = cc.Sprite:create("login/register.png")
    register:setPosition(PositionUtils.getRelativePosition(target,LEFT,BOTTOM,Size.AutoSize(0),Size.AutoSize(-15)))
    register:setAnchorPoint(cc.p(0,1))
    layer:addChild(register,1)
    register:setTag(TAG_REGISTER_TIP)
    ClickUtils.setOnClickListener(register,tip, "login/register_pressed.png")

    -- forget password tip
    local forget_password = cc.Sprite:create("login/forget_password.png")
    forget_password:setPosition(PositionUtils.getRelativePosition(target,RIGHT,BOTTOM,Size.AutoSize(0),Size.AutoSize(-15)))
    forget_password:setAnchorPoint(cc.p(1,1))
    layer:addChild(forget_password,1)
    forget_password:setTag(TAG_FORGET_PASSWORD_TIP)
    ClickUtils.setOnClickListener(forget_password,tip, "login/forget_password_pressed.png")
end

-- other login
function LoginScene:createOtherLogin(layer)
    local function otherLogin(sender)
        local tag = sender:getTag()
        if not tag then
            return
        end
        local way
        if tag == TAG_WECHAT_LOGIN then
            way = LOGIN_WAY.wechat
        elseif tag == TAG_QQ_LOGIN then
            way = LOGIN_WAY.qq
        elseif tag == TAG_WEIBO_LOGIN then
            way = LOGIN_WAY.weibo
        end
        local result = LoginEngine.LoginViaOther(way)
        result = result or false
        if(result == true) then
            self:onLoginSuccess()
        else
            self:showMessageBox(1,"登录失败")
        end
    end

    local tip_target = layer:getChildByTag(TAG_REGISTER_TIP)
    local btn_target = layer:getChildByTag(TAG_LOGIN_BTN)

    local other_login = cc.Sprite:create("login/other_login.png")
    local t = PositionUtils.getRelativePosition(tip_target,LEFT,BOTTOM,Size.AutoSize(0),Size.AutoSize(-20))
    other_login:setPosition(cc.p(display.cx,t.y))
    other_login:setAnchorPoint(cc.p(0.5,1))
    layer:addChild(other_login,1)

    local size_t = btn_target:getContentSize()
    local pos_t =  btn_target:convertToWorldSpace(cc.p(0,0))
    local pos_s = other_login:convertToWorldSpace(cc.p(0,0))

    local scale = 1
    -- wechat login
    local wechat = cc.Sprite:create("login/wechat.png")
    --scale = SizeUtils.getScale(wechat:getContentSize().width, Size.AutoSize(80))
    wechat:setPosition(cc.p(pos_t.x,pos_s.y + Size.AutoSize(-10)))
    wechat:setAnchorPoint(cc.p(0,1))
    wechat:setScale(scale)
    layer:addChild(wechat,1)
    wechat:setTag(TAG_WECHAT_LOGIN)
    ClickUtils.setOnClickListener(wechat,otherLogin, "login/wechat_pressed.png")

    -- qq login
    local qq = cc.Sprite:create("login/qq.png")
    qq:setPosition(cc.p(display.cx,pos_s.y + Size.AutoSize(-10)))
    qq:setAnchorPoint(cc.p(0.5,1))
    qq:setScale(scale)
    layer:addChild(qq,1)
    wechat:setTag(TAG_QQ_LOGIN)
    ClickUtils.setOnClickListener(qq,otherLogin, "login/qq_pressed.png")

    -- weibo login
    local weibo = cc.Sprite:create("login/weibo.png")
    weibo:setPosition(cc.p(pos_t.x + size_t.width,pos_s.y + Size.AutoSize(-10)))
    weibo:setAnchorPoint(cc.p(1,1))
    weibo:setScale(scale)
    layer:addChild(weibo,1)
    wechat:setTag(TAG_WEIBO_LOGIN)
    ClickUtils.setOnClickListener(weibo,otherLogin, "login/weibo_pressed.png")
end

function LoginScene:onLoginSuccess()
    self:jumpToSquare()
end

function LoginScene:jumpToSquare()
    local squareScene = SquareScene.create()
    display.pushScene(squareScene,"RANDOM")
end



return LoginScene

