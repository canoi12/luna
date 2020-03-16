local Class = require("luna.class")
local Scene = Class:extend("Scene")

function Scene:constructor()
  self.objects = {}
  self.objects_to_add = {}
  self.objects_to_remove = {}
end

function Scene:update(dt)
end

function Scene:draw()
end

return Scene