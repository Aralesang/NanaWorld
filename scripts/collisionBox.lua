---@type Game
local Game = require "scripts.game"
---@type Component
local Component = require "scripts.component"
---@type Debug
local Debug = require "scripts.debug"

---碰撞器_盒状
---@class CollisionBox : Component
---@field debug boolean 绘制形状
---@field width number 碰撞器的宽度
---@field height number 碰撞器的高度
---@field x number 碰撞器中心点位置x
---@field y number 碰撞器中心点位置y
---@field debug boolean 是否启用debug模式，启用后将在游戏中绘制出碰撞器的轮廓
---@field isCollision boolean 如果当前碰撞器处于碰撞中，则为true
local CollisionBox = {
    width = 0,
    height = 0,
    x = 0,
    y = 0,
    debug = true,
    isCollision = false,
    componentName = "CollisionBox"
}

---创建一个新π碰撞器
---@param w number 碰撞器的宽度
---@param h number 碰撞器的高度
function CollisionBox:new(target,w, h)
    ---@type Collision
    local o = Component:new()
    setmetatable(o, {__index = self})
    Game.controllers[tostring(o)] = o
    self.width = w or 0
    self.height = h or 0
    self.target = target
    return o
end

function CollisionBox:load()

end

function CollisionBox:update(dt)
    self.x = self.gameObject.position.x
    self.y = self.gameObject.position.y
    local collision = self
     ---@param otherCollision CollisionBox
     for objName, otherCollision in pairs(Game.controllers) do
        if tostring(collision) ~= tostring(otherCollision) then
            if
                collision.x + collision.width >= otherCollision.x and
                    collision.x - otherCollision.x <= collision.width and
                    collision.y + collision.height >= otherCollision.y and
                    collision.y - otherCollision.y <= collision.height
             then
                collision:onBeginCollison(collision, otherCollision)
            else
                collision:onEndCollison(collision, otherCollision)
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

---获取碰撞器所在位置
---@return x 碰撞器所在x坐标
---@return y 碰撞器所在y坐标
function CollisionBox:getPosistion()
    return self.x, self.y
end

---设置碰撞器位置
function CollisionBox:setPosistion(x, y)
    self.x = x
    self.y = y
end

---设置碰撞器体积
function CollisionBox:setScale(w, h)
    self.width = w
    self.height = h
end

---碰撞开始
function CollisionBox:onBeginCollison(coll, ohterColl)
    self.isCollision = true
end

---碰撞结束
function CollisionBox:onEndCollison(coll, otherColl)
    self.isCollision = false
end

return CollisionBox
