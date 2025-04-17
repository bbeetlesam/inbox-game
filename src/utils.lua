-- Utility functions for the game

local utils = {
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
}

return utils