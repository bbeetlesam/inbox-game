CanvasPool = {}

function CanvasPool.get(w, h)
    for _, canvas in ipairs(CanvasPool) do
        if not canvas.inUse and canvas:getWidth() == w and canvas:getHeight() == h then
            canvas.inUse = true
            return canvas
        end
    end

    local newCanvas = love.graphics.newCanvas(w, h)
    newCanvas.inUse = true
    table.insert(CanvasPool, newCanvas)
    return newCanvas
end

function CanvasPool.reset()
    for _, canvas in ipairs(CanvasPool) do
        canvas.inUse = false
    end
end

return CanvasPool