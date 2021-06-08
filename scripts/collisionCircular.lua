---@type Game
local Game = require "scripts.game"
---@type Component
local Component = require "scripts.component"
---@type Debug
local Debug = require "scripts.debug"

---碰撞器_圆形
---@class CollisionCircular : Component
---@field debug boolean 绘制形状
---@field radius number 半径
---@field x number 碰撞器中心点位置x
---@field y number 碰撞器中心点位置y
---@field debug boolean 是否启用debug模式，启用后将在游戏中绘制出碰撞器的轮廓
---@field isCollision boolean 如果当前碰撞器处于碰撞中，则为true
local CollisionCircular = {
    radius = 0,
    x = 0,
    y = 0,
    debug = true,
    isCollision = false,
    componentName = "CollisionCircular"
}

---创建一个新π碰撞器
---@param target GameObject 要附加的目标
---@param w number 碰撞器的宽度
function CollisionCircular:new(target, radius)
    ---@type Collision
    local o = Component:new()
    setmetatable(o, {__index = self})
    Game.controllers[tostring(o)] = o
    self.radius = radius or 0
    self.target = target
    return o
end

function CollisionCircular:load()
end

function CollisionCircular:update(dt)
    self:setPosistion(self.gameObject.position.x,self.gameObject.position.y)
    local collision = self
    ---@param otherCollision CollisionCircular
    for objName, otherCollision in pairs(Game.controllers) do
        if otherCollision.componentName == self.componentName and tostring(collision) ~= tostring(otherCollision) then
            if
                math.abs(otherCollision.x - collision.x) < otherCollision.radius + collision.radius and
                    math.abs(otherCollision.y - collision.y) < otherCollision.radius + collision.radius
             then
                collision:onBeginCollison(collision, otherCollision)
            else
                collision:onEndCollison(collision, otherCollision)
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

---获取碰撞器所在位置
---@return x 碰撞器所在x坐标
---@return y 碰撞器所在y坐标
function CollisionCircular:getPosistion()
    return self.x, self.y
end

---设置碰撞器位置
function CollisionCircular:setPosistion(x, y)
    self.x = x
    self.y = y
end

---设置碰撞器体积
function CollisionCircular:setScale(radius)
    self.radius = radius
end

---碰撞开始
function CollisionCircular:onBeginCollison(coll, ohterColl)
    self.isCollision = true
end

---碰撞结束
function CollisionCircular:onEndCollison(coll, otherColl)
    self.isCollision = false
end

return CollisionCircular
