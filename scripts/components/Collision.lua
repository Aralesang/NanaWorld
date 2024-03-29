local Component = require "scripts.components.Component"

---@class Collision : Component 碰撞器基类
---@field x number 碰撞器中心点位置x
---@field y number 碰撞器中心点位置y
---@field debug boolean 是否启用debug模式，启用后将在游戏中绘制出碰撞器的轮廓
---@field collisions Collision[] 当前正在碰撞的对象列表
---@field isCollision boolean 当前碰撞器是否处于碰撞中
local Collision = {
    x = 0,
    y = 0,
    debug = false,
    collisions = nil,
    isCollision = false
}

function Collision:new()
    ---@type Collision
    local o = Component:new()
    setmetatable(o,{__index = self})
    o.x = 0
    o.y = 0
    o.debug = false
    o.collisions = {}
    o.setPosistion = self.setPosistion
    o.getPosistion = self.getPosistion
    o.onBeginCollison = self.onBeginCollison
    o.onEndCollison = self.onEndCollison
    o.checkCollision = self.checkCollision
    return o
end

---获取碰撞器所在位置
---@return x 碰撞器所在x坐标
---@return y 碰撞器所在y坐标
function Collision:getPosistion()
    return self.x, self.y
end

---设置碰撞器位置
function Collision:setPosistion(x, y)
    self.x = x
    self.y = y
end

---碰撞开始
function Collision:onBeginCollison(otherColl)
    table.insert(self.collisions,otherColl)
    self.isCollision = true
    if self.gameObject.onBeginCollison then
        self.gameObject:onBeginCollison(otherColl)
    end
end

---碰撞结束
---@param otherColl Collision
function Collision:onEndCollison(otherColl)
    local count = 0
    for k,v in pairs(self.collisions) do
        if v ~= nil then
            count = count + 1
            if v == otherColl then
                table.remove(self.collisions,k)
                count = count - 1
            end
        end
    end
    
    if count == 0 then
        self.isCollision = false
    end
    if self.gameObject.onEndCollison then
        self.gameObject:onEndCollison(otherColl)
    end
end

---检查目标碰撞器是否与该碰撞器碰撞
function Collision:checkCollision(otherColl)
    for k,v in pairs(self.collisions) do
        if v == otherColl then
            return true
        end
    end
    return false
end

return Collision