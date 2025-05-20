-- Taskbar widget
local const = require("src/const")
local utils = require("src/utils")
local state = require("src/state")

local taskbar = {
    start = {
        icon = love.graphics.newImage("/assets/img/windows-0.png"),
        usernameFont = love.graphics.newFont(const.font.BRITTANY, 30),
        hoverRect = false,
        isClicked = false,
    },
    font = love.graphics.newFont(const.font.WIN95, 18),
    height = const.game.TASKBAR_HEIGHT,
    items = {},
}

taskbar.draw = function()
    local x, y = 0, const.game.screen.HEIGHT - taskbar.height
    local ingameTime = utils.formatTime(state.time.game.hour, state.time.game.minute, "12")

    love.graphics.setColor(const.color.SILVER_TASKBAR)
    love.graphics.rectangle("fill", x, y, const.game.screen.WIDTH, taskbar.height)
    love.graphics.setColor(const.color.WHITE)
    love.graphics.rectangle("fill", x, y, const.game.screen.WIDTH, 2)

    -- Taskbar start button
    if taskbar.start.isClicked then
        utils.bevelRect(x + 5, y + 10/2, 35 + 45, 35, 3, const.color.SILVER_TASKBAR, {1, 1, 1}, const.color.SILVER_BEVEL)
    else
        utils.bevelRect(x + 5, y + 10/2, 35 + 45, 35, 3, const.color.SILVER_TASKBAR, const.color.SILVER_BEVEL)
    end
    love.graphics.setFont(taskbar.font)
    love.graphics.setColor(const.color.BLACK)
    love.graphics.print("Start", x + 5 + 40, y + taskbar.height/2 - 10 + 5/2)
    utils.drawImage(taskbar.start.icon, x + 10, y + 15/2, 30)

    love.graphics.setColor(const.color.SILVER_BEVEL)
    love.graphics.rectangle("fill", x + 85 + 3, y + 5, 3, taskbar.height - 10, 2, 2)

    -- Opened apps
    for i, item in ipairs(taskbar.items) do
        local textWidth = taskbar.font:getWidth("1234567890")
        local posX, posY = x + 10 + (i - 1) * (35 + textWidth + 5 + 5) + 60 + 30, y + 20/2

        if item.isClicked then
            utils.bevelRect(posX - 10/2, posY - 10/2, 35 + textWidth + 5, 35, 3, const.color.SILVER_TASKBAR, {1, 1, 1}, const.color.SILVER_BEVEL)
        else
            utils.bevelRect(posX - 10/2, posY - 10/2, 35 + textWidth + 5, 35, 3, const.color.SILVER_TASKBAR, const.color.SILVER_BEVEL)
        end
        utils.drawImage(item.icon, posX, posY, 25)

        love.graphics.setFont(taskbar.font)
        love.graphics.setColor(const.color.BLACK)
        love.graphics.print(utils.setLimiterString(item.appName, 10, "..."), posX + 30, posY + 5)
    end

    -- Start button rectangle
    local startW, startH = 250, 400
    local startX, startY = x + 5, y - startH + 4

    if taskbar.start.isClicked then
        love.graphics.setColor(const.color.BLACK)
        love.graphics.print("Start", x + 5 + 40, y + taskbar.height/2 - 10 + 5/2)

        love.graphics.setColor(const.color.SILVER_BEVEL)
        utils.bevelRect(startX, startY, startW, startH, 3, const.color.SILVER_TASKBAR, const.color.SILVER_BEVEL)
        love.graphics.setColor(const.color.NAVY_BLUE)
        love.graphics.rectangle("fill", startX + 3, startY + 3, 40, startH - 3 - 3)
        love.graphics.setColor(const.color.WHITE)
        love.graphics.setFont(taskbar.start.usernameFont)
        love.graphics.print(const.game.USERNAME, startX + 8, startY + 390, math.rad(-90))
    end

    -- Right-side taskbar
    love.graphics.setFont(taskbar.font)
    love.graphics.setColor(const.color.BLACK)
    utils.printCenterText(ingameTime, const.game.screen.WIDTH - 50, y + taskbar.height/2)
end

taskbar.update = function(cursor)
    taskbar.start.hoverRect =  utils.rectButton(cursor, 0 + 5, const.game.screen.HEIGHT - taskbar.height + 10/2, 35 + 45, 35)
    for i, item in ipairs(taskbar.items) do
        local textWidth = taskbar.font:getWidth("1234567890")
        item.hoverRect = utils.rectButton(cursor, 0 + 10 + (i - 1) * (35 + textWidth + 5 + 5) + 60 + 30 - 10/2, const.game.screen.HEIGHT - taskbar.height + 20/2 - 10/2, 35 + textWidth + 5, 35)
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
        icon = insertedItem[2],
        appName = insertedItem[1] == "mail" and "MeMail" or insertedItem[1] == "date" and "NetMatch" or
                  insertedItem[1] == "file" and "My Files" or insertedItem[1] == "settings" and "Settings",
        hoverRect = false,
        isClicked = false,
    }

    table.insert(taskbar.items, newItem)
end

taskbar.iconClicked = function()
    -- If Start is clicked
    if taskbar.start.hoverRect then
        taskbar.start.isClicked = not taskbar.start.isClicked
    else
        taskbar.start.isClicked = false
    end

    -- If an app icon is clicked
    local window = require("src/windows")
    for _, item in ipairs(taskbar.items) do
        if item.hoverRect then
            item.isClicked = true
            -- Find the window item by id and move it to the top
            for j, win in ipairs(window.items) do
                if win.id == item.id then
                    local winItem = table.remove(window.items, j)
                    table.insert(window.items, winItem)
                end
            end
        else
            item.isClicked = false
        end
    end
end

return taskbar