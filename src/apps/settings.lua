local const = require("src/const")
local utils = require("src/utils")

local settings = {
    content = {
        width = 0, height = 0,
        previousSettings = nil, -- to store previous settings before applying changes
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
end

settings.lastClickedCheck = function()
    local window = require("src/windows")

    if settings.lowerButton.ok.isClicked and settings.lowerButton.ok.isHovered then -- save and close settings
        settings.lowerButton.ok.isClicked = false
    elseif settings.lowerButton.cancel.isClicked and settings.lowerButton.cancel.isHovered then -- cancel any changes and close settings
        settings.lowerButton.cancel.isClicked = false
        window.closeWindow("settings")
    elseif settings.lowerButton.apply.isClicked and settings.lowerButton.apply.isHovered then -- save but keep settings open
        settings.lowerButton.apply.isClicked = false
    end

    settings.lowerButton.ok.isClicked = false
    settings.lowerButton.cancel.isClicked = false
    settings.lowerButton.apply.isClicked = false
end

return settings