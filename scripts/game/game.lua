---@class Game
---@field public gameObjects GameObject[] 游戏对象集合
local Game = 
{
    gameObjects = {}, --游戏对象集合
    controllers = {} --碰撞器字典 
}

return Game