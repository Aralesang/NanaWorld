local GameObject = require "scripts.bases.game_object"
local Animation = require "scripts.components.animation"
local Colllision = require "scripts.components.collisionCircular"
local Debug = require "scripts.utils.debug"

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
    Debug.log("子弹加载")
end

function Bullet:update(dt)
    --子弹将会自动前进
    self.position.x = self.position.x - 1
end

return Bullet