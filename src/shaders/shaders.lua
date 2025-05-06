local CanvasPool = require("src/canvasPool")

local shaders = {
    barrelDistortion = love.graphics.newShader("src/shaders/barrel_distortion.glsl"),
    grainyNoise = love.graphics.newShader("src/shaders/grainy.glsl")
}

shaders.CanvasPool = CanvasPool

shaders.init = function(barrelStrength, grainyStrength)
    shaders.barrelDistortion:send("strength", barrelStrength or 0.06)
    shaders.grainyNoise:send("strength", grainyStrength or 0.5)
end

shaders.update = function()
    shaders.grainyNoise:send("time", love.timer.getTime())
end

shaders.drawAppliedShader = function(baseDrawFunc, shaderList, table)
    if table == nil then table = {love.graphics.getWidth(), love.graphics.getHeight()} end
    local w, h = table[1], table[2]

    CanvasPool.reset()

    local currentCanvas = CanvasPool.get(w, h)
    love.graphics.setCanvas(currentCanvas)
    love.graphics.clear()
    love.graphics.setShader()
    baseDrawFunc()
    love.graphics.setCanvas()

    for _, shader in ipairs(shaderList) do
        local nextCanvas = CanvasPool.get(w, h)
        love.graphics.setCanvas(nextCanvas)
        love.graphics.clear()
        love.graphics.setShader(shader)
        love.graphics.draw(currentCanvas)
        love.graphics.setShader()
        love.graphics.setCanvas()

        currentCanvas = nextCanvas
    end

    love.graphics.draw(currentCanvas)
end

return shaders