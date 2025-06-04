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

        -- Applied only when taking screenshots of this game (used in itch.io page)
        screenshotMode = function(screenSize, outlineThickness, outlineColor)
            outlineThickness = outlineThickness or 3
            love.graphics.setBackgroundColor(love.math.colorFromBytes(192, 192, 192)) -- const.color.SILVER_TASKBAR

            love.graphics.setColor(outlineColor or {0, 0, 0})
            love.graphics.setLineWidth(outlineThickness)
            love.graphics.rectangle("line", 0 + outlineThickness/2, 0 + outlineThickness/2, screenSize[1] - outlineThickness, screenSize[2] - outlineThickness)
            love.graphics.setColor(1, 1, 1)
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
        local prevColor = {love.graphics.getColor()}

        if useBorder then
            love.graphics.setColor(borderColor or {1, 1, 1})
            love.graphics.rectangle("fill", centerX - textWidth / 2 - (borderOffset[1] or 1), centerY - textHeight / 2 - (borderOffset[2] or 1),
            textWidth + (borderOffset[1] or 1) * 2, textHeight + (borderOffset[2] or 1) * 2)
        end

        love.graphics.setColor(prevColor)
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

    bevelRect = function(x, y, w, h, shaderWidth, baseColor, lowerColor, upperColor, bevelPlacement)
        local lowercolor = lowerColor or {0.3, 0.3, 0.3}
        local uppercolor = upperColor or {1, 1, 1}
        local bevelPlace = bevelPlacement or {1, 1, 1, 1} -- top, right, bottom, left

        love.graphics.setColor(baseColor)
        love.graphics.rectangle("fill", x, y, w, h)
        love.graphics.setColor(uppercolor)
        love.graphics.rectangle("fill", x, y, w, shaderWidth) -- top
        love.graphics.rectangle("fill", x, y, shaderWidth, h - shaderWidth) -- left
        love.graphics.setColor(lowercolor)
        love.graphics.rectangle("fill", x, y + h - shaderWidth, w, shaderWidth) -- down
        love.graphics.rectangle("fill", x + w - shaderWidth, y, shaderWidth, h) -- right

        if bevelPlace[1] == 0 then love.graphics.setColor(baseColor) love.graphics.rectangle("fill", x, y, w, shaderWidth) end -- top
        if bevelPlace[4] == 0 then love.graphics.setColor(baseColor) love.graphics.rectangle("fill", x, y, shaderWidth, h) end -- left
        if bevelPlace[3] == 0 then love.graphics.setColor(baseColor) love.graphics.rectangle("fill", x, y + h - shaderWidth, w, shaderWidth) end -- right
        if bevelPlace[2] == 0 then love.graphics.setColor(baseColor) love.graphics.rectangle("fill", x + w - shaderWidth, y, shaderWidth, h) end -- bottom
        love.graphics.setColor(1, 1, 1)
    end,

    setLimiterString = function(str, limit, limiterString)
        local limiterstr = limiterString or "..."
        if #str <= limit then
            return str
        elseif #str > limit then
            return str:sub(1, limit - #limiterstr) .. limiterstr
        end
    end,

    drawSectionDivider = function(mode, x, y, length, thickness, color1, color2)
        color1 = color1 or {0.45, 0.45, 0.45}
        color2 = color2 or {1, 1, 1}

        if mode == "horizontal" then
            love.graphics.setColor(color1 or love.math.colorFromBytes(115, 115, 115))
            love.graphics.rectangle("fill", x, y, length, thickness)
            love.graphics.setColor(color2 or {1, 1, 1})
            love.graphics.rectangle("fill", x, y + thickness, length, thickness)
        elseif mode == "vertical" then
            love.graphics.setColor(color1 or love.math.colorFromBytes(115, 115, 115))
            love.graphics.rectangle("fill", x, y, thickness, length)
            love.graphics.setColor(color2 or {1, 1, 1})
            love.graphics.rectangle("fill", x + thickness, y, thickness, length)
        end
    end,
}

utils.copyTable = function(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[utils.copyTable(orig_key)] = utils.copyTable(orig_value)
        end
        setmetatable(copy, utils.copyTable(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

utils.isTablesEqual = function(t1, t2)
    if t1 == t2 then return true end
    if type(t1) ~= "table" or type(t2) ~= "table" then return false end

    -- Check all keys in t1
    for k, v in pairs(t1) do
        if not utils.isTablesEqual(v, t2[k]) then
            return false
        end
    end
    -- Check for extra keys in t2
    for k in pairs(t2) do
        if t1[k] == nil then
            return false
        end
    end
    return true
end

return utils