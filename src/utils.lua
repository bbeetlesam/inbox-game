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
            args = {table.unpack(...)}
        end
        local r, g, b, a = args[1], args[2], args[3], args[4]
        return {r/255, g/255, b/255, a or 1}
    end,

    printCenterText = function(text, centerX, centerY, useBorder, borderColor, borderOffset)
        local font = love.graphics.getFont()
        local textWidth = font:getWidth(text)
        local textHeight = font:getHeight()

        if useBorder then
            love.graphics.setColor(borderColor or {1, 1, 1})
            love.graphics.rectangle("fill", centerX - textWidth / 2 - (borderOffset[1] or 1), centerY - textHeight / 2 - (borderOffset[2] or 1),
            textWidth + (borderOffset[1] or 1) * 2, textHeight + (borderOffset[2] or 1) * 2)

            love.graphics.setColor(1, 1, 1)
        end

        love.graphics.print(text, centerX - textWidth / 2, centerY - textHeight / 2)
    end,

    drawImage = function(image, x, y, size)
        local width, height = image:getDimensions()
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(image, x, y, 0, size / width, size / height)
    end,

    rectButton = function(cursor, x, y, w, h)
        return (cursor.x >= x and cursor.x <= x + w and cursor.y >= y and cursor.y <= y + h)
    end,

    formatTime = function(hour, minute, format)
        local period = "AM"
        if hour >= 12 then
            period = "PM"
        end

        local hour12 = hour % 12
        if hour12 == 0 then
            hour12 = 12
        end

        if format == "24" then
            return string.format("%02d:%02d", hour, minute)
        end
        return string.format("%02d:%02d %s", hour12, minute, period)
    end,

    bevelRect = function(x, y, w, h, shaderWidth, baseColor, upperColor, lowerColor)
        local lowercolor = upperColor or {0.3, 0.3, 0.3}
        local uppercolor = lowerColor or {1, 1, 1}

        love.graphics.setColor(baseColor)
        love.graphics.rectangle("fill", x, y, w, h)
        love.graphics.setColor(uppercolor)
        love.graphics.rectangle("fill", x, y, w, shaderWidth)
        love.graphics.rectangle("fill", x, y, shaderWidth, h - shaderWidth)
        love.graphics.setColor(lowercolor)
        love.graphics.rectangle("fill", x, y + h - shaderWidth, w, shaderWidth)
        love.graphics.rectangle("fill", x + w - shaderWidth, y + shaderWidth*0, shaderWidth, h - shaderWidth*0)
    end,

    setLimiterString = function(str, limit, limiterString)
        local limiterstr = limiterString or "..."
        if #str <= limit then
            return str
        elseif #str > limit then
            return str:sub(1, limit - #limiterstr) .. limiterstr
        end
    end
}

return utils