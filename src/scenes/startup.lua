local state = require("src/state")
local const = require("src/const")
local utils = require("src/utils")
local shaders = require("src/shaders/shaders")

local startup = {
    brightness = 0,
    tween = nil,
    delay = 1.7, -- in seconds
    delayTimer = 0,
    waitingDelay = false,
    fadingOut = false,
    fadingIn = false,
    fadeTween = nil,
    fadeOutTime = 2.0,
    fadeInTime = 2.0,
    showStartupContent = true,
}

function startup:reset()
    self.brightness = 0
    self.delayTimer = 0
    self.waitingDelay = false
    self.fadingOut = false
    self.fadingIn = false
    self.tween = nil
    self.fadeTween = nil
    self.showStartupContent = true
    state.game.isStartingUp = true
    self:startTween()
end

function startup:startTween()
    self.tween = utils.tween(0, 1.0, 1.5, nil,
        function(value) self.brightness = value end,
        function()
            self.waitingDelay = true
            self.delayTimer = 0
            self.tween = nil
        end
    )
end

function startup:startFadeOut()
    self.fadingOut = true
    self.fadeTween = utils.tween(self.brightness, 0, self.fadeOutTime, nil,
        function(value) self.brightness = value end,
        function()
            self.fadingOut = false
            self.fadingIn = true
            self.showStartupContent = false
            self:startFadeIn()
        end
    )
end

function startup:startFadeIn()
    self.fadeTween = utils.tween(0, 1.0, self.fadeInTime, nil,
        function(value) self.brightness = value end,
        function()
            self.fadingIn = false
            state.game.isStartingUp = false
        end
    )
end

function startup:update(dt)
    if self.tween then
        self.brightness = select(1, self.tween(dt))
    elseif self.waitingDelay then
        self.delayTimer = self.delayTimer + dt
        if self.delayTimer >= self.delay then
            self.waitingDelay = false
            self:startFadeOut()
        end
    elseif self.fadingOut or self.fadingIn then
        self.brightness = select(1, self.fadeTween(dt))
    end
end

function startup:draw()
    love.graphics.push("all")
    love.graphics.setShader(shaders.adjustBrightness)
    shaders.adjustBrightness:send("brightness", self.brightness)

    if self.showStartupContent then
        love.graphics.setColor(const.color.NAVY_BLUE)
        love.graphics.rectangle("fill", 0, 0, const.game.screen.WIDTH, const.game.screen.HEIGHT)
    end

    love.graphics.setShader()
    love.graphics.pop()
end

return startup