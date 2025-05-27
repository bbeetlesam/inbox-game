local const = require("src/const")
local utils = require("src/utils")

local mail = {
    font = {
        header = love.graphics.newFont(const.font.WIN95, 18),
    },
    content = {},
    innerBevel = {},
    lowerButton = {},
    upperButton = {},
}

mail.load = function(contentSizes)
    mail.content = {width = contentSizes[1], height = contentSizes[2]}
    mail.innerBevel = {w = 575, h = 500}
    mail.innerBevel.startX = mail.content.width/2 - mail.innerBevel.w/2
    mail.innerBevel.startY = mail.content.height/2 - mail.innerBevel.h/2
    mail.lowerButton = {w = 95, h = 35, gapX = 7}
    mail.lowerButton.startX = mail.innerBevel.w - (mail.lowerButton.w*3 + mail.lowerButton.gapX*2) + 10
    mail.lowerButton.startY = mail.content.height/2 - mail.innerBevel.h/2 + mail.innerBevel.h + 2.5 + 5
    mail.upperButton.startY = mail.innerBevel.startY - 35 + 3
end

mail.draw = function()
    -- inner rectangle
    utils.bevelRect(mail.innerBevel.startX, mail.innerBevel.startY, mail.innerBevel.w, mail.innerBevel.h, 3, const.color.SILVER_TASKBAR, const.color.BLACK, const.color.WHITE)
    -- upper buttons
    love.graphics.setFont(mail.font.header)
    utils.bevelRect(mail.innerBevel.startX, mail.upperButton.startY, 100, 35, 3, const.color.SILVER_TASKBAR, const.color.BLACK, const.color.WHITE, {1, 1, 0, 1})
    utils.bevelRect(mail.innerBevel.startX + 100, mail.upperButton.startY, 80, 35, 3, const.color.SILVER_TASKBAR, const.color.BLACK, const.color.WHITE, {1, 1, 0, 1})
    utils.bevelRect(mail.innerBevel.startX + 100 + 80, mail.upperButton.startY, 110, 35, 3, const.color.SILVER_TASKBAR, const.color.BLACK, const.color.WHITE, {1, 1, 0, 1})
    utils.bevelRect(mail.innerBevel.startX + 100 + 80 + 110, mail.upperButton.startY, 70, 35, 3, const.color.SILVER_TASKBAR, const.color.BLACK, const.color.WHITE, {1, 1, 0, 1})
    love.graphics.setColor(const.color.BLACK)
    love.graphics.print("Wallpaper", mail.innerBevel.startX + 10, mail.upperButton.startY + 10)
    love.graphics.print("General", mail.innerBevel.startX + 10 + 100, mail.upperButton.startY + 10)
    love.graphics.print("Permissions", mail.innerBevel.startX + 10 + 100 + 80, mail.upperButton.startY + 10)
    love.graphics.print("About", mail.innerBevel.startX + 10 + 100 + 80 + 110, mail.upperButton.startY + 10)
    -- 3 lower buttons
    utils.bevelRect(mail.lowerButton.startX, mail.lowerButton.startY, mail.lowerButton.w, mail.lowerButton.h, 3, const.color.SILVER_TASKBAR, const.color.BLACK, const.color.WHITE)
    utils.bevelRect(mail.lowerButton.startX + (mail.lowerButton.w+mail.lowerButton.gapX), mail.lowerButton.startY, mail.lowerButton.w, mail.lowerButton.h, 3, const.color.SILVER_TASKBAR, const.color.BLACK, const.color.WHITE)
    utils.bevelRect(mail.lowerButton.startX + (mail.lowerButton.w+mail.lowerButton.gapX)*2, mail.lowerButton.startY, mail.lowerButton.w, mail.lowerButton.h, 3, const.color.SILVER_TASKBAR, const.color.BLACK, const.color.WHITE)
    love.graphics.setColor(const.color.BLACK)
    utils.printCenterText("OK", mail.lowerButton.startX + mail.lowerButton.w/2, mail.lowerButton.startY + 17.5, false, const.color.BLACK)
    utils.printCenterText("Cancel", mail.lowerButton.startX + mail.lowerButton.w/2*3 + mail.lowerButton.gapX, mail.lowerButton.startY + 17.5, false, const.color.BLACK)
    utils.printCenterText("Apply", mail.lowerButton.startX + mail.lowerButton.w/2*5 + mail.lowerButton.gapX*2, mail.lowerButton.startY + 17.5, false, const.color.BLACK)
end

mail.update = function(cursor)
end

return mail