Ball = {}
Ball.__index = Ball

function Ball.new(x, y, width, height, velocityX, velocityY)
    local t = {
        rect           = Rect.new(x, y, width, height),
        oldRect        = Rect.new(x, y, width, height),
        velocityVector = Vector.new(velocityX, velocityY),
    }

    return setmetatable(t, Ball)
end

function Ball:update(dt)
    self.oldRect.origin.x = self.rect.origin.x
    self.oldRect.origin.y = self.rect.origin.y

    self.rect.origin.x = self.rect.origin.x + dt*self.velocityVector.x
    self.rect.origin.y = self.rect.origin.y + dt*self.velocityVector.y
end

function Ball:render()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle("fill", self.rect.origin.x, self.rect.origin.y, self.rect.size.width, self.rect.size.height)
end

return Ball
