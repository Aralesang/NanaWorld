local Animation = require "plugins.animation"
---@type GameObject
local GameObject = require "scripts.game_object"
local Game = require "scripts.game"
local CollisionBox = require "scripts.collisionBox"
---@class Role : GameObject
---@field name string 角色名称
---@field speed number 角色速度
---@field moveDir string 角色移动方向
---@field orientation string 角色朝向
local Role = {
    name = nil,
    speed = 100,
    moveDir = "down", --移动方向
    orientation = "down" --角色朝向
}

---@param imagePath table 角色图像地址
---@param name table 角色名称
---@param x table 创建于坐标x
---@param y table 创建于坐标y
---@return Role
function Role:new(imagePath, name, x, y)
    if (x == nil or y == nil) then
        print("警告:参数x或参数y未设置，这可能会导致某些问题")
    end

    x = x or 0
    y = y or 0

    ---@type Role
    local o = GameObject:new()
    setmetatable(o, {__index = self})
    local image = love.graphics.newImage(imagePath)
    o.animation = Animation:new(image, 4, 4, 0.3)
    o.name = name
    o.position.x = x
    o.position.y = y

    --创建碰撞器
    local collision = o:addComponent(CollisionBox)
    collision:setScale(32,48)

    return o
end

function Role:load()
    
end

function Role:update(dt)
    
end

---设置角色方向
function Role:setDir(dir)
    if dir == "left" then
        self.orientation = "left"
        self.animation:setRow(1, 1)
    elseif dir == "right" then
        self.orientation = "right"
        self.animation:setRow(2, 1)
    elseif dir == "up" then
        self.orientation = "up"
        self.animation:setRow(3, 1)
    elseif dir == "down" then
        self.orientation = "down"
        self.animation:setRow(0, 1)
    end
end

return Role
