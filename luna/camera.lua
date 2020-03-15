local Class = require('luna.class')
local Camera = Class:extend('Camera')

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
end

function Camera:move(x, y)
	self.x = x or 0
	self.y = y or 0
end

function Camera:zoom(zoom)
	self.zoom = zoom or 1
end

function Camera:rotate(angle)
	self.angle = math.rad(angle) or 0
end

function Camera:offset(ox, oy)
	if type(ox) == "string" then
		if ox == "center" then self.offset_x = self.width/2 
		elseif ox == "left" then self.offset_x = 0 
		elseif ox == "right" then self.offset_x = self.width end
	elseif type(ox) == "number" then
		self.offset_x = ox
	end

	local oy = oy or ox or self.offset_y

	if type(oy) == "string" then
		if oy == "center" then self.offset_y = self.height/2 
		elseif oy == "left" then self.offset_y = 0 
		elseif oy == "right" then self.offset_y = self.height end
	elseif type(oy) == "number" then
		self.offset_y = oy
	end
end

function Camera:update(dt)

end

function Camera:attach()
	local width, height = self.width, self.height
	love.graphics.push()
	love.graphics.scale(self.zoom)
	love.graphics.translate(self.offset_x, self.offset_y)
	love.graphics.rotate(self.angle)
	--love.graphics.translate(-self.offset_x, -self.offset_y)
	love.graphics.translate(self.x, self.y)
end

function Camera:detach()
	love.graphics.pop()
end


return Camera