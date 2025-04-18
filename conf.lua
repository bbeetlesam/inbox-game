-- Configuration code for the game, runs before the game loaded
local const = require("src/const")

function love.conf(t)
    t.window.title = const.game.TITLE
    t.window.icon = "assets/img/icon.png"
    t.window.width = 1440/1.2
    t.window.height = 1080/1.2
    t.window.resizable = true
    t.window.fullscreen = false
    t.window.minwidth = 640
    t.window.minheight = 480

    -- for debugging
    t.version = "11.5"
    t.console = true
    t.identity = nil
    t.window.display = 2
end