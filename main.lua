-- Main entry of the game (LÖVE default)
local utils = require("src/utils")
local const = require("src/const")
local state = require("src/state")
local shaders = require("src/shaders/shaders")
local cursor = require("src/cursor")
local taskbar = require("src/taskbar")
local apps = require("src/apps")
local windows = require("src/windows")

local mainCanvas = love.graphics.newCanvas(const.game.screen.WIDTH, const.game.screen.HEIGHT)
local mainCanvas2 = love.graphics.newCanvas(const.game.screen.WIDTH, const.game.screen.HEIGHT)

-- Load the game. Called once at the beginning of the game
function love.load()
    love.window.setFullscreen(true)
    love.mouse.setVisible(false)
    Game = {utils.core.setGameScreen(const.game.screen.WIDTH, const.game.screen.HEIGHT)}

    shaders.init()
end

-- Update the game. Called every frame
function love.update(dt)
    state.update()
    shaders.update()
    cursor.update()
    apps.update(cursor)
end

-- Draw the game. Called every frame
function love.draw()
    love.graphics.setCanvas(mainCanvas)
        love.graphics.clear()
        love.graphics.setShader(shaders.grainyNoise)

        utils.core.setBaseBgColor(const.color.DEEP_TEAL)

        taskbar.drawTaskbar()
        apps.draw()
        windows.draw()
        cursor.draw()

        love.graphics.setColor(1, 1, 1)
        love.graphics.setShader()
    love.graphics.setCanvas()

    love.graphics.setCanvas(mainCanvas2)
        love.graphics.clear()
        love.graphics.setShader(shaders.barrelDistortion)

        love.graphics.draw(mainCanvas)

        love.graphics.setShader()
    love.graphics.setCanvas()

    love.graphics.push()
    love.graphics.translate(Game[1], Game[2])
    love.graphics.scale(Game[3], Game[4])

    love.graphics.draw(mainCanvas2)

    love.graphics.pop()
end

function love.keyreleased(key, _, _)
    if key == "escape" then
        love.event.quit()
    elseif key == "f11" then
        utils.core.toggleFullscreen()
    end
end

function love.mousepressed(_, _, button, _, presses)
    if button == 1 then
        apps.mousepressed(cursor)
        windows.cursorClickCheck(cursor)

        if presses == 2 and apps.selectedApp.id ~= nil then
            taskbar.addItem({apps.selectedApp.id, apps.selectedApp.icon})
            windows.addItem({apps.selectedApp.id, apps.selectedApp.icon})
        end
    end
end

function love.resize()
    Game = {utils.core.setGameScreen(const.game.screen.WIDTH, const.game.screen.HEIGHT)}
end

function love.quit()
    return false
end