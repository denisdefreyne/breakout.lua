Timer = require('hump/timer')

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
    self.rect:fill()
end

function Ball:collidedVertically()
    local oldSize   = self.rect.size:dup()
    local oldOrigin = self.rect.origin:dup()

    local newSize  = self.rect.size
    newSize.width  = oldSize.width * 2
    newSize.height = oldSize.height / 2

    local newOrigin = self.rect.origin
    newOrigin.x = oldOrigin.x - oldSize.width / 2
    newOrigin.y = oldOrigin.y - oldSize.height / 2

    Timer.tween(1.0, newSize,   oldSize,   'out-elastic')
    Timer.tween(1.0, newOrigin, oldOrigin, 'out-elastic')
end

function Ball:collidedHorizontally()
    local oldSize   = self.rect.size:dup()
    local oldOrigin = self.rect.origin:dup()

    local newSize  = self.rect.size
    newSize.width  = oldSize.width / 2
    newSize.height = oldSize.height * 2

    local newOrigin = self.rect.origin
    newOrigin.x = oldOrigin.x - oldSize.width / 2
    newOrigin.y = oldOrigin.y - oldSize.height / 2

    Timer.tween(1.0, newSize,   oldSize,   'out-elastic')
    Timer.tween(1.0, newOrigin, oldOrigin, 'out-elastic')
end

return Ball
