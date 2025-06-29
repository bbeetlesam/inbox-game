CanvasPool = {}

function CanvasPool.get(w, h)
    for _, canvas in ipairs(CanvasPool) do
        -- check if canvas.canvas is not nil and not released
        local ok, width = pcall(function() return canvas.canvas:getWidth() end)
        if not canvas.inUse and canvas.canvas and ok
           and width == w and canvas.canvas:getHeight() == h then
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
    for i = #CanvasPool, 1, -1 do
        table.remove(CanvasPool, i)
    end
end

-- for debugging
function CanvasPool.debug()
    print("CanvasPool size:", #CanvasPool)
    for i, canvas in ipairs(CanvasPool) do
        local ok, w = pcall(function() return canvas.canvas:getWidth() end)
        local width = ok and w or "released"
        print(string.format("Canvas %d: %s, inUse: %s", i, tostring(width), tostring(canvas.inUse)))
    end
end

return CanvasPool