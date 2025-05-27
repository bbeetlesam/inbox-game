local const = require("src/const")
local settings = require("src/apps/settings")

local appsManager = {}

appsManager.init = function()
    local window = require("src/windows")
    settings.load(window.checkItemId("settings", "content"))
end

appsManager.update = function(appId, cursor)
    if appId == "settings" then
        settings.update(cursor)
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
    end

    love.graphics.pop()
end

return appsManager