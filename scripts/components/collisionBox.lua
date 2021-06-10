---@type Game
local Game = require "scripts.game.game"
---@type Component
local Component = require "scripts.components.component"
---@type Debug
local Debug = require "scripts.utils.debug"
---@type Collision
local Collision = require "scripts.components.collision"

---碰撞器_盒状
---@class CollisionBox : Collision
---@field width number 碰撞器的宽度
---@field height number 碰撞器的高度
---@field isCollision boolean 如果当前碰撞器处于碰撞中，则为true
local CollisionBox = {
    width = 0,
    height = 0,
    isCollision = false,
    componentName = "CollisionBox"
}

---创建一个新碰撞器
function CollisionBox:new()
    ---@type CollisionBox
    local o = Collision:new()
    o.debug = true
    setmetatable(o, {__index = self})
    Game.controllers[tostring(o)] = o
    self.width = 0
    self.height = 0
    
    return o
end

function CollisionBox:load()

end

function CollisionBox:update(dt)
    self.x = self.gameObject.position.x
    self.y = self.gameObject.position.y
    local collision = self
     ---@param otherCollision CollisionBox
     for index, otherCollision in pairs(Game.controllers) do
        if otherCollision.componentName == "CollisionBox" and tostring(collision) ~= tostring(otherCollision) then
            if
                collision.x + collision.width >= otherCollision.x and
                    collision.x - otherCollision.x <= collision.width and
                    collision.y + collision.height >= otherCollision.y and
                    collision.y - otherCollision.y <= collision.height
             then
                if self:checkCollision(otherCollision) == false then
                    collision:onBeginCollison(otherCollision)
                end
            else
                if self:checkCollision(otherCollision) == true then
                    collision:onEndCollison(otherCollision)
                end
            end
        end
    end
end

function CollisionBox:draw()
    if self.debug then
        if self.isCollision then
            love.graphics.setColor(0.76, 0.18, 0.05)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    end
end

---设置碰撞器体积
function CollisionBox:setScale(w, h)
    self.width = w
    self.height = h
end

return CollisionBox
