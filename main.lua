-- Main entry of the game (LÖVE default)

local utils = require("src/utils")

-- Load the game
-- This function is called once at the beginning of the game
function love.load()
    
end

-- Update the game
-- This function is called every frame
function love.update(dt)
    Game = {utils.setGameScreen(1440, 1080)}
end

-- Draw the game
-- This function is called every frame
function love.draw()
    love.graphics.push()
    love.graphics.translate(Game[1], Game[2])
    love.graphics.scale(Game[3], Game[4])

    utils.setBaseBgColor(0.2, 0.2, 0.3)
    love.graphics.rectangle("fill", 0,0, 60,120)

    love.graphics.pop()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
end