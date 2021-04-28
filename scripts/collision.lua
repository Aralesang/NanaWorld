---碰撞器_盒状
---@class CollisionBox
---@field debug boolean 绘制形状
local CollisionBox = {
    width = 0,
    height = 0,
    x = 0,
    y = 0,
    debug = true,
    mode = nil
}

---创建一个新碰撞器
---@param x number 创建的坐标x
---@param y number 创建的坐标y
---@param w number 碰撞器的宽度
---@param h number 碰撞器的高度
function CollisionBox:new(x,y,w,h)
    ---@type Collision
    local o = {}
    setmetatable(o,{__index=self})
    self.x = x
    self.y = y
    self.width = w
    self.height = h
    print("position",self.x,self.y)
    print("wh:",self.width,self.height)
    return o
end

function CollisionBox:update(dt)

end

function CollisionBox:draw()
    if self.draw then
        love.graphics.rectangle("line",self.x,self.y,self.width,self.height);
    end
end

---获取碰撞器所在位置
function CollisionBox:getPosistion()

end

---设置碰撞器位置
function CollisionBox:setPosistion(x,y)
    self.x = x
    self.y = y
end

---设置碰撞器体积
function CollisionBox:setScale(w,h)
    self.w = w
    self.w = h
end

return CollisionBox