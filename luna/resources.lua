local Resources = {}


function Resources:load()
	self.images = {}
	self.audios = {}
	self.fonts = {}
end

function Resources:addImage(filename, name)
	self.images[name] = love.graphics.newImage(filename)
end

function Resources:addAudio(filename, type, name)
	local type = type or "static"
	self.audios[name] = love.audio.newSource(filename, type)
end

function Resources:addFont(filename, size, name)
	local size = size or 16
	self.fonts[name] = love.graphics.newFont(filename, size)
end

function Resources:getImage(name)
	return self.images[name]
end

function Resources:getFont(name)
	return self.fonts[name]
end

function Resources:getAudio(name)
	return self.audio[name]
end

return Resources