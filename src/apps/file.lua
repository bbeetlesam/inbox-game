local const = require("src/const")
local utils = require("src/utils")
local folders = require("src/apps/fileFolders")

local file = {
    content = {
        width = 0, height = 0,
    },
    font = {
        header = love.graphics.newFont(const.font.WIN95, 20),
        body = love.graphics.newFont(const.font.WIN95, 20),
        txt = love.graphics.newFont(const.font.WIN95, 18),
    },
    imageSize = 16 * 1.3,
    image = {
        computer = love.graphics.newImage("assets/img/computer_explorer-0.png"),
        desktop = love.graphics.newImage("assets/img/desktop-3.png"),
        folder = love.graphics.newImage("assets/img/directory_closed-2.png"),
        txt = love.graphics.newImage("assets/img/file_lines-0.png"),
        docViewer = love.graphics.newImage("assets/img/notepad-4.png")
    },
    expandFolderButtons = {},
    nameFolderButtons = {},
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

local function countVisibleChildren(folder)
    if not folder.expanded then
        return 0
    end
    local count = 0
    if folder.children then
        for _, entry in ipairs(folder.children) do
            count = count + 1
            if entry.type == "folder" then
                count = count + countVisibleChildren(entry)
            end
        end
    end
    return count
end

-- used to find selected == true content to be shown in right panel
local function findSelectedEntry(folder)
    for _, entry in ipairs(folder) do
        if entry.selected then
            return entry
        end
        if entry.type == "folder" and entry.children then
            local found = findSelectedEntry(entry.children)
            if found then return found end
        end
    end
    return nil
end

-- clear all folders to selected = false (tho there's only one selected one at a time)
local function clearAllSelected(folder)
    for _, entry in ipairs(folder) do
        entry.selected = false
        if entry.type == "folder" and entry.children then
            clearAllSelected(entry.children)
        end
    end
end

-- get the string format of selected's path (starting from root\)
local function findSelectedPath(folder, pathSoFar)
    pathSoFar = pathSoFar or {}
    for _, entry in ipairs(folder) do
        table.insert(pathSoFar, entry.name)
        if entry.selected then
            return table.concat(pathSoFar, "\\")
        end
        if entry.type == "folder" and entry.children then
            local found = findSelectedPath(entry.children, pathSoFar)
            if found then return found end
        end
        table.remove(pathSoFar) -- backtrack
    end
    return nil
end

-- count chldren amount of an entry (if a non-folder is selected, it'll returns 1)
local function countAllChildren(entry)
    if entry.type == "folder" and entry.children then
        local count = 0
        for _, child in ipairs(entry.children) do
            count = count + 1 -- count the child itself
            if child.type == "folder" and child.children then
                count = count + countAllChildren(child)
            end
        end
        return count
    else
        return 1
    end
end

-- count accumulated size (non-folder file) of an entry (including its children and descendants)
local function accumulatedSize(entry)
    if entry.type == "folder" and entry.children then
        local total = 0
        for _, child in ipairs(entry.children) do
            total = total + accumulatedSize(child)
        end
        return total
    else
        return entry.size or 0
    end
end

file.load = function(contentSizes)
    file.content.width, file.content.height = contentSizes[1], contentSizes[2]
end

file.draw = function()
    file.expandFolderButtons = {}
    file.nameFolderButtons = {}
    local x, y = 5, 0

    love.graphics.setColor(const.color.BLACK)
    love.graphics.setFont(file.font.header)
    love.graphics.print("File", x, y + 8)
    love.graphics.print("Edit", x + 40, y + 8)
    love.graphics.print("View", x + 80, y + 8)
    love.graphics.print("Tools", x + 130, y + 8)
    love.graphics.print("Help", x + 183, y + 8)
    utils.drawSectionDivider("horizontal", x - 1, y + 35, file.content.width - 6, 2)

    utils.bevelRect(x + 70, y + 35 + 8, file.content.width - 5 - 70, 35, 3, utils.setRGB(246, 244, 241), utils.setRGB(170, 170, 170), const.color.SILVER_BEVEL) -- upper panel
    utils.bevelRect(x, y + 35 + 5 + 38 + 2, 270, file.content.height - 85 - 37, 3, utils.setRGB(246, 244, 241), utils.setRGB(170, 170, 170), const.color.SILVER_BEVEL) -- left panel
    utils.bevelRect(x + 270 + 3, y + 35 + 5 + 38 + 2, file.content.width - 270 - 9, file.content.height - 85 - 37, 3, utils.setRGB(246, 244, 241), utils.setRGB(170, 170, 170), const.color.SILVER_BEVEL) -- right panel
    utils.bevelRect(x, y + 35 + 5 + 38 + 2 + file.content.height - 85 - 35, 200, 35, 3, const.color.SILVER_TASKBAR, const.color.WHITE, const.color.SILVER_BEVEL) -- lower left panel
    utils.bevelRect(x + 203, y + 35 + 5 + 38 + 2 + file.content.height - 85 - 35, file.content.width - 208, 35, 3, const.color.SILVER_TASKBAR, const.color.WHITE, const.color.SILVER_BEVEL) -- lower right panel

    love.graphics.setColor(const.color.BLACK)
    love.graphics.print("Address", x, y + 35 + 8 + 7)

    -- left panel elements
    local startX, startY = x + 6 + 28, y + 35 + 5 + 38 + 5 + 27
    local heightGap = 22
    local currentY = startY

    love.graphics.setColor(const.color.WHITE)
    utils.drawImage(file.image.desktop, x + 6, y + 35 + 5 + 38 + 5 + 2, file.imageSize)
    love.graphics.setFont(file.font.body)
    love.graphics.setColor(const.color.BLACK)
    love.graphics.print("Desktop", x + 6 + 28, y + 35 + 5 + 38 + 5 + 5 + 1)
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
        local brdColor = entry.selected and const.color.NAVY_BLUE or nil
        local nameColor = entry.selected and const.color.WHITE or const.color.BLACK
        love.graphics.setColor(nameColor)
        local brdX, brdY, brdW, brdH = utils.printBorderText(entry.name, iconX + file.imageSize + 5, currentY, brdColor, {1, 0}, false)

        table.insert(file.nameFolderButtons, {
            x = brdX,
            y = brdY,
            w = brdW,
            h = brdH,
            entry = entry
        })

        -- Draw an expand/collapse indicator for folders
        if entry.type == "folder" then
            local indicator = entry.expanded and "-" or "+"
            local btnX, btnY, btnW, btnH = iconX - 25, currentY - 1, 15, 15

            utils.dashedLine(iconX - 19, currentY + 8, iconX - 19 + 20, currentY + 8, 3, 3, 1, utils.setRGB(145, 145, 145))
            -- utils.dashedLine(iconX - 19, currentY + 8, iconX - 19, currentY + 8 + heightGap*(countVisibleChildren(folders[1])) + 1, 3, 3, 1, utils.setRGB(145, 145, 145))
            utils.bevelRect(btnX, btnY, btnW, btnH, 2, utils.setRGB(246, 244, 241), utils.setRGB(145, 145, 145), utils.setRGB(145, 145, 145))
            love.graphics.setColor(const.color.BLACK)
            love.graphics.print(indicator, iconX - 22, currentY - 5)

            table.insert(file.expandFolderButtons, {
                x = btnX,
                y = btnY,
                w = btnW,
                h = btnH,
                entry = entry
            })
        end

        currentY = currentY + heightGap
    end
    traverseFolders(folders, drawCallback)

    -- right panel
    local xr, yr, wr = x + 270 + 3 + 6, y + 35 + 5 + 38 + 2 + 6, file.content.width - 270 - 9 - 12
    local selectedContent = findSelectedEntry(folders)

    if selectedContent then
        -- if selected is a file-text
        if selectedContent.type == "file-text" then
            utils.bevelRect(xr - 5, yr - 5, wr + 9, 21 + 7, 2, const.color.SILVER_TASKBAR, const.color.SILVER_BEVEL, const.color.SILVER_BEVEL)

            utils.drawImage(file.image.docViewer, xr - 1, yr - 2, file.imageSize)
            love.graphics.setColor(const.color.BLACK)
            love.graphics.print("Document Viewer", xr + 25, yr)

            love.graphics.setColor(const.color.BLACK)
            love.graphics.setFont(file.font.txt)
            love.graphics.printf(selectedContent.content, xr - 1, yr + 26, wr, "left")
            love.graphics.setFont(file.font.body)

        -- if selected is a folder
        elseif selectedContent.type == "folder" then
            utils.bevelRect(xr - 5, yr - 5, wr + 9, 21 + 7, 2, const.color.SILVER_TASKBAR, const.color.SILVER_BEVEL, const.color.SILVER_BEVEL)
            utils.bevelRect(xr - 5 + 300, yr - 5, wr + 9 - 300, 21 + 7, 2, const.color.SILVER_TASKBAR, const.color.SILVER_BEVEL, const.color.SILVER_BEVEL)

            love.graphics.setColor(const.color.BLACK)
            love.graphics.print("Name", xr, yr)
            love.graphics.printf("Size", xr - 5 + 300, yr, wr + 9 - 300 - 5, "right")

            local childY = yr + 26
            if selectedContent.children and #selectedContent.children > 0 then
                for _, child in ipairs(selectedContent.children) do
                    local icon = (child.type == "folder" and file.image.folder)
                            or (child.type == "file-text" and file.image.txt)
                            or (child.type == "computer" and file.image.computer)
                            or file.image.txt
                    utils.drawImage(icon, xr, childY, file.imageSize)
                    love.graphics.setColor(const.color.BLACK)
                    love.graphics.print(child.name, xr + file.imageSize + 4, childY + 2)
                    love.graphics.printf(accumulatedSize(child) .. "KB", xr, childY + 2, wr, "right")
                    childY = childY + file.imageSize + 2
                end
            else
                love.graphics.print("[empty folder]", xr, childY)
            end
        end
    else

    end

    -- upper panel
    local xu, yu = x + 70, y + 35 + 8
    local selectedPath = "root\\" .. (selectedContent and findSelectedPath(folders) or "")

    love.graphics.print(selectedPath, xu + 8, yu + 8)

    -- lower left panel
    local xll, yll = x, y + 35 + 5 + 38 + 2 + file.content.height - 85 - 35
    local childrenAmount = (selectedContent and countAllChildren(selectedContent) or "0") .. " object(s)"

    love.graphics.print(childrenAmount, xll + 8, yll + 8)
end

file.update = function(mouseCursor, offsets)
end

file.firstClickedCheck = function(mouseCursor, offsets)
    local cursor = {x = mouseCursor.x  - offsets[1], y = mouseCursor.y - offsets[2]}

    -- check if folder expand's buttons is clicked
    for _, btn in ipairs(file.expandFolderButtons) do
        if utils.rectButton(cursor, btn.x, btn.y, btn.w, btn.h) then
            btn.entry.expanded = not btn.entry.expanded
            clearAllSelected(folders)
        end
    end

    -- check if folder/file's label is clicked
    for _, brd in ipairs(file.nameFolderButtons) do
        if utils.rectButton(cursor, brd.x, brd.y, brd.w, brd.h) then
            for _, other in ipairs(file.nameFolderButtons) do
                other.entry.selected = false
            end

            brd.entry.selected = true
            break
        end
    end
end

file.doubleFirstClickedCheck = function(mouseCursor, offsets)
    local cursor = {x = mouseCursor.x  - offsets[1], y = mouseCursor.y - offsets[2]}

    -- check if folder's label is clicked twice (open the folder/file's content to right panel)
    for _, brd in ipairs(file.nameFolderButtons) do
        if utils.rectButton(cursor, brd.x, brd.y, brd.w, brd.h) then
            if brd.entry.type == "folder" then
                brd.entry.expanded = not brd.entry.expanded
            else
                if brd.entry.type == "file-image" then
                elseif brd.entry.type == "file-video" then
                end
            end
        end
    end
end

return file