-- Main entry of the game (LÖVE default)
local utils = require("src/utils")
local const = require("src/const")

-- Load the game. Called once at the beginning of the game
function love.load()
    
end

-- Update the game. Called every frame
function love.update(dt)
    Game = {utils.core.setGameScreen(const.game.screen.WIDTH, const.game.screen.HEIGHT)}
end

-- Draw the game. Called every frame
function love.draw()
    love.graphics.push()
    love.graphics.translate(Game[1], Game[2])
    love.graphics.scale(Game[3], Game[4])

    utils.core.setBaseBgColor(const.color.DEEP_TEAL)
    love.graphics.setColor(const.color.SILVER_TASKBAR)
    love.graphics.rectangle("fill", 0,const.game.screen.HEIGHT-60, const.game.screen.WIDTH,60)

    love.graphics.pop()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    elseif key == "f11" then
        utils.core.toggleFullscreen()
    end
end