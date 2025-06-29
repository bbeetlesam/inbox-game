local const = require("src/const")
local utils = require("src/utils")
local folders = require("src/apps/fileFolders")

local file = {
    content = { 
        width = 0, height = 0,
    },
    font = {
        header = love.graphics.newFont(const.font.WIN95, 20),
        body = love.graphics.newFont(const.font.WIN95, 18),
    },
    imageSize = 16 * 1.3,
    image = {
        computer = love.graphics.newImage("assets/img/computer_explorer-0.png"),
        desktop = love.graphics.newImage("assets/img/desktop-3.png"),
        folder = love.graphics.newImage("assets/img/directory_closed-2.png"),
        txt = love.graphics.newImage("assets/img/notepad_file-2.png"),
    },
}

local function traverseFolders(folder, callback, depth)
    depth = depth or 0
    for _, entry in ipairs(folder) do
        callback(entry, depth)
        if entry.type == "folder" and entry.expanded and entry.children then
            traverseFolders(entry.children, callback, depth + 1)
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

    -- left panel elements
    local startX, startY = x + 6 + 28, y + 35 + 5 + 38 + 5 + 30
    local lineHeight = 22
    local currentY = startY

    love.graphics.setColor(const.color.WHITE)
    utils.drawImage(file.image.desktop, x + 6, y + 35 + 5 + 38 + 5 + 5, file.imageSize)
    love.graphics.setFont(file.font.body)
    love.graphics.setColor(const.color.BLACK)
    love.graphics.print("Desktop", x + 6 + 28, y + 35 + 5 + 38 + 5 + 5 + 4)
    utils.dashedLine(x + 16, y + 35 + 5 + 38 + 5 + 5 + 28 - 4, x + 16, y + 35 + 5 + 38 + 5 + 5 + 28 - 4 + 100, 3, 3, 1, utils.setRGB(145, 145, 145))
    -- callback for traverse folders
    local function drawCallback(entry, depth)
        local typeImage = (entry.type == "folder" and file.image.folder) or
                          (entry.type == "file-text" and file.image.txt) or
                          (entry.type == "computer" and file.image.computer) or file.image.txt
        local iconX = startX + (file.imageSize + 6) * depth
        local iconY = currentY - 2

        -- Draw folder/file icon
        utils.drawImage(typeImage, iconX, iconY, file.imageSize)

        -- Draw folder/file name
        love.graphics.setColor(const.color.BLACK)
        love.graphics.print(entry.name, iconX + file.imageSize + 5, currentY)

        -- Draw an expand/collapse indicator for folders
        if entry.type == "folder" then
            local indicator = entry.expanded and "-" or "+"
            utils.dashedLine(iconX - 19, currentY + 7, iconX - 19 + 20, currentY + 7, 3, 3, 1, utils.setRGB(145, 145, 145))
            love.graphics.setColor({0.2, 0.2, 0.2})
            utils.bevelRect(iconX - 25, currentY - 1, 15, 15, 2, utils.setRGB(246, 244, 241), utils.setRGB(145, 145, 145), utils.setRGB(145, 145, 145))
            love.graphics.setColor(const.color.BLACK)
            love.graphics.print(indicator, iconX - 22, currentY - 4)
        end

        currentY = currentY + lineHeight
    end
    traverseFolders(folders, drawCallback)

    -- right panel
end

return file