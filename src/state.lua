local utils = require("src/utils")
local const = require("src/const")

local state = {
    mouse = {
        x = 0,
        y = 0
    },
    time = {
        frame = 0,
        minuteInFrame = 400,
        game = {
            day = 1,
            hour = 22,
            minute = 0,
        }
    },
    settings = {
        wallpaper = "green",
        brightness = 80,
        volume = 75,
        permissions = {
            system = false,
            camera = false,
            microphone = false,
        },
    }
}

state.update = function()
    local _, _, _, _, x, y = utils.core.setGameScreen(const.game.screen.WIDTH, const.game.screen.HEIGHT)
    state.mouse.x = x
    state.mouse.y = y
end

state.updateTimeInFrame = function()
    state.time.frame = state.time.frame + 1

    if state.time.frame % state.time.minuteInFrame == 0 then
        state.time.game.minute = state.time.game.minute + 1

        if state.time.game.minute >= 60 then
            state.time.game.minute = 0
            state.time.game.hour = state.time.game.hour + 1
        end
    end
end

return state