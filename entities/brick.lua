Brick = {}
Brick.__index = Brick

function Brick.new(x, y, width, height)
    local t = {
        rect = Rect.new(x, y, width, height),
    }

    return setmetatable(t, Brick)
end

function Brick:render()
    love.graphics.setColor(255, 255, 255, 255)
    self.rect:fill()
end

return Brick
