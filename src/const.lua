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
        USERNAME = (utils.setLimiterString(os.getenv("USERNAME") or os.getenv("USER") or "User", 12, ".."):gsub("^%s*(%a)(.*)$", function(a, b) return a:upper() .. b:lower() end)),
    },

    color = {
        DEEP_TEAL = utils.setRGB(0, 128, 128),
        TROLLEY_GREY = utils.setRGB(65, 74, 81),
        WALLPAPER_BLUE = utils.setRGB(52, 107, 161),
        SILVER_TASKBAR = utils.setRGB(192, 192, 192),
        NAVY_BLUE = utils.setRGB(0, 0, 128),
        BLACK = utils.setRGB(0, 0, 0),
        SILVER_BEVEL = utils.setRGB(70, 70, 70),
        WHITE = {1, 1, 1},
        SILVER_UNPRIORITIZED = utils.setRGB(130, 130, 130),
    },

    font = {
        WIN95 = "assets/fonts/W95FA.otf",
        BRITTANY = "assets/fonts/Britannic Bold Regular.ttf",
    }
}

return const