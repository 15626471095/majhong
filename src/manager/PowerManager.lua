--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/26
-- Time: 12:51
-- To change this template use File | Settings | File Templates.
--

local PowerManager = {}

PowerManager.sprites = {}

function PowerManager.init()
    display.loadSpriteFrames("state/power_state.plist","state/power_state.png")
end

function PowerManager.newSprite()
    local power = PowerManager.getPowerState()
    local sprite = display.newSprite(string.format("#power_%d.png",power))
    local len = #PowerManager.sprites
    PowerManager.sprites[len + 1] = sprite
    return sprite
end

function PowerManager.getPowerState()
    -- 1 ~ 10
    return 7
end

function PowerManager.updatePowerState()

end

PowerManager.init()

return PowerManager
