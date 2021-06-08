---@class Component 组件
---@field componentName string 组件名称
---@field gameObject GameObject 组件所附加到的游戏物体
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
    o.update = self.update
    return o
end

-- function Component:load()
--     Debug.log("加载:"..self.componentName)
-- end

-- function Component:draw()

-- end

-- function Component:update(dt)
    
-- end

return Component