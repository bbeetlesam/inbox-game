local const = require("src/const")
local utils = require("src/utils")
local folders = require("src/apps/fileFolders")

local file = {
    content = {
        width = 0, height = 0,
    },
    font = {
        header = love.graphics.newFont(const.font.WIN95, 20),
    }
}

local function traverseFolders(folder, callback, depth, ...)
    depth = depth or 0
    for name, content in pairs(folder) do
        callback(name, content, depth, ...)
        if type(content) == "table" then
            traverseFolders(content, callback, depth + 1, ...)
        end
    end
end

file.load = function(contentSizes)
    file.content.width, file.content.height = contentSizes[1], contentSizes[2]
end

file.update = function()
end

file.draw = function()
    local x, y = 5, 0

    love.graphics.setColor(const.color.BLACK)
    love.graphics.setFont(file.font.header)
    love.graphics.print("File", x, y + 8)
    love.graphics.print("Edit", x + 40, y + 8)
    love.graphics.print("View", x + 80, y + 8)
    love.graphics.print("Tools", x + 130, y + 8)
    love.graphics.print("Help", x + 183, y + 8)
    utils.drawSectionDivider("horizontal", x - 1, y + 35, file.content.width - 6, 2)

    utils.bevelRect(x, y + 35 + 8, file.content.width - 5, 38, 3, utils.setRGB(246, 244, 241), utils.setRGB(170, 170, 170), const.color.SILVER_BEVEL) -- upper panel
    utils.bevelRect(x, y + 35 + 5 + 38 + 5, 270, file.content.height - 88, 3, utils.setRGB(246, 244, 241), utils.setRGB(170, 170, 170), const.color.SILVER_BEVEL) -- left panel
    utils.bevelRect(x + 270 + 3, y + 35 + 5 + 38 + 5, file.content.width - 270 - 9, file.content.height - 88, 3, utils.setRGB(246, 244, 241), utils.setRGB(170, 170, 170), const.color.SILVER_BEVEL) -- right panel

    local startX, startY = x + 5, y + 500
    local lineHeight = 22
    local currentY = startY

    -- Drawing callback for traverseFolders
    local function drawCallback(name, content, depth)
        local displayName = (type(content) == "table" and "[>] " or "- ") .. name
        love.graphics.setColor(const.color.BLACK)
        love.graphics.print(displayName, startX + 15*depth, currentY)
        currentY = currentY + lineHeight
    end
    traverseFolders(folders, drawCallback)
end

return file