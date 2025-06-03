local const = require("src/const")
local utils = require("src/utils")
local state = require("src/state")

local settings = {
    content = {
        width = 0, height = 0,
        previousSettings = utils.copyTable(state.settings), -- to store previous settings before applying changes
        currentSettings = utils.copyTable(state.settings), -- to store current settings
        selectedSection = "wallpaper",
    },
    font = {
        default = love.graphics.newFont(const.font.WIN95, 18),
        generalNumber = love.graphics.newFont(const.font.WIN95, 24),
    },
    innerBevel = {
        w = 575, h = 500,
    },
    lowerButton = {
        w = 95, h = 35, gapX = 7,
        ok = {isHovered = false, isClicked = false},
        cancel = {isHovered = false, isClicked = false},
        apply = {isHovered = false, isClicked = false}
    },
    upperButton = {
        wallpaper = {height = 35, hoverRect = false},
        general = {height = 35, hoverRect = false},
        permissions = {height = 35, hoverRect = false},
        about = {height = 35, hoverRect = false},
    },
    wallpaper = {
        isHovered = {false, false, false}, -- green, blue, gray
        isClicked = {false, false, false}, -- green, blue, gray
        colors = {
            green = {const.color.DEEP_TEAL, "Green"},
            blue  = {const.color.WALLPAPER_BLUE, "Blue"},
            gray  = {const.color.TROLLEY_GREY, "Gray"},
        },
    },
    general = {
        volume = {"Volume", love.graphics.newImage("assets/img/loudspeaker_rays-0.png"), buttonX = 0, buttonY = 0, isHovered = false, isClicked = false, dragStartX = 0, buttonStartX = 0},
        brightness = {"Brightness", love.graphics.newImage("assets/img/kodak_imaging-0.png"), buttonX = 0, buttonY = 0, isHovered = false, isClicked = false, dragStartX = 0, buttonStartX = 0},
    }
}

-- Helpers (to break long fvkin codes)
local unpack = unpack or table.unpack -- portable across Lua versions
local function ifSelectedSection(section, trueVal, falseVal)
    return settings.content.selectedSection == section and trueVal or falseVal
end

settings.load = function(contentSizes)
    settings.content.width, settings.content.height = contentSizes[1], contentSizes[2]
    settings.innerBevel.startX = settings.content.width/2 - settings.innerBevel.w/2
    settings.innerBevel.startY = settings.content.height/2 - settings.innerBevel.h/2
    settings.lowerButton.startX = settings.innerBevel.w - (settings.lowerButton.w*3 + settings.lowerButton.gapX*2) + 10
    settings.lowerButton.startY = settings.content.height/2 - settings.innerBevel.h/2 + settings.innerBevel.h + 2.5 + 5
    settings.upperButton.startY = settings.innerBevel.startY - 35 + 3

    -- Refresh general section's buttons positions
    for i, section in ipairs({"volume", "brightness"}) do
        settings.general[section].buttonX = settings.innerBevel.startX + (settings.innerBevel.w/2 - 550/2) + (400 - 20)*(settings.content.currentSettings[section]/100)
        settings.general[section].buttonY = settings.innerBevel.startY + 15 + 45 + 1 - 30/2 + (i-1)*(82 + 15)
    end
end

settings.saveChangedSettings = function()
    state.settings = utils.copyTable(settings.content.currentSettings)
    settings.content.previousSettings = utils.copyTable(state.settings)
end

settings.resetStates = function()
    settings.content.selectedSection = "wallpaper"
    settings.content.currentSettings = utils.copyTable(state.settings)

    for i, section in ipairs({"volume", "brightness"}) do
        settings.general[section].buttonX = settings.innerBevel.startX + (settings.innerBevel.w/2 - 550/2) + (400 - 20)*(settings.content.currentSettings[section]/100)
        settings.general[section].buttonY = settings.innerBevel.startY + 15 + 45 + 1 - 30/2 + (i-1)*(82 + 15)
    end
end

settings.drawWallpaperSection = function()
    local x, y = settings.innerBevel.startX, settings.innerBevel.startY
    local computer = {w = 250, h = 188, inW = 210, inH = 157}
    computer.x, computer.y = (x+settings.innerBevel.w)/2 - computer.w/2, y + 35
    local wallpaper = settings.wallpaper.colors[settings.content.currentSettings.wallpaper][1]

    -- computer drawings
    utils.bevelRect(computer.x+computer.w/2 - 100/2, computer.y + computer.h - 3, 100, 13, 3, const.color.SILVER_TASKBAR, const.color.SILVER_BEVEL, const.color.WHITE, {0, 1, 1, 1})
    utils.bevelRect(computer.x, computer.y, computer.w, computer.h, 4, const.color.SILVER_TASKBAR, const.color.SILVER_BEVEL, const.color.WHITE)
    utils.bevelRect(computer.x + (computer.w-computer.inW)/2, computer.y + (computer.h-computer.inH)/2, computer.inW, computer.inH, 3,
        wallpaper, const.color.WHITE, const.color.SILVER_BEVEL)
    utils.bevelRect(computer.x+computer.w/2 - 200/2, computer.y + computer.h + 10, 200, 9, 2, const.color.SILVER_TASKBAR, const.color.SILVER_BEVEL, const.color.WHITE)
    -- below computer
    utils.bevelRect(computer.x + computer.w/2 - 260/2, computer.y + computer.h + 10 + 9 + 30, 260, 180, 1, const.color.SILVER_TASKBAR, const.color.SILVER_BEVEL, const.color.SILVER_BEVEL) -- outer outline
    utils.bevelRect(computer.x + computer.w/2 - 240/2, computer.y + computer.h + 10 + 9 + 45, 240, 100, 3, utils.setRGB(246, 244, 241), utils.setRGB(170, 170, 170), const.color.SILVER_BEVEL) -- inner menu
    love.graphics.setColor(const.color.BLACK)
    love.graphics.setFont(settings.font.default)
    utils.printCenterText("Wallpaper", computer.x + computer.w/2 - 83, computer.y + computer.h + 10 + 9 + 30, true, const.color.SILVER_TASKBAR, {1, 1})
    for i, name in ipairs({"green", "blue", "gray"}) do
        local color = settings.wallpaper.colors[name]
        if settings.content.currentSettings.wallpaper == name then
            love.graphics.setColor(const.color.NAVY_BLUE)
            love.graphics.rectangle("fill", computer.x + computer.w/2 - 240/2 + 3, computer.y + computer.h + 10 + 9 + 45 + 3 + (i-1)*20, 240 - 6, 20)
        end
        love.graphics.setColor(settings.content.currentSettings.wallpaper == name and const.color.WHITE or const.color.BLACK)
        love.graphics.print(color[2], computer.x + computer.w/2 - 240/2 + 5, computer.y + computer.h + 10 + 9 + 45 + 5 + (i-1)*20)
    end
end

settings.drawGeneralSection = function()
    local x, y = settings.innerBevel.startX, settings.innerBevel.startY + 15
    local but = {w = 20, h = 30}
    local sections = {"volume", "brightness"}

    for i, section in ipairs(sections) do
        local xx = x + (settings.innerBevel.w/2 - 550/2)
        local plus = (i-1)*(82 + 15)

        utils.drawImage(settings.general[section][2], xx, y - 3 + plus, 20)
        love.graphics.setColor(const.color.BLACK)
        love.graphics.setFont(settings.font.default)
        love.graphics.print(settings.general[section][1], xx + 25, y + plus) -- label
        love.graphics.setFont(settings.font.generalNumber)
        love.graphics.printf(settings.content.currentSettings[section], xx, y + 37 + plus, 550, "right") -- values
        utils.bevelRect(xx, y + 45 + plus, 400, 6, 2, const.color.BLACK, const.color.WHITE, const.color.SILVER_BEVEL) -- button bar
        utils.bevelRect(settings.general[section].buttonX, settings.general[section].buttonY, but.w, but.h, 3, const.color.SILVER_TASKBAR, const.color.SILVER_BEVEL, const.color.WHITE) -- button
        utils.drawSectionDivider("horizontal", xx, y + 80 + plus, 550, 2)
    end
end

settings.draw = function()
    -- inner rectangle
    utils.bevelRect(settings.innerBevel.startX, settings.innerBevel.startY, settings.innerBevel.w, settings.innerBevel.h,
        3, const.color.SILVER_TASKBAR, const.color.SILVER_BEVEL, const.color.WHITE)
    -- upper buttons
    local upperBArgs = {3, const.color.SILVER_TASKBAR, const.color.SILVER_BEVEL, const.color.WHITE, {1, 1, 0, 1}}
    love.graphics.setFont(settings.font.default)
    utils.bevelRect(settings.innerBevel.startX, settings.upperButton.startY - ifSelectedSection("wallpaper", 6, 0),
        100, settings.upperButton.wallpaper.height, unpack(upperBArgs))
    utils.bevelRect(settings.innerBevel.startX + 100, settings.upperButton.startY - ifSelectedSection("general", 6, 0),
        80, settings.upperButton.general.height, unpack(upperBArgs))
    utils.bevelRect(settings.innerBevel.startX + 100 + 80, settings.upperButton.startY - ifSelectedSection("permissions", 6, 0),
        110, settings.upperButton.permissions.height, unpack(upperBArgs))
    utils.bevelRect(settings.innerBevel.startX + 100 + 80 + 110, settings.upperButton.startY - ifSelectedSection("about", 6, 0),
        70, settings.upperButton.about.height, unpack(upperBArgs))
    love.graphics.setColor(const.color.BLACK)
    love.graphics.print("Wallpaper", settings.innerBevel.startX + 10, settings.upperButton.startY + 10 - ifSelectedSection("wallpaper", 3, 0))
    love.graphics.print("General", settings.innerBevel.startX + 10 + 100, settings.upperButton.startY + 10 - ifSelectedSection("general", 3, 0))
    love.graphics.print("Permissions", settings.innerBevel.startX + 10 + 100 + 80, settings.upperButton.startY + 10 - ifSelectedSection("permissions", 3, 0))
    love.graphics.print("About", settings.innerBevel.startX + 10 + 100 + 80 + 110, settings.upperButton.startY + 10 - ifSelectedSection("about", 3, 0))
    -- 3 lower buttons
    local addPosLower = settings.lowerButton.w + settings.lowerButton.gapX
    utils.bevelRect(settings.lowerButton.startX, settings.lowerButton.startY, settings.lowerButton.w, settings.lowerButton.h, 3, const.color.SILVER_TASKBAR,
        settings.lowerButton.ok.isClicked and const.color.WHITE or const.color.SILVER_BEVEL, settings.lowerButton.ok.isClicked and const.color.SILVER_BEVEL or const.color.WHITE)
    utils.bevelRect(settings.lowerButton.startX + addPosLower, settings.lowerButton.startY, settings.lowerButton.w, settings.lowerButton.h, 3, const.color.SILVER_TASKBAR,
        settings.lowerButton.cancel.isClicked and const.color.WHITE or const.color.SILVER_BEVEL, settings.lowerButton.cancel.isClicked and const.color.SILVER_BEVEL or const.color.WHITE)
    utils.bevelRect(settings.lowerButton.startX + addPosLower*2, settings.lowerButton.startY, settings.lowerButton.w, settings.lowerButton.h, 3, const.color.SILVER_TASKBAR,
        settings.lowerButton.apply.isClicked and const.color.WHITE or const.color.SILVER_BEVEL, settings.lowerButton.apply.isClicked and const.color.SILVER_BEVEL or const.color.WHITE)
    love.graphics.setColor(const.color.BLACK)
    utils.printCenterText("OK", settings.lowerButton.startX + settings.lowerButton.w/2, settings.lowerButton.startY + 17.5, false, const.color.BLACK)
    utils.printCenterText("Cancel", settings.lowerButton.startX + settings.lowerButton.w/2*3 + settings.lowerButton.gapX, settings.lowerButton.startY + 17.5, false, const.color.BLACK)
    love.graphics.setColor(not utils.isTablesEqual(settings.content.currentSettings, settings.content.previousSettings) and const.color.BLACK or const.color.SILVER_UNAVAILABLE)
    utils.printCenterText("Apply", settings.lowerButton.startX + settings.lowerButton.w/2*5 + settings.lowerButton.gapX*2, settings.lowerButton.startY + 17.5, false, const.color.BLACK)
    -- current selected section
    if settings.content.selectedSection == "wallpaper" then
        settings.drawWallpaperSection()
    elseif settings.content.selectedSection == "general" then
        settings.drawGeneralSection()
    elseif settings.content.selectedSection == "permissions" then
        -- settings.drawPermissionsSection()
    elseif settings.content.selectedSection == "about" then
        -- settings.drawAboutSection()
    end
end

settings.update = function(mouseCursor, offsets)
    local cursor = {x = mouseCursor.x  - offsets[1], y = mouseCursor.y - offsets[2]}
    local addPosLower = settings.lowerButton.w + settings.lowerButton.gapX

    -- Code updates goes here
    settings.lowerButton.ok.isHovered = utils.rectButton(cursor, settings.lowerButton.startX, settings.lowerButton.startY, settings.lowerButton.w, settings.lowerButton.h)
    settings.lowerButton.cancel.isHovered = utils.rectButton(cursor, settings.lowerButton.startX + addPosLower, settings.lowerButton.startY, settings.lowerButton.w, settings.lowerButton.h)
    settings.lowerButton.apply.isHovered = not utils.isTablesEqual(settings.content.currentSettings, settings.content.previousSettings) and
        utils.rectButton(cursor, settings.lowerButton.startX + addPosLower*2, settings.lowerButton.startY, settings.lowerButton.w, settings.lowerButton.h) or false

    settings.upperButton.wallpaper.hoverRect = utils.rectButton(cursor, settings.innerBevel.startX, settings.upperButton.startY, 100, 35)
    settings.upperButton.general.hoverRect = utils.rectButton(cursor, settings.innerBevel.startX + 100, settings.upperButton.startY, 80, 35)
    settings.upperButton.permissions.hoverRect = utils.rectButton(cursor, settings.innerBevel.startX + 100 + 80, settings.upperButton.startY, 110, 35)
    settings.upperButton.about.hoverRect = utils.rectButton(cursor, settings.innerBevel.startX + 100 + 80 + 110, settings.upperButton.startY, 70, 35)

    settings.upperButton.wallpaper.height = ifSelectedSection("wallpaper", 41, 35)
    settings.upperButton.general.height = ifSelectedSection("general", 41, 35)
    settings.upperButton.permissions.height = ifSelectedSection("permissions", 41, 35)
    settings.upperButton.about.height = ifSelectedSection("about", 41, 35)

    -- Wallpaper section's buttons
    for i, _ in ipairs({"green", "blue", "gray"}) do
        local computer = {w = 250, h = 188, inW = 210, inH = 157}
        computer.x, computer.y = (settings.innerBevel.startX+settings.innerBevel.w)/2 - computer.w/2, settings.innerBevel.startY + 35
        settings.wallpaper.isHovered[i] = utils.rectButton(cursor, computer.x + computer.w/2 - 240/2 + 3, computer.y + computer.h + 10 + 9 + 45 + 3 + (i-1)*20, 240 - 6, 20)
    end

    -- General section's buttons
    local but = {w = 20, h = 30}
    local minX, maxX =  settings.innerBevel.startX + (settings.innerBevel.w/2 - 550/2), settings.innerBevel.startX + (settings.innerBevel.w/2 - 550/2) + 400 - but.w
    for _, section in ipairs({"volume", "brightness"}) do
        settings.general[section].isHovered = utils.rectButton(cursor, settings.general[section].buttonX, settings.general[section].buttonY, but.w, but.h)
        if settings.general[section].isClicked then
            local dx = mouseCursor.x - settings.general[section].dragStartX
            local newX = settings.general[section].buttonStartX + dx
            if newX < minX then newX = minX end
            if newX > maxX then newX = maxX end
            settings.general[section].buttonX = newX
            local percent = ((settings.general[section].buttonX - minX)/(maxX - minX)) * 99 + 1
            settings.content.currentSettings[section] = math.floor(percent + 0.5)
        end
    end
end

settings.firstClickedCheck = function()
    -- Lower buttons
    if settings.lowerButton.ok.isHovered then
        settings.lowerButton.ok.isClicked = true
    elseif settings.lowerButton.cancel.isHovered then
        settings.lowerButton.cancel.isClicked = true
    elseif settings.lowerButton.apply.isHovered then
        settings.lowerButton.apply.isClicked = true
    end

    -- Upper buttons
    if settings.upperButton.wallpaper.hoverRect then settings.content.selectedSection = "wallpaper"
    elseif settings.upperButton.general.hoverRect then settings.content.selectedSection = "general"
    elseif settings.upperButton.permissions.hoverRect then settings.content.selectedSection = "permissions"
    elseif settings.upperButton.about.hoverRect then settings.content.selectedSection = "about"
    end

    -- Wallpaper section's buttons
    for i, name in ipairs({"green", "blue", "gray"}) do
        if settings.wallpaper.isHovered[i] then
            settings.wallpaper.isClicked[i] = true
            settings.content.currentSettings.wallpaper = name
        else
            settings.wallpaper.isClicked[i] = false
        end
    end

    -- General section's buttons
    local cursor = require("src/cursor")
    for _, section in ipairs({"volume", "brightness"}) do
        if settings.general[section].isHovered then
            settings.general[section].isClicked = true
            settings.general[section].dragStartX = cursor.x
            settings.general[section].buttonStartX = settings.general[section].buttonX
        else
            settings.general[section].isClicked = false
        end
    end
end

settings.lastClickedCheck = function()
    local window = require("src/windows")

    if settings.lowerButton.ok.isClicked and settings.lowerButton.ok.isHovered then -- save and close settings
        settings.lowerButton.ok.isClicked = false
        settings.content.selectedSection = "wallpaper"
        settings.saveChangedSettings()
        window.closeWindow("settings")
    elseif settings.lowerButton.cancel.isClicked and settings.lowerButton.cancel.isHovered then -- cancel any changes and close settings
        settings.lowerButton.cancel.isClicked = false
        settings.content.selectedSection = "wallpaper"
        settings.content.currentSettings = utils.copyTable(settings.content.previousSettings)
        window.closeWindow("settings")
    elseif settings.lowerButton.apply.isClicked and settings.lowerButton.apply.isHovered then -- save but keep settings open
        settings.lowerButton.apply.isClicked = false
        settings.saveChangedSettings()
    end
    settings.lowerButton.ok.isClicked = false
    settings.lowerButton.cancel.isClicked = false
    settings.lowerButton.apply.isClicked = false

    -- General section's buttons
    for _, section in ipairs({"volume", "brightness"}) do
        settings.general[section].isClicked = false
        settings.general[section].dragStartX = 0
        settings.general[section].buttonStartX = 0
    end
end

return settings