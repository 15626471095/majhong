--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/26
-- Time: 12:46
-- To change this template use File | Settings | File Templates.
--

local WifiManager = {}

function WifiManager.init()
    display.loadSpriteFrames("state/wifi_state.plist","state/wifi_state.png")
end

function WifiManager.newSprite()
    local wifiState = WifiManager.getWifiState()
    local sprite = display.newSprite(string.format("#wifi_%d.png",wifiState))
    return sprite
end

function WifiManager.getWifiState()
    return 5
end

WifiManager.init()

return WifiManager

