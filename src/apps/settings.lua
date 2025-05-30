local const = require("src/const")
local utils = require("src/utils")
local state = require("src/state")

local settings = {
    content = {
        width = 0, height = 0,
        previousSettings = state.settings, -- to store previous settings before applying changes
        currentSettings = state.settings, -- to store current settings
        selectedSection = "wallpaper",
    },
    font = {
        header = love.graphics.newFont(const.font.WIN95, 18),
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
        selectedColor = state.settings.wallpaper,
        isHovered = {false, false, false}, -- green, blue, gray
        isClicked = {false, false, false}, -- green, blue, gray
        colors = {
            green = {const.color.DEEP_TEAL, "Green"},
            blue  = {const.color.WALLPAPER_BLUE, "Blue"},
            gray  = {const.color.TROLLEY_GREY, "Gray"},
        },
    },
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
end

settings.saveChangedSettings = function()
    state.settings = settings.content.currentSettings
end

settings.drawWallpaperSection = function()
    local x, y = settings.innerBevel.startX, settings.innerBevel.startY
    local computer = {w = 250, h = 188, inW = 210, inH = 157}
    computer.x, computer.y = (x+settings.innerBevel.w)/2 - computer.w/2, y + 35
    local wallpaper = settings.content.previousSettings.wallpaper

    -- computer drawings
    utils.bevelRect(computer.x+computer.w/2 - 100/2, computer.y + computer.h - 3, 100, 13, 3, const.color.SILVER_TASKBAR, const.color.SILVER_BEVEL, const.color.WHITE, {0, 1, 1, 1})
    utils.bevelRect(computer.x, computer.y, computer.w, computer.h, 4, const.color.SILVER_TASKBAR, const.color.SILVER_BEVEL, const.color.WHITE)
    utils.bevelRect(computer.x + (computer.w-computer.inW)/2, computer.y + (computer.h-computer.inH)/2, computer.inW, computer.inH, 3,
        settings.wallpaper.colors[settings.wallpaper.selectedColor][1], const.color.WHITE, const.color.SILVER_BEVEL)
    utils.bevelRect(computer.x+computer.w/2 - 200/2, computer.y + computer.h + 10, 200, 9, 2, const.color.SILVER_TASKBAR, const.color.SILVER_BEVEL, const.color.WHITE)
    -- below computer
    utils.bevelRect(computer.x + computer.w/2 - 260/2, computer.y + computer.h + 10 + 9 + 30, 260, 180, 1, const.color.SILVER_TASKBAR, const.color.SILVER_BEVEL, const.color.SILVER_BEVEL) -- outer outline
    utils.bevelRect(computer.x + computer.w/2 - 240/2, computer.y + computer.h + 10 + 9 + 45, 240, 100, 3, utils.setRGB(246, 244, 241), utils.setRGB(170, 170, 170), const.color.SILVER_BEVEL) -- inner menu
    love.graphics.setColor(const.color.BLACK)
    love.graphics.setFont(settings.font.header)
    utils.printCenterText("Wallpaper", computer.x + computer.w/2 - 83, computer.y + computer.h + 10 + 9 + 30, true, const.color.SILVER_TASKBAR, {1, 1})
    for i, name in ipairs({"green", "blue", "gray"}) do
        local color = settings.wallpaper.colors[name]
        if settings.wallpaper.selectedColor == name then
            love.graphics.setColor(const.color.NAVY_BLUE)
            love.graphics.rectangle("fill", computer.x + computer.w/2 - 240/2 + 3, computer.y + computer.h + 10 + 9 + 45 + 3 + (i-1)*20, 240 - 6, 20)
        end
        love.graphics.setColor(settings.wallpaper.selectedColor == name and const.color.WHITE or const.color.BLACK)
        love.graphics.print(color[2], computer.x + computer.w/2 - 240/2 + 5, computer.y + computer.h + 10 + 9 + 45 + 5 + (i-1)*20)
    end
end

settings.draw = function()
    -- inner rectangle
    utils.bevelRect(settings.innerBevel.startX, settings.innerBevel.startY, settings.innerBevel.w, settings.innerBevel.h,
        3, const.color.SILVER_TASKBAR, const.color.SILVER_BEVEL, const.color.WHITE)
    -- upper buttons
    local upperBArgs = {3, const.color.SILVER_TASKBAR, const.color.SILVER_BEVEL, const.color.WHITE, {1, 1, 0, 1}}
    love.graphics.setFont(settings.font.header)
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
    utils.printCenterText("Apply", settings.lowerButton.startX + settings.lowerButton.w/2*5 + settings.lowerButton.gapX*2, settings.lowerButton.startY + 17.5, false, const.color.BLACK)
    -- current selected section
    if settings.content.selectedSection == "wallpaper" then
        settings.drawWallpaperSection()
    elseif settings.content.selectedSection == "general" then
        -- settings.drawGeneralSection()
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
    settings.lowerButton.apply.isHovered = utils.rectButton(cursor, settings.lowerButton.startX + addPosLower*2, settings.lowerButton.startY, settings.lowerButton.w, settings.lowerButton.h)

    settings.upperButton.wallpaper.hoverRect = utils.rectButton(cursor, settings.innerBevel.startX, settings.upperButton.startY, 100, 35)
    settings.upperButton.general.hoverRect = utils.rectButton(cursor, settings.innerBevel.startX + 100, settings.upperButton.startY, 80, 35)
    settings.upperButton.permissions.hoverRect = utils.rectButton(cursor, settings.innerBevel.startX + 100 + 80, settings.upperButton.startY, 110, 35)
    settings.upperButton.about.hoverRect = utils.rectButton(cursor, settings.innerBevel.startX + 100 + 80 + 110, settings.upperButton.startY, 70, 35)

    settings.upperButton.wallpaper.height = ifSelectedSection("wallpaper", 41, 35)
    settings.upperButton.general.height = ifSelectedSection("general", 41, 35)
    settings.upperButton.permissions.height = ifSelectedSection("permissions", 41, 35)
    settings.upperButton.about.height = ifSelectedSection("about", 41, 35)

    for i, _ in ipairs({"green", "blue", "gray"}) do
        local computer = {w = 250, h = 188, inW = 210, inH = 157}
        computer.x, computer.y = (settings.innerBevel.startX+settings.innerBevel.w)/2 - computer.w/2, settings.innerBevel.startY + 35
        settings.wallpaper.isHovered[i] = utils.rectButton(cursor, computer.x + computer.w/2 - 240/2 + 3, computer.y + computer.h + 10 + 9 + 45 + 3 + (i-1)*20, 240 - 6, 20)
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
            settings.wallpaper.selectedColor = name
        else
            settings.wallpaper.isClicked[i] = false
        end
    end
end

settings.lastClickedCheck = function()
    local window = require("src/windows")

    if settings.lowerButton.ok.isClicked and settings.lowerButton.ok.isHovered then -- save and close settings
        settings.lowerButton.ok.isClicked = false
        settings.content.selectedSection = "wallpaper"
        window.closeWindow("settings")
    elseif settings.lowerButton.cancel.isClicked and settings.lowerButton.cancel.isHovered then -- cancel any changes and close settings
        settings.lowerButton.cancel.isClicked = false
        settings.content.selectedSection = "wallpaper"
        window.closeWindow("settings")
    elseif settings.lowerButton.apply.isClicked and settings.lowerButton.apply.isHovered then -- save but keep settings open
        settings.lowerButton.apply.isClicked = false
    end

    settings.lowerButton.ok.isClicked = false
    settings.lowerButton.cancel.isClicked = false
    settings.lowerButton.apply.isClicked = false
end

return settings