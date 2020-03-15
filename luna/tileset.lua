local Class = require("luna.class")
local Tileset = Class:extend("Tileset")

local function create_quads(tileset)
  tileset.quads = {}
  local imgw, imgh = tileset.image:getDimensions()
  local fw, fh = tileset.tile_w, tileset.tile_h

  for y = 0, imgh - fh, fh do
    for x = 0, imgw - fw, fw do
      table.insert(tileset.quads, love.graphics.newQuad(x, y, fw, fh, imgw, imgh))
    end
  end
end

function Tileset:constructor(image, size, filter)
  if type(image) == "string" then
    self.image = love.graphics.newImage(image)
  elseif type(image) == "userdata" then
    self.image = image
  end

  self.filter = filter or "nearest"
  self.image:setFilter(self.filter, self.filter)
  self.tile_w = size or 16
  self.tile_h = size or 16

  self.quads = {}
  create_quads(self)
end

function Tileset:set_size(size)
  self.tile_w = size or self.tile_w
  self.tile_h = size or self.tile_h
  create_quads(self)
end

function Tileset:set_image(image)
  if type(image) == "string" then
    self.image = love.graphics.newImage(image)
  elseif type(image) == "userdata" then
    self.image = image
  end
  create_quads(self)
end

function Tileset:set_filter(filter)
  self.filter = filter or self.filter
  self.image:setFilter(self.filter, self.filter)
end

function Tileset:add_autotile(autotile_table)
end

function Tileset:add_animtile(animtile_table)
end

function Tileset:draw()
  local yy = 0
  local xx = 0
  local ww = 160
  for i, quad in ipairs(self.quads) do
    if xx >= ww-self.tile_w then
      yy = yy + self.tile_h
      xx = 0
    end
    print(xx)
    love.graphics.draw(self.image, quad, xx, yy)
    love.graphics.print(i, xx, yy)
    xx = xx + self.tile_w
  end
end

return Tileset
