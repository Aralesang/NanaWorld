---@class Debug 调试接口
---@field text table 当前所显示的日志文本
Debug = {
    text = {},
}

---显示信息到屏幕
---@param log string 要显示的文本
function Debug.log(log)
    table.insert(Debug.text,log)
end

---@private
function Debug.draw()
    local text = "FPS:" .. love.timer.getFPS() .. "\n"
    for k,v in pairs(Debug.text) do
        text = text .. v .. "\n"
    end
    love.graphics.print(text)
end