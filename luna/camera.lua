local Class = require("luna.class")
local Camera = Class:extend("Camera")
local utils = require("luna.utils")

function Camera:constructor(x, y, width, height, zoom, angle)
	self.width = width or 320
	self.height = height or 180
	self.x = x or self.width / 2
	self.y = y or self.height / 2
	self.zoom = zoom or 1
	local angle = angle or 0
	self.angle = math.rad(angle)
	self.offset_x = 0
	self.offset_y = 0
	self.target = nil
	self.lerp = 5
	self.deadzone = false

	self.limits = {
		left = 0,
		right = 100000,
		top = 0,
		bottom = 100000
	}

	self.deadzones = {
		left = 0,
		right = self.width,
		top = 0,
		bottom = self.height
	}

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

function Camera:to_camera_coords(x, y)
	local c, s = math.cos(self.angle), math.sin(self.angle)
	x, y = x - self.x, y - self.y
	x, y = c * x - s * y, c * y - s * x
	return x * self.zoom + self.width / 2, y * self.zoom + self.height / 2
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

function Camera:set_deadzone(left, top, right, bottom)
	self.deadzone = true
	self.deadzones = {
		left = left or self.deadzones.left,
		right = right or self.deadzones.right,
		top = top or self.deadzones.top,
		bottom = bottom or self.deadzones.bottom
	}
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

function Camera:set_limits(left, top, right, bottom)
	self.limits.left = left or self.limits.left
	self.limits.right = right or self.limits.right
	self.limits.top = top or self.limits.top
	self.limits.bottom = bottom or self.limits.bottom
end

function Camera:update(dt)
	if self.target then
		if self.deadzone then
			local tx, ty = self:to_camera_coords(self.target.obj.x, self.target.obj.y)
			if tx < self.deadzones.left then
				local delta = self.deadzones.left - tx
				self.smooth.x = self.x - delta
			elseif tx > self.deadzones.right then
				local delta = tx - self.deadzones.right
				self.smooth.x = self.x + delta
			end
			if ty < self.deadzones.top then
				local delta = self.deadzones.top - ty
				self.smooth.y = self.y - delta
			elseif ty > self.deadzones.bottom then
				local delta = ty - self.deadzones.bottom
				self.smooth.y = self.y + delta
			end
		else
			self:move(self.target.obj.x, self.target.obj.y, self.target.smooth)
		end
	end
	self.zoom = utils.lerp(self.zoom, self.smooth.zoom, self.lerp * dt)
	self.angle = utils.lerp(self.angle, self.smooth.angle, self.lerp * dt)
	self.x = utils.lerp(self.x, self.smooth.x, self.lerp * dt)
	self.y = utils.lerp(self.y, self.smooth.y, self.lerp * dt)

	self.x =
		utils.clamp(
		self.x,
		self.limits.left - ((self.zoom - 1) * self.width / 4),
		self.limits.right - self.width + ((self.zoom - 1) * self.width / 4)
	)
	self.y =
		utils.clamp(
		self.y,
		self.limits.top - ((self.zoom - 1) * self.height / 4),
		self.limits.bottom - self.height + ((self.zoom - 1) * self.height / 4)
	)
end

function Camera:draw()
	local x, y = self.deadzones.left, self.deadzones.top
	local w, h = self.deadzones.right - self.deadzones.left, self.deadzones.bottom - self.deadzones.top
	love.graphics.rectangle("line", x, y, w, h)
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
