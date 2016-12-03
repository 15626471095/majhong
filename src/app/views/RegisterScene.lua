--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/22
-- Time: 15:36
-- To change this template use File | Settings | File Templates.
--

cc.exports.LOGIN_SCENE_TYPE = {
    type_register = 1,
    type_find_password = 2
}

local RegisterScene = class("RegisterScene",BaseScene.create)

function RegisterScene.create(type)
    if type then
        return RegisterScene.new(type)
    end
    return RegisterScene.new(LOGIN_SCENE_TYPE.type_register)
end

function RegisterScene:ctor(type)
    self.type = type
    self:addChild(self:createRegisterLayer())
end

function RegisterScene:createRegisterLayer()
    local layer = cc.Layer:create()

    -- background
    self:createBackground(layer)

    -- input editbox
    self:createInputEditBox(layer)

    -- register button
    self:createRegisterButton(layer)

    -- back
    self:createBack(layer)

    return layer
end

-- background
function RegisterScene:createBackground(layer)
    local background = cc.Sprite:create("login/background.png")
    SizeUtils.resize(background)
    background:setPosition(display.cx,display.cy)
    layer:addChild(background)
end

-- back
function RegisterScene:createBack(layer)
    local back = cc.Sprite:create("widget/back.png")
    back:setPosition(cc.p(display.width - Size.AutoSize(40),display.height - Size.AutoSize(20)))
    back:setAnchorPoint(cc.p(1,1))
    layer:addChild(back,1)

    local function goBack(sender)
        display.popScene()
    end

    ClickUtils.setOnClickListener(back, goBack, "widget/back_pressed.png")
end

-- account and password editbox
function RegisterScene:createInputEditBox(layer)
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
    if self.type and self.type == LOGIN_SCENE_TYPE.type_find_password then
        edit:setPlaceHolder("新密码")
    else
        edit:setPlaceHolder("密码")
    end
    edit:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    edit:setPlaceholderFontSize(placeHolderSize)
    edit:setTag(TAG_PASSWORD_TEXT)
    layer:addChild(password,1)

    -- confirm password
    local edit,password1 = EditUtils.createEditBox("login/password.png","login/edit.png",Size.AutoSize(60),fontSetting)
    password1:setPosition(PositionUtils.getRelativePosition(password,LEFT,BOTTOM,Size.AutoSize(0),Size.AutoSize(-10)))
    password1:setAnchorPoint(cc.p(0,1))
    password1:setTag(TAG_PASSWORD_CONFIRM_SPRITE)
    edit:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    edit:setMaxLength(20)
    edit:setPlaceHolder("确认密码")
    edit:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    edit:setPlaceholderFontSize(placeHolderSize)
    edit:setTag(TAG_PASSWORD_CONFIRM_TEXT)
    layer:addChild(password1,1)

    -- dynamic code
    local edit,code = EditUtils.createEditBox("login/password.png","login/edit.png",Size.AutoSize(60),fontSetting)
    code:setScale(0.4,1)
    code:setPosition(PositionUtils.getRelativePosition(password1,LEFT,BOTTOM,Size.AutoSize(0),Size.AutoSize(-10)))
    code:setAnchorPoint(cc.p(0,1))
    code:setTag(TAG_DYNAMIC_CODE_SPRITE)
    edit:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    edit:setMaxLength(20)
    edit:setPlaceHolder("验证密码")
    edit:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    edit:setPlaceholderFontSize(placeHolderSize)
    edit:setTag(TAG_DYNAMIC_CODE_TEXT)
    layer:addChild(code,1)

    -- get dynamic code button
    local function getCode(sender)
        local phone = layer:getChildByTag(TAG_ACCOUNT_SPRITE):getChildByTag(TAG_ACCOUNT_TEXT):getText()
        local result = LoginEngine.getDynamicCode(phone)
        result = result or false
        if(result == true) then
            print("send success")
        else
            self:showMessageBox(1,"网络异常，稍后再试!")
        end
    end

    local getDynamicCodeBtn = cc.Sprite:create("login/loginBtn.png")
    getDynamicCodeBtn:setPosition(PositionUtils.getRelativePosition(password1,RIGHT,BOTTOM,Size.AutoSize(0),Size.AutoSize(-10)))
    getDynamicCodeBtn:setAnchorPoint(cc.p(1,1))
    getDynamicCodeBtn:setScale(0.4,0.8)
    layer:addChild(getDynamicCodeBtn,1)
    getDynamicCodeBtn:setTag(TAG_DYNAMIC_CODE_BTN)
    ClickUtils.setOnClickListener(getDynamicCodeBtn,getCode, "login/loginBtn_pressed.png")
end

-- register button
function RegisterScene:createRegisterButton(layer)
    local function register(sender)
        local account = layer:getChildByTag(TAG_ACCOUNT_SPRITE):getChildByTag(TAG_ACCOUNT_TEXT):getText()
        local password = layer:getChildByTag(TAG_PASSWORD_SPRITE):getChildByTag(TAG_PASSWORD_TEXT):getText()
        local password_confirm = layer:getChildByTag(TAG_PASSWORD_CONFIRM_SPRITE):getChildByTag(TAG_PASSWORD_CONFIRM_TEXT):getText()
        print(account,password,password_confirm)
        if(password ~= password_confirm) then
            self:showMessageBox(1,"两次输入的密码不一致，请重新输入！")
        else
            local result = LoginEngine.Register(account,password)
            result = result or false
            if(result == true) then
                display.popScene()
            else
                self:showMessageBox(1,"注册失败，用户名已存在")
            end
        end
    end

    local target = layer:getChildByTag(TAG_DYNAMIC_CODE_SPRITE)
    local loginBtn = cc.Sprite:create("login/loginBtn.png")
    loginBtn:setPosition(PositionUtils.getRelativePosition(target,LEFT,BOTTOM,Size.AutoSize(0),Size.AutoSize(-10)))
    loginBtn:setAnchorPoint(cc.p(0,1))
    layer:addChild(loginBtn,1)
    loginBtn:setTag(TAG_LOGIN_BTN)
    ClickUtils.setOnClickListener(loginBtn,register, "login/loginBtn_pressed.png")
end

return RegisterScene