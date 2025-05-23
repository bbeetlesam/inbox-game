local utils = require "src/utils"
local const = require "src/const"

local apps = {
    labelFont = love.graphics.newFont(const.font.WIN95, 16),
    app = {
        {id = "mail", label = "MeMail", icon = love.graphics.newImage("/assets/img/envelope_closed-0.png"), isSelect = false, isHover = false},
        {id = "date", label = "NetMatch", icon = love.graphics.newImage("/assets/img/msn3-3.png"), isSelect = false, isHover = false},
        {id = "file", label = "My Files", icon = love.graphics.newImage("/assets/img/directory_open_file_mydocs_2k-4.png"), isSelect = false, isHover = false},
        {id = "settings", label = "Settings", icon = love.graphics.newImage("/assets/img/computer_explorer_cool-0.png"), isSelect = false, isHover = false},
    },
    selectedApp = {id = nil, icon = nil},
    rectSize = 100,
    iconSize = 70,
}

apps.draw = function()
    for i, app in ipairs(apps.app) do
        local verticalGap = 12

        local x, y = 0, (apps.rectSize + verticalGap) * (i - 1) + 6
        local diff = (apps.rectSize - apps.iconSize) / 2

        love.graphics.setFont(apps.labelFont)
        -- love.graphics.rectangle("fill", x, y, apps.rectSize, apps.rectSize)
        love.graphics.setColor(0, 0, 1)
        -- love.graphics.rectangle("fill", x + diff, y + 5, apps.iconSize, apps.iconSize)
        love.graphics.setColor(1, 1, 1)
        utils.drawImage(app.icon, x + diff, y + 5, apps.iconSize)

        utils.printCenterText(app.label, x + apps.rectSize / 2, y + apps.rectSize - 15, app.isSelect, const.color.NAVY_BLUE, {1, 2})
    end
    love.graphics.setColor(1, 1, 1) -- reset color
end

apps.update = function(cursor)
    for i, app in ipairs(apps.app) do
        local x, y = 0, (apps.rectSize + 12) * (i - 1) + 6
        local w = apps.rectSize
        local h = apps.rectSize

        if cursor.x >= x and cursor.x <= x + w and
           cursor.y >= y and cursor.y <= y + h then
            app.isHover = true
        else
            app.isHover = false
        end
    end
end

apps.mousepressed = function(cursor)
    local windows = require "src/windows"
    local taskbar = require "src/taskbar"
    local clickedApp = false

    for i, app in ipairs(apps.app) do
        local x, y = 0, (apps.rectSize + 12) * (i - 1) + 6
        local w = apps.rectSize
        local h = apps.rectSize

        if cursor.x >= x and cursor.x <= x + w and
           cursor.y >= y and cursor.y <= y + h and windows.clicked == false then
            apps.selectedApp.id = app.id
            apps.selectedApp.icon = app.icon

            for j, otherApp in ipairs(apps.app) do
                otherApp.isSelect = (i == j)
            end

            taskbar.focusItem(apps.selectedApp.id, true)
            clickedApp = true
            break
        end
    end

    if not clickedApp then
        apps.selectedApp.id = nil
        apps.selectedApp.icon = nil
        for _, app in ipairs(apps.app) do
            app.isSelect = false
        end
    end
end

return apps