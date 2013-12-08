DeadBrick = {}
DeadBrick.__index = DeadBrick

function DeadBrick.new(x, y, width, height, fx, fy)
    local t = {
        rect = Rect.new(x, y, width, height),
        velocityVector = Vector.new(fx, fy),
        age = 0,
    }

    return setmetatable(t, DeadBrick)
end

function DeadBrick:maxAge()
    return 1.0
end

function DeadBrick:update(dt)
    -- age
    self.age = self.age + dt
    if self.age > self:maxAge() then
        self.onDeath(self)
        --deadBricks[self] = nil
        return
    end

    -- apply velocity
    self.rect.origin.x = self.rect.origin.x + self.velocityVector.x
    self.rect.origin.y = self.rect.origin.y + self.velocityVector.y
end

function DeadBrick:render()
    -- color
    local alpha = (self:maxAge() - self.age) * 255/2
    love.graphics.setColor(255, 255, 255, alpha)

    -- rotation
    local rotation = self.age

    love.graphics.push()
    love.graphics.translate(self.rect.origin.x, self.rect.origin.y + 1000 * self.age ^ 2)
    love.graphics.rotate(rotation)
    love.graphics.rectangle("fill", 0, 0, self.rect.size.width, self.rect.size.height)
    love.graphics.pop()
end

function DeadBrick:onDeath(fn)
    self.onDeath = fn
end

return DeadBrick
