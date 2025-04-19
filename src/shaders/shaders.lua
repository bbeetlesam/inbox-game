local shaders = {
    barrelDistortion = love.graphics.newShader("src/shaders/barrel_distortion.glsl"),
    grainyNoise = love.graphics.newShader("src/shaders/grainy.glsl")
}

shaders.updateShaders = function()
    shaders.grainyNoise:send("time", love.timer.getTime())
end

return shaders