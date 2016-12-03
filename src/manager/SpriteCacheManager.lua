--
-- Created by IntelliJ IDEA.
-- User: Nol
-- Date: 2016/11/26
-- Time: 11:47
-- To change this template use File | Settings | File Templates.
--

local SpriteCacheManager = {}

function SpriteCacheManager.loadSprite()

end

function SpriteCacheManager.addSpriteFrame(filename)
    local frame = cc.Sprite:create(filename):getSpriteFrame()
    local cache = cc.SpriteFrameCache:getInstance()
    cache:addSpriteFrame(frame,filename)
end

function SpriteCacheManager.getSpriteFrame(frameName)
    local cache = cc.SpriteFrameCache:getInstance()
    return cache:getSpriteFrame(frameName)
end

return SpriteCacheManager