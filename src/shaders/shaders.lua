local shaders = {
    barrelDistortion = love.graphics.newShader("src/shaders/barrel_distortion.glsl"),
    grainyNoise = love.graphics.newShader("src/shaders/grainy.glsl")
}

shaders.init = function(barrelStrength, grainyStrength)
    shaders.barrelDistortion:send("strength", barrelStrength or 0.06)
    shaders.grainyNoise:send("strength", grainyStrength or 0.5)
end

shaders.update = function()
    shaders.grainyNoise:send("time", love.timer.getTime())
end

return shaders