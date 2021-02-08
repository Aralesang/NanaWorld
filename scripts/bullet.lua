local GameObject = require "scripts.game_object"
local Animation = require "plugins.animation"

---@class Bullet : GameObject
---@field animation Animation
local Bullet = {
    animation = nil,
    body = nil,
    shape = nil,
    fixture = nil,
}

function Bullet:new(image,x,y)
    ---@type Bullet
    local o = GameObject:new()
    setmetatable(o,{__index=self})
    o.animation = Animation:new(image,1,1,0)
    o.position.x = x
    o.position.y = y

    o.body = love.physics.newBody(worlds[0],x,y,"dynamic")
    o.shape =  love.physics.newCircleShape(10)
    o.fixture = love.physics.newFixture(o.body, o.shape, 1)
    o.fixture:setRestitution(0.9)
    return o
end

function Bullet:load()

end

function Bullet:update(dt)
    --local x,y = self:getPosition()
    self:setPosition(self.body:getX(),self.body:getY())
end

return Bullet