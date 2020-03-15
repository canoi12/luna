local Canvas = require("luna.canvas")
local Camera = require("luna.camera")
local ecs = require("luna.ecs")

local Sprite = require("luna.sprite")
local Tileset = require("luna.tileset")
local Tilemap = require("luna.tilemap")

local input = require("luna.input")

--local canvas = canvas(0, 0, 320, 180, 2)
local canvas = Canvas(160, 90, 1)
local camera = Camera(0, 0, 160, 90)
local angle = 0
camera:offset("center", "center")
local img = love.graphics.newImage("assets/knight.png")
local x, y = 0, 32

function love.load()
	sprite = Sprite(img, 32, 32)
	sprite:add_animation("idle", "1-4")
	sprite:add_animation("walk", "5-10")
	sprite:add_animation("jump", "11")
	sprite:add_animation("fall", "12")
	sprite:play("idle")

	rabbit = Sprite("assets/rabbit.png", 32)
	rabbit:add_animation("shoot", "1-4")

	tileset = Tileset("assets/tileset.png")
	tilemap = Tilemap(tileset, 4, 6, {1, 2, 2, 3, 5, 6, 6, 7, 5, 6, 6, 7, 5, 6, 6, 7, 5, 6, 6, 7, 9, 10, 10, 11})
end

function love.update(dt)
	input.update(dt)

	if input.isKeyDown("left") then
		x = x - 80 * dt
		sprite:play("walk")
		sprite.flip_h = -1
	elseif input.isKeyDown("right") then
		x = x + 80 * dt
		sprite:play("walk")
		sprite.flip_h = 1
	else
		sprite:play("idle")
	end

	sprite:update(dt)
	rabbit:update(dt)

	camera:move(-x, -y)
	--angle = angle + 15*dt
	camera:rotate(angle)
end

function love.draw()
	canvas:attach()
	camera:attach()
	tilemap:draw()
	love.graphics.rectangle("line", 160 - 16, 90 - 16, 32, 32)
	sprite:draw(x, y)
	rabbit:draw(32, 16)
	camera:detach()
	--tileset:draw()
	canvas:detach()

	canvas:draw()
	ecs.fps()
end
