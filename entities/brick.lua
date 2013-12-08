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
    love.graphics.rectangle("fill", self.rect.origin.x, self.rect.origin.y, self.rect.size.width, self.rect.size.height)
end

return Brick
