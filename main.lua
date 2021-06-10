require "scripts.plugins.camera"
local GameObject = require "scripts.bases.game_object"
local Game = require "scripts.game.game"
local Animation = require "scripts.components.animation"
local Role = require "scripts.game.role"
local PlayerController = require "scripts.game.player_controller"

---@type Role[]
local roleArr = {}
---@type PlayerController 玩家控制器
local playerController
--背景图片
local backgroundImage

function love.load()
    print("game starting...")
    --加载中文字体(启动会很缓慢)
    local myFont = love.graphics.newFont("fonts/SourceHanSansCN-Bold.otf", 16)
    love.graphics.setFont(myFont)
    --更改图像过滤方式，以显示高清马赛克
    love.graphics.setDefaultFilter("nearest", "nearest")
    --加载背景图片
    backgroundImage = love.graphics.newImage("image/background.jpg")
    --创建npc
    local npc = Role:new("image/npc.png", "npc", 0, 0)
    --npc:setScale(2,2)
    roleArr["npc"] = npc

    --创建角色
    local player = Role:new("image/player.png", "player", 200, 0)
    --player:setScale(2,2)
    roleArr["player"] = player

    --初始化角色控制器
    playerController = PlayerController:new(player)

    for key, value in pairs(Game.gameObjects) do
        --对象加载
        value:load()
        ---触发组件加载
        for componentName,component in pairs(value.components) do
            component:load()
        end

    end
end

function love.draw()
    Camera:set()
    --love.graphics.push()
    local player = playerController.player
    ---绘制背景
    --love.graphics.draw(backgroundImage)
    --绘制对象
    for key, value in pairs(Game.gameObjects) do
        ---@see GameObject #draw
        value:draw()
        --触发组件绘制
        for componentName,component in pairs(value.components) do
            component:draw()
        end
    end

    Camera:unset()
    --love.graphics.pop()
    Debug.draw()
end

function love.update(dt)
    local player = playerController.player
    local width, hegiht = love.window.getMode()
    Camera:setPosition(player.position.x - width / 2, player.position.y - hegiht / 2)
    playerController:update(dt)
    --触发对象更新
    for key, value in pairs(Game.gameObjects) do
        value:update(dt) --帧事件更新
        --触发组件更新
        for componentName,component in pairs(value.components) do
            component:update(dt)
        end
    end
end

function love.keypressed(key)
    playerController:keypressed(key)
end

function love.keyreleased(key)
    playerController:keyreleased(key)
end
