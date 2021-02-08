package.cpath = package.cpath .. ';plugins/?.dll'
local dbg = require('emmy_core')
dbg.tcpListen('localhost', 9966)
--dbg.waitIDE()
require "plugins.camera"
require "scripts.global"
local GameObject = require "scripts.game_object"
local Game = require "scripts.game"
local Animation = require "plugins.animation"
local Role = require "scripts.role"
local PlayerController = require "scripts.player_controller"

---@type Role[]
local roleArr = {}
---@type PlayerController 玩家控制器
local playerController
--背景图片
local backgroundImage
--世界
local world
--物理对象列表
local objects = {}

function love.load()
    print("游戏启动...")

    love.physics.setMeter(64) --the height of a meter our worlds will be 64px
    world = love.physics.newWorld(0, 9.81 * 64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
    worlds[0] = world
    --加载中文字体(启动太过缓慢所以先不加载了)
    --local myFont = love.graphics.newFont("simhei.ttf",24)
    --love.graphics.setFont(myFont)
    --love.keyboard.setKeyRepeat(true)
    --更改图像过滤方式，以显示高清马赛克
    love.graphics.setDefaultFilter("nearest", "nearest")
    --加载背景图片
    backgroundImage = love.graphics.newImage("image/background.jpg")
    --创建npc
    local npc = Role:new("image/npc.png", "娜娜")
    --npc:setScale(2,2)
    npc.animation:stop(0)
    roleArr["nana"] = npc

    --创建角色
    local player = Role:new("image/player.png", "player", 50, 0)
    --player:setScale(2,2)
    roleArr["sakuya"] = player

    print(player.gameObjectName)
    print(player.name)

    --初始化角色控制器
    playerController = PlayerController:new(player)

    for key, value in pairs(Game.gameObjects) do
        value:load()
    end
end

function love.draw()
    Camera:set()
    local player = playerController.player
    ---绘制背景
    --love.graphics.draw(backgroundImage)
    --绘制对象
    for key, value in pairs(Game.gameObjects) do
        value:draw()
    end

	Camera:unset()
end

function love.update(dt)
    world:update(dt) --this puts the world into motion

    local player = playerController.player
    local width, hegiht = love.window.getMode()
    Camera:setPosition(player.position.x - width / 2, player.position.y - hegiht / 2)
    playerController:update(dt)
    --触发对象更新
    for key, value in pairs(Game.gameObjects) do
        value:animUpdate(dt) --动画更新
        value:update(dt) --帧事件更新
    end
end

function love.keypressed(key)
    playerController:keypressed(key)
end

function love.keyreleased(key)
    playerController:keyreleased(key)
end
