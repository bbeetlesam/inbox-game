local startup = require("src/scenes/startup")

local sceneManager = {
    scenes = {
        startup = startup,
    },
    current = "startup",
}

sceneManager.setScene = function(name)
    if name == nil or name == "none" then
        sceneManager.current = nil
        return
    end

    if sceneManager.scenes[name] then
        sceneManager.current = name
        if sceneManager.scenes[name].reset then
            sceneManager.scenes[name]:reset()
        end
    else
        error("Selected scene '" .. tostring(name) .. "' does not exist, you fool.")
    end
end

sceneManager.update = function(dt)
    if not sceneManager.current then return end
    local scene = sceneManager.scenes[sceneManager.current]
    if scene and scene.update then
        scene:update(dt)
    end
end

sceneManager.draw = function()
    if not sceneManager.current then return end
    local scene = sceneManager.scenes[sceneManager.current]
    if scene and scene.draw then
        scene:draw()
    end
end

return sceneManager