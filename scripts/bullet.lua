local GameObject = require "scripts.game_object"
local Animation = require "plugins.animation"

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

    return o
end

function Bullet:load()

end

function Bullet:update(dt)
    local x,y = self:getPosition()
    self:setPosition(x - 1,y)
end

return Bullet