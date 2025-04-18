-- Utility functions for the game

local utils = {
    core = {
        setGameScreen = function(gameWidth, gameHeight)
            local offsetX, offsetY
            local screenWidth, screenHeight = love.graphics.getDimensions()
            local mouseX, mouseY = love.mouse.getPosition()

            -- Scale based on aspect ratio
            local scaleX = screenWidth/gameWidth
            local scaleY = screenHeight/gameHeight

            -- Choose the smaller scale to fit the screen
            if scaleX > scaleY then
                scaleX = scaleY
                offsetX = (screenWidth-gameWidth*scaleX)/2
                offsetY = 0
            else
                scaleY = scaleX
                offsetX = 0
                offsetY = (screenHeight-gameHeight*scaleY)/2
            end

            return offsetX, offsetY, scaleX, scaleY, (mouseX-offsetX)/scaleX, (mouseY-offsetY)/scaleY
        end,

        setBaseBgColor = function(...)
            love.graphics.setColor(...)
            love.graphics.rectangle("fill", 0, 0, 1440, 1080)
            love.graphics.setColor(1, 1, 1, 1)
        end,

        toggleFullscreen = function()
            local isFullscreen = love.window.getFullscreen()
            love.window.setFullscreen(not isFullscreen)
        end,
    },

    setRGB = function(...)
        local args = {...}
        if type(...) == "table" then
            args = {unpack(...)}
        end
        local r, g, b, a = args[1], args[2], args[3], args[4]
        return {r/255, g/255, b/255, a or 1}
    end,
}

return utils