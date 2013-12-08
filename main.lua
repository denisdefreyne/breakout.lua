require "types"

DeadBrick = require("entities/dead_brick")
Ball      = require("entities/ball")
Paddle    = require("entities/paddle")
Brick     = require("entities/brick")

-- config

local config = {
    maxXVelocity = 500.0,
    paddleXVelocityFactor = 500.0
}

-- variables

local deadBricks
local bricks
local ball
local paddle

-- lua entry points

function love.load()
    math.randomseed(os.time())
    generateWorld()
end

function love.update(dt)
    -- update dead bricks
    for deadBrick, _ in pairs(deadBricks) do
        deadBrick:update(dt)
    end

    -- move paddle
    paddle:update(dt)

    -- move ball
    ball:update(dt)

    -- check collided with paddle
    if ball.rect:collidesWith(paddle.rect) then
        if ball.oldRect:isFullyBelow(paddle.rect) or ball.oldRect:isFullyAbove(paddle.rect) then
            paddleMiddle, _ = paddle.rect:middle()
            ballMiddle, _   = ball.rect:middle()
            local factor = (ballMiddle - paddleMiddle) / paddle.rect.size.width / 2
            ball.velocityVector.x = ball.velocityVector.x + factor * config.paddleXVelocityFactor
            if ball.velocityVector.x > config.maxXVelocity then
                ball.velocityVector.x = config.maxXVelocity
            elseif ball.velocityVector.x < -config.maxXVelocity then
                ball.velocityVector.x = -config.maxXVelocity
            end

            ball.velocityVector.y = - ball.velocityVector.y
        elseif ball.oldRect:isFullyLeft(paddle.rect) or ball.oldRect:isFullyRight(paddle.rect) then
            ball.velocityVector.x = - ball.velocityVector.x
        end
    end

    -- check collided with wall
    if ball.rect:left() < 0 then
        ball.rect.origin.x    = - ball.rect.origin.x
        ball.velocityVector:invertX()
    elseif ball.rect:right() > love.graphics.getWidth() then
        ball.rect.origin.x    = love.graphics.getWidth() - (ball.rect:right() - love.graphics.getWidth())
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
        if ball.rect:collidesWith(brick.rect) then
            bricks[brick] = nil
            local x, y   = brick.rect.origin.x, brick.rect.origin.y
            local w, h   = brick.rect.size.width, brick.rect.size.height
            local fx, fy = ball.rect.origin.x - ball.oldRect.origin.x, ball.rect.origin.y - ball.oldRect.origin.y
            deadBrick = DeadBrick.new(x, y, w, h, fx, fy)
            deadBrick:onDeath(function(deadBrick) deadBricks[deadBrick] = nil end)
            deadBricks[deadBrick] = true

            if ball.oldRect:isFullyBelow(brick.rect) or ball.oldRect:isFullyAbove(brick.rect) then
                ball.velocityVector.y = - ball.velocityVector.y
            elseif ball.oldRect:isFullyLeft(brick.rect) or ball.oldRect:isFullyRight(brick.rect) then
                ball.velocityVector.x = - ball.velocityVector.x
            end
        end
    end
end

function love.draw()
    -- bricks
    for brick, _ in pairs(bricks) do
        brick:render()
    end

    -- dead bricks
    for deadBrick, _ in pairs(deadBricks) do
        deadBrick:render()
    end

    -- ball
    ball:render()

    -- paddle
    paddle:render()
end

-- model

function generateWorld()
    -- dead bricks
    deadBricks = {}

    -- bricks
    local rectToFill = Rect.new(50, 50, love.graphics.getWidth() - 50, 200)
    local brickSize = Size.new(60, 20)
    local brickSpacing = Size.new(10, 10)
    bricks = {}
    local x = rectToFill:left()
    while x < rectToFill:right() - brickSize.width - brickSpacing.width do
        local y = rectToFill:top()
        while y < rectToFill:bottom() - brickSize.height - brickSpacing.height do
            bricks[Brick.new(x, y, brickSize.width, brickSize.height)] = true
            y = y + brickSize.height + brickSpacing.height
        end
        x = x + brickSize.width + brickSpacing.width
    end

    -- ball
    ball = Ball.new(love.graphics.getWidth()/2 - 40, 400, 10, 10, 60, 300)

    -- paddle
    paddle = Paddle.new(360, 560, 120, 20)
end
