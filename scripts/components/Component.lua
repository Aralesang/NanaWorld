---@class Component 组件
---@field componentName string 组件名称
---@field gameObject GameObject 组件所附加到的游戏物体
---@field update function
local Component = {
    componentName = nil,
    gameObject = nil,
}

function Component:new()
    ---@type Component
    local o = {}
    setmetatable(o,{__index = self})
    o.load = self.load
    o.draw = self.draw
    return o
end

return Component