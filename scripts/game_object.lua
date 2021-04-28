local Game = require "scripts.game"
local Collision = require "scripts.collision"
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
    scale = {w = 1,h = 1},
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
    o.getPosition = GameObject.getPosition

    o.collision = Collision:new(self.position.x,self.position.y,self.scale.w,self.scale.h);

    Game.gameObjects[o.gameObjectName] = o
    return o
end

---对象加载
function GameObject:load()

end

---对象帧更新
function GameObject:update(dt)
    self.collision:setPosistion(self.position.x,self.position.y);
    self.collision:setScale(self.scale.w,self.scale.h)
end

---对象图像绘制
---@see CollisionBox #draw
function GameObject:draw()
    print("position",self.position.x,self.position.y)
    print("wh:",self.scale.w,self.scale.h)
    self.animation:draw(self.position.x,self.position.y,self.rotate,self.scale.w,self.scale.h)
    self.collision:draw();
end

---对象动画更新
function GameObject:animUpdate(dt)
    self.animation:update(dt)
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
    self.scale.w = x
    self.scale.h = y
end

return GameObject