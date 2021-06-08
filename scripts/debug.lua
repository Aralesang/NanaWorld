---@class Debug 调试接口
---@field text string
Debug = {
    text = "",
}

function Debug.log(log)
    Debug.text = Debug.text .."\n"..log
end

function Debug.draw()
    love.graphics.print(Debug.text)
end

return Debug