---@type Game
local Game = require "scripts.game.Game"
---@type Component
local Component = require "scripts.components.Component"
---@type Collision
local Collision = require "scripts.components.Collision"
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
    self:setPosistion(self.gameObject.position.x, self.gameObject.position.y)
    local collision = self
    ---@type CollisionCircular
    ---@param otherCollision Collision
    for index, otherCollision in pairs(Game.controllers) do
        --对圆形的碰撞
        ---@type CollisionCircular
        local otherCollisionCircular = otherCollision
        if
            otherCollision.componentName == "CollisionCircular" and
                tostring(collision) ~= tostring(otherCollisionCircular)
         then
            if
                math.abs(otherCollisionCircular.x - collision.x) <= otherCollisionCircular.radius + collision.radius and
                    math.abs(otherCollisionCircular.y - collision.y) <= otherCollisionCircular.radius + collision.radius
             then
                if self:checkCollision(otherCollisionCircular) == false then
                    collision:onBeginCollison(otherCollisionCircular)
                end
            else
                if self:checkCollision(otherCollisionCircular) == true then
                    collision:onEndCollison(otherCollisionCircular)
                end
            end
        end

        --对四边形的碰撞
        ---@type CollisionBox
        local otherCollisionBox = otherCollision
        if otherCollision.componentName == "CollisionBox" and tostring(collision) ~= tostring(otherCollisionBox) then
            if
                math.abs(collision.x - otherCollisionBox.x) <= otherCollisionBox.width / 2 + collision.radius and
                    math.abs(collision.y - otherCollisionBox.y) <= otherCollisionBox.height / 2 + collision.radius
             then
                if self:checkCollision(otherCollisionBox) == false then
                    collision:onBeginCollison(otherCollisionBox)
                    otherCollisionBox:onBeginCollison(collision) --触发四边形的碰撞回调
                end
            else
                if self:checkCollision(otherCollisionBox) == true then
                    collision:onEndCollison(otherCollisionBox)
                    otherCollisionBox:onEndCollison(collision) --触发四边形的碰撞回调
                end
            end
        end
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
