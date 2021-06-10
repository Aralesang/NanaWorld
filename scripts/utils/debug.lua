---@class Debug 调试接口
---@field text string 当前所显示的日志文本
Debug = {
    text = "",
}

---显示信息到屏幕
---@param log string 要显示的文本
function Debug.log(log)
    Debug.text = Debug.text .."\n"..log
end

---@private
function Debug.draw()
    love.graphics.print(Debug.text)
end

return Debug