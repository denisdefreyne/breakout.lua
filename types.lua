-- vector

Vector = {}
Vector.__index = Vector

function Vector.new(x, y)
	return setmetatable({ x = x, y = y }, Vector)
end

function Vector:invertX()
	self.x = - self.x
end

function Vector:invertY()
	self.y = - self.y
end

-- point

Point = {}
Point.__index = Point

function Point.new(x, y)
	return setmetatable({ x = x, y = y }, Point)
end

function Point:dup()
	return Point.new(self.x, self.y)
end

-- size

Size = {}
Size.__index = Size

function Size.new(width, height)
	return setmetatable({ width = width, height = height }, Size)
end

function Size:dup()
	return Size.new(self.width, self.height)
end

-- range

Range = {}
Range.__index = Range

function Range.new(min, max)
	return setmetatable({ min = min, max = max }, Range)
end

function Range:includesValue(value)
	return value > self.min and value < self.max
end

function Range:overlapsWith(other)
	return self:includesValue(other.min) or other:includesValue(self.min)
end

-- rect

Rect = {}
Rect.__index = Rect

function Rect.new(x, y, width, height)
	return setmetatable({ origin = Point.new(x, y), size = Size.new(width, height) }, Rect)
end

function Rect:collidesWith(other)
	return self:xRange():overlapsWith(other:xRange()) and self:yRange():overlapsWith(other:yRange())
end

function Rect:xRange()
	return Range.new(self:left(), self:right())
end

function Rect:yRange()
	return Range.new(self:top(), self:bottom())
end

function Rect:middle()
	return self.origin.x + self.size.width/2, self.origin.y + self.size.height/2
end

function Rect:left()
	return self.origin.x
end

function Rect:right()
	return self.origin.x + self.size.width
end

function Rect:top()
	return self.origin.y
end

function Rect:bottom()
	return self.origin.y + self.size.height
end

function Rect:isFullyBelow(other)
	return self:top() > other:bottom()
end

function Rect:isFullyAbove(other)
	return self:bottom() < other:top()
end

function Rect:isFullyLeft(other)
	return self:right() < other:left()
end

function Rect:isFullyRight(other)
	return self:left() > other:right()
end

function Rect:fill()
	love.graphics.rectangle(
		"fill",
		self.origin.x,
		self.origin.y,
		self.size.width,
		self.size.height)
end
