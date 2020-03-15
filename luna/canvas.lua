local Class = require("luna.class")
local Canvas = Class:extend("Canvas")

function Canvas:constructor(width, height, scale, filter)
	local width = width or love.graphics.getWidth()
	local height = height or love.graphics.getHeight()
	local filter = filter or "nearest"
	self.width = width
	self.height = height
	self.canvas = love.graphics.newCanvas(width, height)
	self.canvas:setFilter(filter, filter)
	self.scale = scale or 1
	self.aspect = 1
	self.x = 0
	self.y = 0

	self:on_resize(love.graphics.getWidth(), love.graphics.getHeight())

	love.resize = function(w, h) 
		self:on_resize(w, h)
	end
end

function Canvas:on_resize(w, h)
	local ww, hh = w, h
	local aspw, asph = ww/self.width, hh/self.height
	if aspw < asph then self.aspect = aspw
	else self.aspect = asph end
	self.x = ww/2
	self.y = hh/2
end

function Canvas:set_scale(scale)
	self.scale = scale
end

function Canvas:attach()
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear(0.2, 0.3, 0.4, 1)
end

function Canvas:detach()
	love.graphics.setCanvas()
end

function Canvas:draw()
	love.graphics.draw(self.canvas, self.x, self.y, 0, self.aspect, self.aspect, self.width/2, self.height/2)
	love.graphics.print(self.aspect, 32, 32)
end

return Canvas