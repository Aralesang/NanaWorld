local GameObject = require "scripts.game_object"
local Animation = require "plugins.animation"

---子弹
---@class Bullet : GameObject
---@field animation Animation
local Bullet = {
    animation = nil
}

function Bullet:new(image,x,y)
    ---@type Bullet
    local o = GameObject:new()
    setmetatable(o,{__index=self})
    o.animation = Animation:new(image,1,1,0)
    o.position.x = x
    o.position.y = y

    --球形体
    o:setCollisionCircle(7,0,1,1)
    return o
end

function Bullet:load()

end

function Bullet:update(dt)
end

return Bullet