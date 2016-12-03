--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/26
-- Time: 17:08
-- To change this template use File | Settings | File Templates.
--

local UserSettingManager = {}

UserSettingManager.Setting = {
    effect = true,
    music = true,
    varbate = true
}

function UserSettingManager.getUserSetting()
    UserSettingManager.LoadUserSetting()
    return UserSettingManager.Setting
end

function UserSettingManager.LoadUserSetting()
    UserSettingManager.Setting.music = false
end

function UserSettingManager.set(type,state)
    if(type == SettingItem.TYPE_EFFECT) then
        UserSettingManager.Setting.effect = state
    elseif type == SettingItem.TYPE_MUSIC then
        UserSettingManager.Setting.music = state
    elseif type ==SettingItem.TYPE_VARBATE then
        UserSettingManager.Setting.varbate = state
    end
    UserSettingManager.save()
end

function UserSettingManager.save()

end

return UserSettingManager

