local Class = require("luna.class")
local Tilemap = Class:extend("Tilemap")

function Tilemap:constructor(tileset, width, height, map_table, tile_w, tile_h)
  self.tileset = tileset
  self.width = width
  self.height = height
  self.map = map_table or {}
  self.tile_w = tile_w or 16
  self.tile_h = tile_h or 16

  self.autotiles = {}
  self.animtiles = {}
end

function Tilemap:load(path)
end

function Tilemap:set_tileset(tileset)
  self.tileset = tileset or 32
end

function Tilemap:autotile()
end

function Tilemap:autotile_region(x, y, w, h)
end

function Tilemap:add_tile(x, y, tile, autotile)
end

function Tilemap:rm_tile(x, y, autotile)
end

function Tilemap:draw()
  for yy = 1, self.height do
    for xx = 1, self.width do
      local ax, ay = 0, 0
      local tile = (self.width * (yy-1)) + xx
      love.graphics.draw(self.tileset.image, self.tileset.quads[self.map[tile]], xx*self.tile_w-self.tile_w, yy*self.tile_h-self.tile_h)
    end
  end
end

return Tilemap
