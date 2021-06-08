local GameObject = require "scripts.game_object"
local Animation = require "plugins.animation"
local Colllision = require "scripts.collisionCircular"

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

    --为子弹附加碰撞组件
    local collision = o:addComponent(Colllision)
    collision:setScale(10)
    return o
end

function Bullet:load()

end

function Bullet:update(dt)
    --子弹将会自动前进
end

return Bullet