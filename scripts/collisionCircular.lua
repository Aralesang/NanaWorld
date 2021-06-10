---@type Game
local Game = require "scripts.game"
---@type Component
local Component = require "scripts.component"
---@type Debug
local Debug = require "scripts.debug"
---@type Collision
local Collision = require "scripts.collision"
---碰撞器_圆形
---@class CollisionCircular : Collision
---@field debug boolean 绘制形状
---@field radius number 半径
local CollisionCircular = {
    radius = 0,
    componentName = "CollisionCircular"
}

---创建一个新碰撞器
function CollisionCircular:new()
    ---@type CollisionCircular
    local o = Collision:new()
    o.debug = true
    setmetatable(o, {__index = self})
    Game.controllers[tostring(o)] = o
    self.radius = 0
    return o
end

function CollisionCircular:load()
end

function CollisionCircular:update(dt)
    self:setPosistion(self.gameObject.position.x,self.gameObject.position.y)
    local collision = self
    ---@param otherCollision CollisionCircular
    for objName, otherCollision in pairs(Game.controllers) do
        --对圆形的碰撞
        if otherCollision.componentName == "CollisionCircular" and tostring(collision) ~= tostring(otherCollision) then
            if
                math.abs(otherCollision.x - collision.x) <= otherCollision.radius + collision.radius and
                    math.abs(otherCollision.y - collision.y) <= otherCollision.radius + collision.radius
             then
                if self:checkCollision(otherCollision) == false then
                    collision:onBeginCollison(collision, otherCollision)
                end
            else
                if self:checkCollision(otherCollision) == true then
                    collision:onEndCollison(collision, otherCollision)
                end
            end
        end
        
        --TODO:对四边形的碰撞

    end
end

function CollisionCircular:draw()
    if self.debug then
        if self.isCollision then
            love.graphics.setColor(0.76, 0.18, 0.05)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.ellipse("line", self.x + self.radius, self.y + self.radius, self.radius, self.radius)
    end
end

---设置碰撞器体积
function CollisionCircular:setScale(radius)
    self.radius = radius
end

return CollisionCircular
