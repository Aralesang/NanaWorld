local GameObject = require "scripts.bases.game_object"
local Animation = require "scripts.components.animation"
local Colllision = require "scripts.components.collisionCircular"

---子弹
---@class Bullet : GameObject
---@field animation Animation
---@field speed number 子弹飞行速度
local Bullet = {
    animation = nil,
    speed = 5,
}

function Bullet:new(image,x,y)
    ---@type Bullet
    local o = GameObject:new()
    setmetatable(o,{__index=self})
    o.position.x = x
    o.position.y = y

    --附加动画组件
    ---@type Animation
    o.animation = o:addComponent(Animation)
    o.animation:init(image,1,1,0);

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
    self.position.x = self.position.x - self.speed
end

return Bullet