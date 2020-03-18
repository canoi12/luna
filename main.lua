local Canvas = require("luna.canvas")
local Camera = require("luna.camera")
local ecs = require("luna.ecs")

local Sprite = require("luna.sprite")
local Tileset = require("luna.tileset")
local Tilemap = require("luna.tilemap")

local input = require("luna.input")

--local canvas = canvas(0, 0, 320, 180, 2)
local position = {
	x = 0,
	y = 32
}
local canvas = Canvas(160, 90)
local camera = Camera(0, 0, 160, 90, 1)
camera:offset("center", "center")
camera:set_limits(0, 0, 320, 180)
camera:set_deadzone(60, 30, 100, 50)
camera:follow(position, true)
camera:move(position.x, position.y)
local img = love.graphics.newImage("assets/knight.png")

local ww, hh = love.graphics.getDimensions()

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
local zoom = true

function love.update(dt)
	input.update(dt)
	camera:update(dt)

	if input.isKeyDown("left") then
		position.x = position.x - 80 * dt
		sprite:play("walk")
		sprite:flip(true)
	elseif input.isKeyDown("right") then
		position.x = position.x + 80 * dt
		sprite:play("walk")
		sprite:flip(false)
	else
		sprite:play("idle")
	end

	if input.isKeyPressed("x") then
		camera:set_zoom(zoom and 2 or 1, true)
		camera:rotate(zoom and 720 or 0, true)
		zoom = not zoom
	end

	sprite:update(dt)
	rabbit:update(dt)
end

function love.draw()
	canvas:attach()
	camera:attach()
	tilemap:draw()
	love.graphics.rectangle("line", 160 - 32, 45 - 16, 32, 32)
	sprite:draw(position.x, position.y)
	rabbit:draw(32, 16)
	camera:detach()
	--tileset:draw()
	camera:draw()
	canvas:detach()

	canvas:draw()
	--camera:draw()
	love.graphics.circle("line", ww / 2, hh / 2, 8)
end
