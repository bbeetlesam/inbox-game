local utils = require ("src/utils")
local const = require ("src/const")

local window = {
    items = {},
    headerFont = love.graphics.newFont(const.font.WIN95, 20),

    size = {x = 800, y = 700, outline = 2}, -- for debugging reason
}

function window.addItem(insertedItem)
    for i, item in ipairs(window.items) do
        if item.id == insertedItem[1] then
            local currentItem = window.items[i]
            table.remove(window.items, i)
            table.insert(window.items, currentItem)
            return
        end
    end

    local newItem = {
        id = insertedItem[1],
        icon = insertedItem[2],

        x = love.math.random(200, 800),
        y = love.math.random(200, 800),
    }

    table.insert(window.items, newItem)
end

function window.checkItemId(itemId)
    if itemId == "mail" then
        return "Mail"
    elseif itemId == "date" then
        return "NetMatch"
    elseif itemId == "file" then
        return "File"
    elseif itemId == "settings" then
        return "Settings"
    end
end

function window.cursorClickCheck(cursor)
    for i = #window.items, 1, -1 do -- from topmost to bottom
        local item = window.items[i]
        local winX, winY, winW, winH = item.x, item.y, window.size.x, window.size.y

        if cursor.x >= winX and cursor.x <= winX + winW and cursor.y >= winY and cursor.y <= winY + winH then
            -- Reorder window to last (top-most)
            table.remove(window.items, i)
            table.insert(window.items, item)
            return true
        end
    end
    return false
end

function window.draw()
    for _, item in ipairs(window.items) do
        local windowLabel = window.checkItemId(item.id)

        -- base taskbar
        love.graphics.setColor(const.color.SILVER_TASKBAR)
        love.graphics.rectangle("fill", item.x, item.y, window.size.x, window.size.y)
        -- window's header
        love.graphics.setColor(item.id == window.items[#window.items].id and const.color.NAVY_BLUE or utils.setRGB(130, 130, 130))
        love.graphics.rectangle("fill", item.x + 3, item.y + 3, window.size.x - 3*2, 40 - 3*2)
        -- window's white outline
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", item.x, item.y, window.size.x, window.size.outline)
        love.graphics.rectangle("fill", item.x, item.y, window.size.outline, window.size.y)
        -- window's black outline
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", item.x + window.size.x - window.size.outline, item.y, window.size.outline, window.size.y)
        love.graphics.rectangle("fill", item.x, item.y + window.size.y - window.size.outline, window.size.x, window.size.outline)
        -- window's header text
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(window.headerFont)
        love.graphics.print(windowLabel, item.x + 10, item.y + 10)
    end
    love.graphics.setColor(1, 1, 1) -- reset color
end

return window