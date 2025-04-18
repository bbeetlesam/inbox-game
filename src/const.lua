-- Constants for the game
local utils = require("src/utils")

local const = {
    game = {
        TITLE = "Inbox",
        screen = {
            WIDTH = 1440,
            HEIGHT = 1080,
        },
    },

    color = {
        DEEP_TEAL = utils.setRGB(0, 128, 128),
        SILVER_TASKBAR = utils.setRGB(192, 192, 192),
    },
}

return const