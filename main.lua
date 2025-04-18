-- Main entry of the game (LÖVE default)
local utils = require("src/utils")
local const = require("src/const")
local shaders = require("src/shaders/shaders")

local canvas = love.graphics.newCanvas(const.game.screen.WIDTH, const.game.screen.HEIGHT)

-- Load the game. Called once at the beginning of the game
function love.load()
    love.window.setFullscreen(true)
    Game = {utils.core.setGameScreen(const.game.screen.WIDTH, const.game.screen.HEIGHT)}

    shaders.barrelDistortion:send("strength", 0.05)
end

-- Update the game. Called every frame
function love.update(dt)

end

-- Draw the game. Called every frame
function love.draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()

    utils.core.setBaseBgColor(const.color.DEEP_TEAL)
    love.graphics.setColor(const.color.SILVER_TASKBAR)
    love.graphics.rectangle("fill", 0,const.game.screen.HEIGHT-60, const.game.screen.WIDTH,60)
    love.graphics.rectangle("fill", 0,0, 100,100)

    love.graphics.setCanvas()

    love.graphics.push()
    love.graphics.translate(Game[1], Game[2])
    love.graphics.scale(Game[3], Game[4])

    love.graphics.setShader(shaders.barrelDistortion)
    love.graphics.draw(canvas, 0, 0)
    love.graphics.setShader()

    love.graphics.pop()
end

function love.keyreleased(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    elseif key == "f11" then
        utils.core.toggleFullscreen()
    end
end

function love.resize()
    Game = {utils.core.setGameScreen(const.game.screen.WIDTH, const.game.screen.HEIGHT)}
end

function love.quit()
    return false
end