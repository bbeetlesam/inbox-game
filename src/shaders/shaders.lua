local shaders = {
    barrelDistortion = love.graphics.newShader("src/shaders/barrel_distortion.glsl"),
    grainyNoise = love.graphics.newShader("src/shaders/grainy.glsl")
}

shaders.initShaders = function(barrelStrength, grainyStrength)
    shaders.barrelDistortion:send("strength", barrelStrength or 0.06)
    shaders.grainyNoise:send("strength", grainyStrength or 0.5)
end

shaders.updateShaders = function()
    shaders.grainyNoise:send("time", love.timer.getTime())
end

return shaders