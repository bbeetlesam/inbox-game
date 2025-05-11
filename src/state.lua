local utils = require("src/utils")
local const = require("src/const")

local state = {
    mouse = {
        x = 0,
        y = 0
    },
    time = {
        frame = 1,
        game = {
            hour = 22,
            minute = 0,
        }
    }
}

state.update = function()
    local _, _, _, _, x, y = utils.core.setGameScreen(const.game.screen.WIDTH, const.game.screen.HEIGHT)
    state.mouse.x = x
    state.mouse.y = y
end

return state