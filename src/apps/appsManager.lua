local const = require("src/const")
local settings = require("src/apps/settings")
local file = require("src/apps/file")

local appsManager = {}

appsManager.init = function()
    local window = require("src/windows")
    settings.load(window.checkItemId("settings", "content"))
    file.load(window.checkItemId("file", "content"))
end

-- Reset all apps' states to default when the app is closed
appsManager.resetAppsState = function(appId)
    if appId == "settings" then
        settings.resetStates()
    elseif appId == "file" then
        file.resetStates()
    end
end

appsManager.update = function(appId, cursor, baseCoordinate, windowAttributes)
    local windowHeaderHeight, windowOutlineSize = windowAttributes[1], windowAttributes[2]
    local offsetX = baseCoordinate[1] + windowOutlineSize
    local offsetY = baseCoordinate[2] + windowOutlineSize + windowHeaderHeight - 3*2

    if appId == "settings" then
        settings.update(cursor, {offsetX, offsetY})
    elseif appId == "file" then
        file.update(cursor, {offsetX, offsetY})
    end
end

appsManager.draw = function(appId, baseCoordinate, windowAttributes)
    local windowWidth, windowHeight, windowHeaderHeight, windowOutlineSize = windowAttributes[1], windowAttributes[2], windowAttributes[3], windowAttributes[4]
    local designWidth, designHeight = windowWidth, windowHeight
    local scaleX, scaleY  = windowWidth / designWidth, windowHeight / designHeight

    love.graphics.push()
    love.graphics.translate(baseCoordinate[1] + windowOutlineSize, baseCoordinate[2] + windowOutlineSize + windowHeaderHeight - 3*2)
    love.graphics.scale(scaleX, scaleY)

    love.graphics.setColor(const.color.WHITE)
    if appId == "settings" then
        settings.draw()
    elseif appId == "file" then
        file.draw()
    end

    love.graphics.pop()
end

appsManager.firstClickedCheck = function(appId, cursor, baseCoordinate, windowAttributes)
    local windowHeaderHeight, windowOutlineSize = windowAttributes[1], windowAttributes[2]
    local offsetX = baseCoordinate[1] + windowOutlineSize
    local offsetY = baseCoordinate[2] + windowOutlineSize + windowHeaderHeight - 3*2

    if appId == "settings" then
        settings.firstClickedCheck()
    elseif appId == "file" then
        file.firstClickedCheck(cursor, {offsetX, offsetY})
    end
end

appsManager.lastClickedCheck = function(appId)
    if appId == "settings" then
        settings.lastClickedCheck()
    end
end

appsManager.doubleFirstClickedChecck = function(appId, cursor, baseCoordinate, windowAttributes)
    local windowHeaderHeight, windowOutlineSize = windowAttributes[1], windowAttributes[2]
    local offsetX = baseCoordinate[1] + windowOutlineSize
    local offsetY = baseCoordinate[2] + windowOutlineSize + windowHeaderHeight - 3*2

    if appId == "settings" then
    elseif appId == "file" then
        file.doubleFirstClickedCheck(cursor, {offsetX, offsetY})
    end
end

return appsManager