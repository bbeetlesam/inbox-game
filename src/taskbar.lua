-- Taskbar widget
local const = require("src/const")
local utils = require("src/utils")

local taskbar = {
    height = const.game.TASKBAR_HEIGHT,
    items = {},
}

taskbar.drawTaskbar = function()
    local x, y = 0, const.game.screen.HEIGHT - taskbar.height

    love.graphics.setColor(const.color.SILVER_TASKBAR)
    love.graphics.rectangle("fill", x, y, const.game.screen.WIDTH, taskbar.height)

    for i, item in ipairs(taskbar.items) do
        utils.drawImage(item.icon, x + 10 + (i - 1) * 40, y + 20/2, 25)
    end
end

taskbar.addItem = function(insertedItem)
    for _, item in pairs(taskbar.items) do
        if item.id == insertedItem[1] then
            return
        end
    end

    local newItem = {
        id = insertedItem[1],
        icon = insertedItem[2]
    }

    table.insert(taskbar.items, newItem)
end

return taskbar