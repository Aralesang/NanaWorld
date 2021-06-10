local Bullet = require "scripts.game.Bullet"
local Animation = require "scripts.components.Animation"

--子弹图片
local bulletImage

---@class PlayerController 玩家控制器
---@field player Role 所控制目标玩家对象
local PlayerController = {
    player = {}
}

---@return PlayerController
---@param player Role 要控制的目标玩家
function PlayerController:new(player)
    ---@type PlayerController
    local o = {}
    setmetatable(o,{__index = self})

    o.player = player

    return o
end

function PlayerController:update(dt)
    local player = self.player
    local key
    if love.keyboard.isDown("left") then
        key = "left"
    elseif love.keyboard.isDown("right") then
        key = "right"
    elseif love.keyboard.isDown("up") then
        key = "up"
    elseif love.keyboard.isDown("down") then
        key = "down"
    end
    
    local animation = player:getComponent(Animation)

    if key ~= nil then
        if player.orientation ~= key then
            player:setDir(key) --设置角色面向
        end
        if animation.status ~= "playing" then
            animation:play(1)
        end
        self:move(dt,key) --移动
        key = nil
    else
        if animation.status == "playing" then
            animation:stop(0)
        end
    end

end

---按键检测
function PlayerController:keypressed(key)
    if key == "space" then
        if bulletImage == nil then
            bulletImage = love.graphics.newImage("image/bullet.png")
        end
       
        local x,y = self.player:getPosition()
        y = y + 30
        local bullet = Bullet:new(bulletImage,x,y)
        bullet:setScale(0.2,0.2)
    end
end

function PlayerController:keyreleased(key)

end

function PlayerController:move(dt,dir)
    local player = self.player

    local x,y = player:getPosition()
    local distance = math.modf(dt * player.speed)

    local speed = self.player.speed
    if dir == "left" then
        x = x - distance
    elseif dir == "right" then
        x = x + distance
    elseif dir == "up" then
        y = y - distance
    elseif dir == "down" then
        y = y + distance
    end
    player:setPosition(x,y)
end

return PlayerController