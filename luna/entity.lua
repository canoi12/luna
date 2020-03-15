local Class = require("luna.class")
local Entity = Class:extend("Entity")

function Entity:constructor(x, y)
	self.x = x or 0
	self.y = y or 0
end

function Entity:update(dt)
end

function Entity:draw()
end

return Entity