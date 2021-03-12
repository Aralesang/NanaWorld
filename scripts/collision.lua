---碰撞器
---@class Collision
---@field body table 主体
---@field shape table 形状
---@field fixture table 固定装置
---@field draw boolean 绘制形状
local Collision = {
    body = nil,
    shape = nil,
    fixture = nil,
    draw = true,
    mode = nil
}

---创建一个新碰撞器
---@param x number 创建的坐标x
---@param y number 创建的坐标y
---@param worldName string|number 所适用的世界
---@param mode string 模式 dynamic | static
function Collision:new(x,y,worldName,mode)
    ---@type Collision
    local o = {}
    setmetatable(o,{__index=self})

    mode = mode or "dynamic"
    
    o.body = love.physics.newBody(worlds[worldName],x,y,mode)
    
    o.setPosistion = Collision.setPosistion
    return o
end

function Collision:update(dt)
    
end

function Collision:draw()
    if self.draw then
        if self.mode == "circle" then
            love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
        end
        if self.mode == "rectangle" then
            love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
        end
    end
end

---获取碰撞器所在位置
function Collision:getPosistion()
    if self.body == nil then
        return 0,0
    end
    return self.body:getX(),self.body:getY()
end

---设置碰撞器位置
function Collision:setPosistion(x,y)
    self.body:setPosition(x,y)
end

---设置为圆
---@field radius number 半径
function Collision:setCircle(radius)
    self.shape = love.physics.newCircleShape(radius)
    self.mode = "circle"
end


---设置为矩形
---@field radius number 半径
function Collision:setRectangle(width,height)
    self.shape = love.physics.newRectangleShape(width,height)
    self.mode = "rectangle"
end

---结构连接
---@param density table 密度
---@param restitution table 弹性
function Collision:setFixture(density,restitution)
    self.fixture = love.physics.newFixture(self.body, self.shape, density)
    self.fixture:setRestitution(restitution)
end

return Collision