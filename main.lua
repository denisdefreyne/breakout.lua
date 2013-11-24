require "types"

-- config

local config = {
    maxXVelocity = 500.0,
    paddleXVelocityFactor = 500.0
}

-- variables

local bricks
local ball
local paddle

-- types

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

function Ball:move(dt)
    self.oldRect.origin.x = self.rect.origin.x
    self.oldRect.origin.y = self.rect.origin.y

    self.rect.origin.x = self.rect.origin.x + dt*self.velocityVector.x
    self.rect.origin.y = self.rect.origin.y + dt*self.velocityVector.y
end

-- lua entry points

function love.load()
    math.randomseed(os.time())
    generateBricks()
end

function love.update(dt)
    -- move paddle
    mouseX, _ = love.mouse.getPosition()
    paddle.origin.x = mouseX - paddle.size.width/2
    if paddle:left() < 0 then
        paddle.origin.x = 0
    elseif paddle:right() > love.graphics.getWidth() then
        paddle.origin.x = love.graphics.getWidth() - paddle.size.width
    end

    -- move ball
    ball:move(dt)

    -- check collided with paddle
    if ball.rect:collidesWith(paddle) then
        if ball.oldRect:isFullyBelow(paddle) or ball.oldRect:isFullyAbove(paddle) then
            paddleMiddle, _ = paddle:middle()
            ballMiddle, _   = ball.rect:middle()
            local factor = (ballMiddle - paddleMiddle) / paddle.size.width / 2
            ball.velocityVector.x = ball.velocityVector.x + factor * config.paddleXVelocityFactor
            if ball.velocityVector.x > config.maxXVelocity then
                ball.velocityVector.x = config.maxXVelocity
            elseif ball.velocityVector.x < -config.maxXVelocity then
                ball.velocityVector.x = -config.maxXVelocity
            end

            ball.velocityVector.y = - ball.velocityVector.y
        elseif ball.oldRect:isFullyLeft(paddle) or ball.oldRect:isFullyRight(paddle) then
            ball.velocityVector.x = - ball.velocityVector.x
        end
    end

    -- check collided with wall
    if ball.rect:left() < 0 then
        ball.rect.origin.x    = - ball.rect.origin.x
        ball.velocityVector:invertX()
    elseif ball.rect:right() > love.graphics.getWidth() then
        ball.rect.origin.x    = love.graphics.getWidth() + love.graphics.getWidth() - ball.rect.origin.x
        ball.velocityVector:invertX()
    end
    if ball.rect:top() < 0 then
        ball.rect.origin.y    = - ball.rect.origin.y
        ball.velocityVector:invertY()
    elseif ball.rect:bottom() > love.graphics.getHeight() then
        -- nooooo
        love.load()
    end

    -- check collided with brick
    for brick, _ in pairs(bricks) do
        if ball.rect:collidesWith(brick) then
            bricks[brick] = nil

            if ball.oldRect:isFullyBelow(brick) or ball.oldRect:isFullyAbove(brick) then
                ball.velocityVector.y = - ball.velocityVector.y
            elseif ball.oldRect:isFullyLeft(brick) or ball.oldRect:isFullyRight(brick) then
                ball.velocityVector.x = - ball.velocityVector.x
            end
        end
    end
end

function love.draw()
    -- bricks
    for brick, _ in pairs(bricks) do
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.rectangle("fill", brick.origin.x, brick.origin.y, brick.size.width, brick.size.height)
    end

    -- ball
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle("fill", ball.rect.origin.x, ball.rect.origin.y, ball.rect.size.width, ball.rect.size.height)

    -- paddle
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle("fill", paddle.origin.x, paddle.origin.y, paddle.size.width, paddle.size.height)
end

-- model

function generateBricks()
    local rectToFill = Rect.new(50, 50, love.graphics.getWidth() - 50, 200)
    local brickSize = Size.new(60, 20)
    local brickSpacing = Size.new(10, 10)

    bricks = {}
    local x = rectToFill:left()
    while x < rectToFill:right() - brickSize.width - brickSpacing.width do
        local y = rectToFill:top()
        while y < rectToFill:bottom() - brickSize.height - brickSpacing.height do
            bricks[Rect.new(x, y, brickSize.width, brickSize.height)] = true
            y = y + brickSize.height + brickSpacing.height
        end
        x = x + brickSize.width + brickSpacing.width
    end

    ball = Ball.new(love.graphics.getWidth()/2 - 40, 400, 10, 10, 60, 300)

    paddle = Rect.new(360, 560, 120, 20)
end
