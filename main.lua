package.cpath =
    package.cpath ..
    ";C:/Users/leshu/AppData/Roaming/JetBrains/IdeaIC2020.2/plugins/intellij-emmylua/classes/debugger/emmy/windows/x64/?.dll"
local dbg = require("emmy_core")
dbg.tcpListen("localhost", 9966)
--dbg.waitIDE()
require "plugins.camera"
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

    objects = {} -- table to hold all our physical objects

    --let's create the ground
    objects.ground = {}
    objects.ground.body = love.physics.newBody(world, 650 / 2, 650 - 50 / 2) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
    objects.ground.shape = love.physics.newRectangleShape(650, 50) --make a rectangle with a width of 650 and a height of 50
    objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape) --attach shape to body

    --let's create a ball
    objects.ball = {}
    objects.ball.body = love.physics.newBody(world, 650 / 2, 650 / 2, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
    objects.ball.shape = love.physics.newCircleShape(20) --the ball's shape has a radius of 20
    objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
    objects.ball.fixture:setRestitution(0.9) --let the ball bounce

    --let's create a couple blocks to play around with
    objects.block1 = {}
    objects.block1.body = love.physics.newBody(world, 200, 550, "dynamic")
    objects.block1.shape = love.physics.newRectangleShape(0, 0, 50, 100)
    objects.block1.fixture = love.physics.newFixture(objects.block1.body, objects.block1.shape, 5) -- A higher density gives it more mass.

    objects.block2 = {}
    objects.block2.body = love.physics.newBody(world, 200, 400, "dynamic")
    objects.block2.shape = love.physics.newRectangleShape(0, 0, 100, 50)
    objects.block2.fixture = love.physics.newFixture(objects.block2.body, objects.block2.shape, 2)

    love.graphics.setBackgroundColor(0.41, 0.53, 0.97) --set the background color to a nice blue
    love.window.setMode(650, 650) --set the window dimensions to 650 by 650 with no fullscreen, vsync on, and no antialiasing

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
	
	love.graphics.setColor(0.28, 0.63, 0.05) -- set the drawing color to green for the ground
  	love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates

	love.graphics.setColor(0.76, 0.18, 0.05) --set the drawing color to red for the ball
	love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
	
	love.graphics.setColor(0.20, 0.20, 0.20) -- set the drawing color to grey for the blocks
	love.graphics.polygon("fill", objects.block1.body:getWorldPoints(objects.block1.shape:getPoints()))
	love.graphics.polygon("fill", objects.block2.body:getWorldPoints(objects.block2.shape:getPoints()))

end

function love.update(dt)

	world:update(dt) --this puts the world into motion
 
	--here we are going to create some keyboard events
	if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
		objects.ball.body:applyForce(400, 0)
	elseif love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
		objects.ball.body:applyForce(-400, 0)
	elseif love.keyboard.isDown("up") then --press the up arrow key to set the ball in the air
		objects.ball.body:setPosition(650/2, 650/2)
		objects.ball.body:setLinearVelocity(0, 0) --we must set the velocity to zero to prevent a potentially large velocity generated by the change in position
	end


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
