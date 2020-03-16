local Class = require("luna.class")
local Camera = Class:extend("Camera")
local utils = require("luna.utils")

function Camera:constructor(x, y, width, height, zoom, angle)
	self.x = x or 0
	self.y = y or 0
	self.width = width or 320
	self.height = height or 180
	self.zoom = zoom or 1
	local angle = angle or 0
	self.angle = math.rad(angle)
	self.offset_x = 0
	self.offset_y = 0
	self.target = nil

	self.smooth = {
		zoom = self.zoom,
		x = self.x,
		y = self.y,
		move = {
			x = self.y,
			y = self.x
		},
		angle = self.angle
	}
end

function Camera:move(x, y, smooth)
	self.smooth.x = (x or 0)
	self.smooth.y = (y or 0)
	self.x = smooth and self.x or self.smooth.x
	self.y = smooth and self.y or self.smooth.y
end

function Camera:set_zoom(zoom, smooth)
	self.smooth.zoom = zoom or 1
	self.zoom = smooth and self.zoom or self.smooth.zoom
end

function Camera:rotate(angle, smooth)
	self.smooth.angle = math.rad(angle) or 0
	self.angle = smooth and self.angle or self.smooth.angle
end

function Camera:offset(ox, oy)
	if type(ox) == "string" then
		if ox == "center" then
			self.offset_x = self.width / 2
		elseif ox == "left" then
			self.offset_x = 0
		elseif ox == "right" then
			self.offset_x = self.width
		end
	elseif type(ox) == "number" then
		self.offset_x = ox
	end

	local oy = oy or ox or self.offset_y

	if type(oy) == "string" then
		if oy == "center" then
			self.offset_y = self.height / 2
		elseif oy == "top" or oy == "left" then
			self.offset_y = 0
		elseif oy == "bottom" or oy == "right" then
			self.offset_y = self.height
		end
	elseif type(oy) == "number" then
		self.offset_y = oy
	end
end

function Camera:follow(target, smooth)
	self.target = {
		smooth = smooth or false,
		obj = target
	}
end

function Camera:update(dt)
	if self.target then
		self:move(self.target.obj.x, self.target.obj.y, self.target.smooth)
	end
	self.zoom = utils.lerp(self.zoom, self.smooth.zoom, 5 * dt)
	self.angle = utils.lerp(self.angle, self.smooth.angle, 5 * dt)
	self.x = utils.lerp(self.x, self.smooth.x, 5 * dt)
	self.y = utils.lerp(self.y, self.smooth.y, 5 * dt)
	
end

function Camera:attach()
	love.graphics.push()
	love.graphics.scale(self.zoom)
	love.graphics.translate(self.offset_x / self.zoom, self.offset_y / self.zoom)
	love.graphics.rotate(self.angle)
	love.graphics.translate(-self.x, -self.y)
end

function Camera:detach()
	love.graphics.pop()
end

return Camera
