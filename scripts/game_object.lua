local Game = require "scripts.game"
local collision = require "scripts.collision"
---游戏对象基本类
---@class GameObject
---@field gameObjectName string 对象名称
---@field animation Animation 对象动画组件
---@field position table 对象所在空间坐标{x,y}
---@field scale table 对象缩放比例因子{x,y}
---@field rotate number 对象旋转弧度
---@field collision Collision 碰撞器
local GameObject = {
    gameObjectName = nil,
    animation = nil,
    position = {x = 0,y = 0},
    scale = {x = 1,y = 1},
    rotate = 0,
    collision = nil
}

function GameObject:new()
    ---@type GameObject
    local o = {}
    setmetatable(o,{__index=self})
    o.draw = GameObject.draw
    o.animUpdate = GameObject.animUpdate
    o.setScale = GameObject.setScale
    o.setPosition = GameObject.setPosition
    o.getPosition = GameObject.getPosition
    o.position = {x = 0,y = 0}
    o.scale = {x = 1,y = 1}
    o.rotate = 0
    o.gameObjectName = tostring(o)
    o.setCollision = GameObject.setCollision
    o.getPosition = GameObject.getPosition
    o.collisionUpdate = GameObject.collisionUpdate
    o.setCollisionCircle = GameObject.setCollisionCircle
    o.setCollisionRectangle = GameObject.setCollisionRectangle

    Game.gameObjects[o.gameObjectName] = o
    return o
end

---对象加载
function GameObject:load()

end

---对象帧更新
function GameObject:update()

end

---对象图像绘制
function GameObject:draw()
    self.animation:draw(self.position.x,self.position.y,self.rotate,self.scale.x,self.scale.y)
end

---对象动画更新
function GameObject:animUpdate(dt)
    self.animation:update(dt)
end

---对象物理更新
function GameObject:collisionUpdate(dt)
    if self.collision ~= nil then
        --self.collision:update(dt)
        local x,y = self.collision:getPosistion()
        self:setPosition(x,y)
        self.collision:update(dt)
    end
end

---设置对象坐标
---@param x number 世界坐标x
---@param y number 世界坐标y
function GameObject:setPosition(x,y)
    self.position.x = x
    self.position.y = y
end

---获取对象坐标
---@return number x,对象的x坐标
---@return number y,对象的y坐标
function GameObject:getPosition()
    return self.position.x,self.position.y
end

---设置对象比例因子
---@param x number x轴比例因子
---@param y number y轴比例因子
function GameObject:setScale(x,y)
    self.scale.x = x
    self.scale.y = y
end

---为物体设置碰撞(圆形)
---@param radius number 半径
---@param worldName string|number 所适用的世界规则
---@param density number 密度
---@param restitution number 弹性
---@param mode string 模式 dynamic | static
function GameObject:setCollisionCircle(radius,worldName,density,restitution,mode)
    self.collision = collision:new(self.position.x,self.position.y,worldName,mode)
    self.collision:setCircle(radius)
    self.collision:setFixture(density,restitution)
    local x,y = self.collision:getPosistion()
    self:setPosition(x,y)
end


---为物体设置碰撞(矩形)
---@param width number 宽度
---@param height number 高度
---@param worldName string|number 所适用的世界规则
---@param density number 密度
---@param restitution number 弹性
---@param mode string 模式 dynamic | static
function GameObject:setCollisionRectangle(width,height,worldName,density,restitution,mode)
    self.collision = collision:new(self.position.x,self.position.y,worldName,mode)
    self.collision:setRectangle(width,height)
    self.collision:setFixture(density,restitution)
    local x,y = self.collision:getPosistion()
    self:setPosition(x,y)
end

return GameObject