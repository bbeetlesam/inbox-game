CanvasPool = {}

function CanvasPool.get(w, h)
    for _, canvas in ipairs(CanvasPool) do
        if not canvas.inUse and canvas.canvas:getWidth() == w and canvas.canvas:getHeight() == h then
            canvas.inUse = true
            return canvas.canvas
        end
    end

    local newCanvas = {
        canvas = love.graphics.newCanvas(w, h),
        inUse = true
    }
    table.insert(CanvasPool, newCanvas)
    return newCanvas.canvas
end

function CanvasPool.reset()
    for _, canvas in ipairs(CanvasPool) do
        canvas.inUse = false
    end
end

function CanvasPool.clear()
    for _, canvas in ipairs(CanvasPool) do
        canvas.inUse = false
        canvas.canvas:release()
    end
end

-- for debugging
function CanvasPool.debug()
    print("CanvasPool size:", #CanvasPool)
    for i, canvas in ipairs(CanvasPool) do
        print(string.format("Canvas %d: %dx%d, inUse: %s", i, canvas.canvas:getWidth(), canvas.canvas:getHeight(), tostring(canvas.inUse)))
    end
end

return CanvasPool