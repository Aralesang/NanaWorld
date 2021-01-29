---@class Animation
---@field public image table 用于创建动画的序列帧位图
---@field width number 单帧对象宽度
---@field height number 单帧对象高度
---@field quad table 视图窗口
---@field frameIndex number 当前动画帧下标
---@field frameTime number 当前动画帧所经过的时间
---@field frameCount number 帧总数量
---@field row number 当前所使用的动画行
---@field timeInterval number 动画播放时间间隔
---@field timeMultiply number 动画播放速度倍率
---@field xCount number x轴帧数量
---@field yCount number y轴帧数量
---@field status number 动画状态
local Animation = {
    image = nil, --用于创建动画的序列帧位图
    width = 0, --单帧对象宽度
    height = 0, --单帧对象高度
    quad = nil, --视图窗口
    frameIndex = 0, --当前动画帧下标
    frameTime = 0, --当前动画帧所经过的时间
    frameCount = 0, --帧数
    row = 0, --当前所使用的动画行
    timeInterval = 0, --动画播放时间间隔
    timeMultiply = 1, --动画播放速度倍率
    xCount = 0, --x轴帧数量
    yCount = 0, --y轴帧数量
    status = "playing", --动画状态
}

---创建一个新的动画对象
---@param image Image 用于创建动画的序列帧位图
---@param xCount number x轴帧数量
---@param yCount number y轴帧数量
---@param timeInterval number 动画播放时间间隔
---@param row number 当前所使用的动画行
---@return Animation
function Animation:new (image,xCount,yCount,timeInterval,row)
    ---@type Animation
    local o = {}
    setmetatable(o,{__index=self})

    o.image = image or {}
    o.xCount = xCount or 0
    o.yCount = yCount or 0
    o.width = o.image:getWidth() / o.xCount
    o.height = o.image:getHeight() / o.yCount
    o.row = row or 0
    o.timeInterval = timeInterval or 0
    o.frameCount = o.image:getWidth() / o.width
    o.quad = love.graphics.newQuad(0,o.row * o.height,o.width, o.height, o.image:getWidth(), o.image:getHeight())

    return o
end

---绘制动画图像
---@param x number 绘制对象的位置（x轴）
---@param y number 绘制对象的位置（y轴）
---@param r number 旋转弧度
---@param sx number 比例因子(x轴)
---@param sy number 比例因子(y轴)
---@param ox number 原点偏移（x轴）
---@param oy number 原点偏移（y轴）
function Animation:draw(x,y,r,sx,sy,ox,oy,kx,ky)
    local image = self.image
    local quad = self.quad
    love.graphics.draw(image,quad,x,y,r,sx,sy,ox,oy,kx,ky)
end

---动画帧刷新(按照顺序从左到右播放动画)
---@param dt number 所经过的时间间隔
function Animation:update(dt)
    if self.status ~= "playing" then
        return
    end
    self.frameTime = self.frameTime + dt
    if self.frameTime < self.timeInterval / self.timeMultiply then
        return
    end
    self.frameTime = 0
    --计算出帧所对应的坐标
    local index = self.frameIndex
    self:setFrameIndex(index)
    if index < self.frameCount - 1 then
        index = index + 1
    else
        index = 0
    end
    self.frameIndex = index
end

---设置动画行
---@param row number 目标动画行
---@param animIndex number 从第几帧开始播放
function Animation:setRow(row,animIndex)
    self.row = row
    self.frameIndex = animIndex or 0
    self.quad:setViewport(0, self.row * self.height, self.width, self.height, self.image:getWidth(), self.image:getHeight())
end

---设置动画帧
function Animation:setFrameIndex(frameIndex)
    self.frameIndex = frameIndex 
    self.quad:setViewport(self.frameIndex * self.width, self.row * self.height, self.width, self.height, self.image:getWidth(), self.image:getHeight())
end

---检查动画状态
---@param status string | "'playing'" | "'pause'"
function Animation:checkStatus(status)
    return self.status == status
end

---播放动画
---@param frameIndex number 指定开始播放的第一帧
function Animation:play(frameIndex)
    self.status = "playing"
    local frameIndex = frameIndex or 0
    self:setFrameIndex(frameIndex)
end
---停止动画
---@param animIndex number 指定停止后显示的动画帧
function Animation:stop(frameIndex)
    self.status = "stop"
    local frameIndex = frameIndex or self.frameIndex
    self:setFrameIndex(frameIndex)
end

---暂停动画
function Animation:pause()
    self.status = "pause"
end

---继续上一次暂定的帧和时间继续播放
function Animation:continue()
    self.status = "playing"
end

return Animation