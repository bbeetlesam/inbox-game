-- Constants for the game
local utils = require("src/utils")

local const = {
    game = {
        TITLE = "Inbox",
        screen = {
            WIDTH = 1440,
            HEIGHT = 1080,
        },
        TASKBAR_HEIGHT = 45,
    },

    color = {
        DEEP_TEAL = utils.setRGB(0, 128, 128),
        SILVER_TASKBAR = utils.setRGB(192, 192, 192),
        NAVY_BLUE = utils.setRGB(0, 0, 128),
        BLACK = utils.setRGB(0, 0, 0),
        SILVER_BEVEL = utils.setRGB(80, 80, 80),
        WHITE = {1, 1, 1},
    },

    font = {
        WIN95 = "assets/fonts/W95FA.otf",
    }
}

return const