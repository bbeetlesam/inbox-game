-- Cursor code
local state = require("src/state")

local cursor = {
    cursorImage = love.graphics.newImage("assets/img/cursor.png"),
    size = 5,
    x = state.mouse.x - 5 / 2,
    y = state.mouse.y - 5 / 2,
}

cursor.update = function()
    cursor.x = state.mouse.x - 5 / 2
    cursor.y = state.mouse.y - 5 / 2
end

cursor.draw = function()
    love.graphics.setColor(1, 1, 1) -- reset color, avoid cursor color changing
    -- love.graphics.rectangle("fill", cursor.x, cursor.y, cursor.size, cursor.size) -- mouse pos
    love.graphics.draw(cursor.cursorImage, cursor.x, cursor.y, 0, 1 / 20, 1 / 20, 45, 20) -- mouse cursor
end

return cursor