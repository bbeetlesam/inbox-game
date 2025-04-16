function love.conf(t)
    t.window.title = "Inbox"
    t.window.icon = nil
    t.window.width = 1600
    t.window.height = 1000
    t.window.resizable = true
    t.window.fullscreen = true
    t.window.minwidth = 960
    t.window.minheight = 600

    -- for debugging
    t.version = "11.5"
    t.console = true
    t.identity = nil
    t.window.display = 2
end