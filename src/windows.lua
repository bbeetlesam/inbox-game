local utils = require ("src/utils")
local const = require ("src/const")
local cursor = require ("src/cursor")

-- need this bcs there'd be a warning bout the type of the table in window.update()
---@class WindowItem
---@field x number
---@field y number
---@field size { x: number, y: number, outline: number }

local window = {
    items = {},
    minimized = {},
    header = {
        height = 40,
        font = love.graphics.newFont(const.font.WIN95, 20),
        button = {
            size = 25,
            font = love.graphics.newFont(const.font.WIN95, 14),
            isClicked = false,
        }
    },
    drag = {
        offset = {x = 0, y = 0},
        target = nil ---@type WindowItem|nil
    },
    clicked = false,
    size = {},
}

function window.checkItemId(itemId, attr)
    if itemId == "mail" then
        return (attr == "label" and "Mail") or (attr == "size" and {803, 703}) or (attr == "content" and {803 - 3*2 - 2, 703 - window.header.height - 3})
    elseif itemId == "date" then
        return (attr == "label" and "NetMatch") or (attr == "size" and {803, 703}) or (attr == "content" and {803 - 3*2 - 2, 703 - window.header.height - 3})
    elseif itemId == "file" then
        return (attr == "label" and "File") or (attr == "size" and {803, 703}) or (attr == "content" and {803 - 3*2 - 2, 703 - window.header.height - 3})
    elseif itemId == "settings" then
        return (attr == "label" and "Settings") or (attr == "size" and {603, 503}) or (attr == "content" and {603 - 3*2 - 2, 503 - window.header.height - 3})
    end
end

function window.addItem(insertedItem)
    -- If window is minimized, restore it
    local minimized = window.minimized[insertedItem[1]]
    if minimized then
        table.insert(window.items, minimized)
        window.minimized[insertedItem[1]] = nil
        return
    end

    for i, item in ipairs(window.items) do
        if item.id == insertedItem[1] then
            local currentItem = window.items[i]
            table.remove(window.items, i)
            table.insert(window.items, currentItem)
            return
        end
    end

    local windowSizeX, windowSizeY = window.checkItemId(insertedItem[1], "size")[1], window.checkItemId(insertedItem[1], "size")[2]
    local newItem = {
        id = insertedItem[1],
        icon = insertedItem[2],

        size = {
            x = windowSizeX,
            y = windowSizeY,
            outline = 3,
        },

        x = love.math.random(const.game.screen.WIDTH / 2 - windowSizeX / 2 - 100, const.game.screen.WIDTH / 2 - windowSizeX / 2 + 100),
        y = love.math.random(const.game.screen.HEIGHT / 2 - windowSizeY / 2 - 100, const.game.screen.HEIGHT / 2 - windowSizeY / 2 + 100),

        isClicked = {
            closeButton = false,
            minimButton = false,
        },

        hover = {
            closeButton = false,
            minimButton = false,
            header = false,
        },
    }

    table.insert(window.items, newItem)
end

function window.minimizeWindow(itemId)
    local taskbar = require("src/taskbar")

    -- Find and remove the window, saving its state
    for i, item in ipairs(window.items) do
        if item.id == itemId then
            -- Save the window state to minimized
            window.minimized[itemId] = item
            table.remove(window.items, i)
            break
        end
    end

    -- Unfocus the minimized app in the taskbar
    for _, tItem in ipairs(taskbar.items) do
        if tItem.id == itemId then
            tItem.isClicked = false
        end
    end

    -- Focus the next topmost window if any
    if #window.items > 0 then
        local topWindow = window.items[#window.items]
        taskbar.focusItem(topWindow.id, true)
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

function window.clickedCheck(mousecCursor)
    local taskbar = require("src/taskbar")
    for i = #window.items, 1, -1 do -- from topmost to bottom
        local item = window.items[i]
        local winX, winY, winW, winH = item.x, item.y, item.size.x, item.size.y
        local headerX, headerY, headerW, headerH = item.x + 3, item.y + 3, item.size.x - 3*2, window.header.height - 3*2

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
            taskbar.focusItem(item.id, true)
            window.clicked = true
            return
        else
            taskbar.focusItem(item.id, false)
            window.clicked = false
        end
    end
end

function window.draw()
    for _, item in ipairs(window.items) do
        local windowLabel = window.checkItemId(item.id, "label")
        local headerColor = (item.id == window.items[#window.items].id and const.color.NAVY_BLUE or utils.setRGB(130, 130, 130))

        -- window's base
        utils.bevelRect(item.x, item.y, item.size.x, item.size.y, item.size.outline, const.color.SILVER_TASKBAR, const.color.SILVER_BEVEL, const.color.WHITE)
        -- window's header
        item.hover.header = utils.rectButton(cursor, item.x + 3, item.y + 3, item.size.x - 3*2, window.header.height - 3*2)
        love.graphics.setColor(headerColor)
        love.graphics.rectangle("fill", item.x + 3, item.y + 3, item.size.x - 3*2 - 2, window.header.height - 3*2)
        -- window's header text
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(window.header.font)
        love.graphics.print(windowLabel, item.x + 10, item.y + 10)
        -- window's header buttons (close and minimize)
        utils.bevelRect(item.x + item.size.x - window.header.button.size - 15/2 - 27.5, item.y + 15/2, window.header.button.size, window.header.button.size, 2, const.color.SILVER_TASKBAR,
            item.isClicked.minimButton and const.color.WHITE or const.color.SILVER_BEVEL, item.isClicked.minimButton and const.color.SILVER_BEVEL or nil)
        utils.bevelRect(item.x + item.size.x - window.header.button.size - 15/2, item.y + 15/2, window.header.button.size, window.header.button.size, 2, const.color.SILVER_TASKBAR,
            item.isClicked.closeButton and const.color.WHITE or const.color.SILVER_BEVEL, item.isClicked.closeButton and const.color.SILVER_BEVEL or nil)
        love.graphics.setFont(window.header.button.font)
        love.graphics.setColor(const.color.BLACK)
        for _ = 1, 2 do -- double draw to get bolder looks
            love.graphics.print("_", item.x + item.size.x - window.header.button.size - 15/2 - 27.5 + 5 + 3, item.y + 15/2 + 5 + 1)
            love.graphics.print("X", item.x + item.size.x - window.header.button.size - 15/2 + 5 + 3, item.y + 15/2 + 5 + 1)
        end
    end
    love.graphics.setColor(1, 1, 1) -- reset color
end

function window.update(mouseCursor)
    -- Update hover states for close and minimize buttons
    for _, item in ipairs(window.items) do
        item.hover.minimButton = utils.rectButton(cursor, item.x + item.size.x - window.header.button.size - 15/2 - 27.5, item.y + 15/2, window.header.button.size, window.header.button.size)
        item.hover.closeButton = utils.rectButton(cursor, item.x + item.size.x - window.header.button.size - 15/2, item.y + 15/2, window.header.button.size, window.header.button.size)

        window.header.button.isClicked = item.isClicked.minimButton or item.isClicked.closeButton
    end

    -- Dragging the window
    if love.mouse.isDown(1) and window.drag.target and not window.header.button.isClicked then
        local item = window.drag.target

        local newX = mouseCursor.x - window.drag.offset.x
        local newY = mouseCursor.y - window.drag.offset.y
        if item then
            -- Clamp to screen
            local clampedX = math.max(0, math.min(newX, const.game.screen.WIDTH - item.size.x))
            local clampedY = math.max(0, math.min(newY, const.game.screen.HEIGHT - item.size.y))

            -- If clamped, update drag offset so window follows cursor smoothly
            if clampedX ~= newX then
                window.drag.offset.x = mouseCursor.x - clampedX
            end
            if clampedY ~= newY then
                window.drag.offset.y = mouseCursor.y - clampedY
            end

            item.x = clampedX
            item.y = clampedY
        end
    else
        window.drag.target = nil
    end

    if #window.items == 0 then
        window.clicked = false
    end
end

return window