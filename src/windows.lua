local utils = require ("src/utils")
local const = require ("src/const")
local cursor = require ("src/cursor")

-- need this bcs there'd be a warning bout the type of the table in window.update()
---@class WindowItem
---@field x number
---@field y number

local window = {
    items = {},
    header = {
        height = 40,
        font = love.graphics.newFont(const.font.WIN95, 20),
        button = {
            size = 25,
        }
    },
    drag = {
        offset = {x = 0, y = 0},
        target = nil ---@type WindowItem|nil
    },
    clicked = false,

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

        x = love.math.random(const.game.screen.WIDTH / 2 - window.size.x / 2 - 100, const.game.screen.WIDTH / 2 - window.size.x / 2 + 100),
        y = love.math.random(const.game.screen.HEIGHT / 2 - window.size.y / 2 - 100, const.game.screen.HEIGHT / 2 - window.size.y / 2 + 100),

        hover = {
            closeButton = false,
            minimButton = false,
            header = false,
        },
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

function window.closeWindow(itemId)
    local taskbar = require ("src/taskbar")

    for i, item in ipairs(window.items) do
        if item.id == itemId then
            table.remove(window.items, i)
            break
        end
    end

    for i, item in ipairs(taskbar.items) do
        if item.id == itemId then
            table.remove(taskbar.items, i)
            break
        end
    end
end

function window.cursorClickCheck(mousecCursor)
    for i = #window.items, 1, -1 do -- from topmost to bottom
        local item = window.items[i]
        local winX, winY, winW, winH = item.x, item.y, window.size.x, window.size.y
        local headerX, headerY, headerW, headerH = item.x + 3, item.y + 3, window.size.x - 3*2, window.header.height - 3*2

        -- Check if the mouse is inside header area (click to drag)
        if item.hover.header then
            if mousecCursor.x >= headerX and mousecCursor.x <= headerX + headerW and mousecCursor.y >= headerY and mousecCursor.y <= headerY + headerH then
                window.drag.target = item
                window.drag.offset.x = mousecCursor.x - item.x
                window.drag.offset.y = mousecCursor.y - item.y
            end
        end

        -- Check if mouse is inside window area (click to focus)
        if mousecCursor.x >= winX and mousecCursor.x <= winX + winW and mousecCursor.y >= winY and mousecCursor.y <= winY + winH then
            -- Reorder window to last (top-most)
            table.remove(window.items, i)
            table.insert(window.items, item)
            window.clicked = true
            return
        else
            window.clicked = false
        end
    end
end

function window.draw()
    for _, item in ipairs(window.items) do
        local windowLabel = window.checkItemId(item.id)

        -- base taskbar
        love.graphics.setColor(const.color.SILVER_TASKBAR)
        love.graphics.rectangle("fill", item.x, item.y, window.size.x, window.size.y)
        -- window's header
        item.hover.header = utils.rectButton(cursor, item.x + 3, item.y + 3, window.size.x - 3*2, window.header.height - 3*2)
        love.graphics.setColor(item.id == window.items[#window.items].id and const.color.NAVY_BLUE or utils.setRGB(130, 130, 130))
        love.graphics.rectangle("fill", item.x + 3, item.y + 3, window.size.x - 3*2, window.header.height - 3*2)
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
        love.graphics.setFont(window.header.font)
        love.graphics.print(windowLabel, item.x + 10, item.y + 10)
        -- header buttons (close and minimize)
        item.hover.closeButton = utils.rectButton(cursor, item.x + window.size.x - window.header.button.size - 15/2, item.y + 15/2, window.header.button.size, window.header.button.size)
        item.hover.minimButton = utils.rectButton(cursor, item.x + window.size.x - window.header.button.size - 15/2 - 32.5, item.y + 15/2, window.header.button.size, window.header.button.size)
        love.graphics.setColor(const.color.SILVER_TASKBAR)
        love.graphics.rectangle("fill", item.x + window.size.x - window.header.button.size - 15/2, item.y + 15/2, window.header.button.size, window.header.button.size)
        love.graphics.rectangle("fill", item.x + window.size.x - window.header.button.size - 15/2 - 32.5, item.y + 15/2, window.header.button.size, window.header.button.size)
    end
    love.graphics.setColor(1, 1, 1) -- reset color
end

function window.update(mouseCursor)
    if love.mouse.isDown(1) and window.drag.target then
        local item = window.drag.target
        item.x = mouseCursor.x - window.drag.offset.x
        item.y = mouseCursor.y - window.drag.offset.y
    else
        window.drag.target = nil
    end

    if #window.items == 0 then
        window.clicked = false
    end
end

return window