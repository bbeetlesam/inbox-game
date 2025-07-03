-- Main entry of the game (LÖVE default)
local utils = require("src/utils")
local const = require("src/const")
local state = require("src/state")
local shaders = require("src/shaders/shaders")
local cursor = require("src/cursor")
local taskbar = require("src/taskbar")
local apps = require("src/apps")
local windows = require("src/windows")
local appsManager = require("src/apps/appsManager")
local sceneManager = require("src/scenes/sceneManager")

-- Load the game. Called once at the beginning of the game
function love.load()
    love.window.setFullscreen(true)
    love.mouse.setVisible(false)
    Game = {utils.core.setGameScreen(const.game.screen.WIDTH, const.game.screen.HEIGHT)}

    shaders.init()
    appsManager.init()
    sceneManager.setScene("none")
end

-- Update the game. Called every frame
function love.update(dt)
    state.update()
    shaders.update()
    sceneManager.update(dt)
    if not state.game.isStartingUp then
        cursor.update()
        apps.update(cursor)
        taskbar.update(cursor)
        windows.update(cursor)
    end
end

-- Draw the game. Called every frame
function love.draw()
    local wallpaperColor =
        state.settings.wallpaper == "green" and const.color.DEEP_TEAL or
        state.settings.wallpaper == "gray" and const.color.TROLLEY_GREY or
        state.settings.wallpaper == "blue" and const.color.WALLPAPER_BLUE

    shaders.drawAppliedShader(function()
        love.graphics.push()
        love.graphics.translate(Game[1], Game[2])
        love.graphics.scale(Game[3], Game[4])

        love.graphics.setScissor(Game[1], Game[2], const.game.screen.WIDTH * Game[3], const.game.screen.HEIGHT * Game[4])

        utils.core.setBaseBgColor(wallpaperColor)
        apps.draw()
        windows.draw()
        taskbar.draw()
        cursor.draw()

        sceneManager.draw()

        love.graphics.setScissor()

        love.graphics.pop()
    end,
    {shaders.grainyNoise, shaders.barrelDistortion, shaders.adjustBrightness}, {love.graphics.getWidth(), love.graphics.getHeight()})
end

function love.mousepressed(_, _, button, _, presses)
    if button == 1 then
        apps.mousepressed(cursor)
        windows.clickedCheck(cursor)
        taskbar.iconClicked()

        local item = windows.items[#windows.items]
        if item then
            -- If close button is pressed
            if item.hover.closeButton then
                item.isClicked.closeButton = true
            end

            -- If minimize button is pressed
            if item.hover.minimButton then
                item.isClicked.minimButton = true
            end
        end

        -- If clicking two times on app's shortcut
        if presses == 2 and apps.selectedApp.id ~= nil and windows.clicked == false then
            taskbar.addItem({apps.selectedApp.id, apps.selectedApp.icon})
            windows.addItem({apps.selectedApp.id, apps.selectedApp.icon})
            taskbar.focusItem(apps.selectedApp.id, true)
        end

        if presses == 2 then
            -- If clicking twice on an window (in general)
            windows.doubleClickedCheck(cursor)
        end
    end
end

function love.mousereleased(_, _, button, _, _)
    if button == 1 then
        -- Windows stufs
        local item = windows.items[#windows.items]
        if item then
            item.isClicked.closeButton = false
            item.isClicked.minimButton = false

            -- If close button is clicked
            if item.hover.closeButton then
                windows.closeWindow(item.id)
            end

            -- If minimize button is clicked
            if item.hover.minimButton then
                windows.minimizeWindow(item.id)
            end
        end

        -- Apps' content on released clicking
        if item then
            appsManager.lastClickedCheck(item.id)
        end
    end
end

function love.keyreleased(key, _, _)
    if key == "escape" then
        love.event.quit()
    elseif key == "f11" then
        utils.core.toggleFullscreen()
    end
end

function love.resize()
    shaders.CanvasPool.clear()
    Game = {utils.core.setGameScreen(const.game.screen.WIDTH, const.game.screen.HEIGHT)}
end

function love.quit()
    shaders.CanvasPool.clear()
    return false
end