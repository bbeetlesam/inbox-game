local utils = require "src/utils"

local window = {
    items = {},
    size = {x = 700, y = 600},
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
        return "Mail", utils.setRGB(49, 54, 61)
    elseif itemId == "date" then
        return "NetMatch", utils.setRGB(61, 41, 74)
    elseif itemId == "file" then
        return "File", utils.setRGB(71, 77, 60)
    elseif itemId == "settings" then
        return "Settings", utils.setRGB(59, 25, 41)
    end
end

function window.clickCheck(cursor)
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
        local text, color = window.checkItemId(item.id)

        love.graphics.setColor(color)
        love.graphics.rectangle("fill", item.x, item.y, window.size.x, window.size.y, 2)
        love.graphics.setColor(1, 1, 1)
        utils.printCenterText(text, item.x + window.size.x / 2, item.y + window.size.y / 2)
    end
    love.graphics.setColor(1, 1, 1)
end

return window