-- Configuration code for the game, runs before the game loaded

function love.conf(t)
    t.window.title = "Inbox"
    t.window.icon = nil
    t.window.width = 1440/1.2
    t.window.height = 1080/1.2
    t.window.resizable = true
    t.window.fullscreen = true
    t.window.minwidth = 640
    t.window.minheight = 480

    -- for debugging
    t.version = "11.5"
    t.console = true
    t.identity = nil
    t.window.display = 2
end