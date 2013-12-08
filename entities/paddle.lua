Paddle = {}
Paddle.__index = Paddle

function Paddle.new(x, y, width, height)
	local t = {
		rect = Rect.new(x, y, width, height)
	}

    return setmetatable(t, Paddle)
end

function Paddle:render()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle("fill", self.rect.origin.x, self.rect.origin.y, self.rect.size.width, self.rect.size.height)
end

function Paddle:update(dt)
	mouseX, _ = love.mouse.getPosition()
    self.rect.origin.x = mouseX - self.rect.size.width/2
    if self.rect:left() < 0 then
        self.rect.origin.x = 0
    elseif self.rect:right() > love.graphics.getWidth() then
        self.rect.origin.x = love.graphics.getWidth() - self.rect.size.width
    end
end

return Paddle
