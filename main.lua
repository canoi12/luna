local Class = require("luna.class")
local ecs = require("luna.ecs")
local world = ecs.world()
local comp = ecs.component(world, "position", {x = 0, y = 32})
ecs.system(world, "opa", "onUpdate", {"position"}, function(row)
	--local p = row.component["position"]
	local p = {}
	if love.keyboard.isDown("right") then p.x = p.x + 1 end
end)

ecs.system(world, "rect", "onDraw", {"position"}, function(row)
	local p = row.component["position"]
	--print(p)
	love.graphics.rectangle("line", p.x, p.y, 32, 32)
end)

--local entity = ecs.entity(world, 1, {"position"})

for i=1,50000 do
	local e = ecs.entity(world, i, {"position", "draw"})
	e:set("position", {x = i})
end

function love.load()
	local c = Class:new()
end

function love.update(dt)
	world:update(dt)
end

function love.draw()
	world:draw()
	ecs.fps()
end