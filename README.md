# luna

A set of love2d helpers lib

## luna.input

```lua
input = require("input")

function love.load()
	input.registerKey("jump", "space", "up", "c")
	input.registerKey("select", "space", "c", "enter")
end

function love.update(dt)
	input.update(dt)

	if input.isMouseClicked(1) then
		input.fixMousePos() -- call this function before use 'input.getMouseDelta()'
	end

	local dx, dy = input.getMouseDelta()
	print(dx, dy)

	if input.isKeyDown("a") then
		print("a")
	end

	if input.isPressed("jump") then print("jump!!") end
end
```

### TODO

- [ ] Joystick support
- [x] Named input: `input.isPressed("jump") ~> '"jump" = "space", "c", ...'`

## luna.class

```lua
class = require("class")
local Player = class:extend("Player")

function Player:constructor(x, y)
	self.x = x
	self.y = y
end

function Player:update(dt)
	if love.keyboard.isDown("right") then self.x = self.x + 1 end
	if love.keyboard.isDown("left") then self.x = self.x - 1 end
end

function Player:draw()
	love.graphics.rectangle("line", self.x, self.y, 32, 32)
end

function love.load()
	p1 = Player:new(0, 0)
	p2 = Player(32, 32)
end

function love.update(dt)
	p1:update(dt)
	p2:update(dt)
end

function love.draw()
	p1:draw()
	p2:draw()
end

```

## luna.sprite

#### Sprite(image or path, frame_width, [frame_height (frame_width)])

```lua
local Sprite = require("luna.sprite")
local input = require("luna.input")
local sprite = Sprite("assets/knight.png", 16)

local x, y = 0, 0

function love.load()
	sprite:add_animation("idle", "1-4")
	sprite:add_animation("walk", "5-10")
end

function love.update(dt)
	input.update(dt)

	if input.isKeyDown("left") then
		x = x - 100 * dt
		sprite:play("walk")
		sprite:flip(true)
	elseif input.isKeyDown("right") then
		x = x + 100 * dt
		sprite:play("walk")
		sprite:flip(false)
	else
		sprite:play("idle")
	end

	sprite:update(dt)
end

function love.draw()
	sprite:draw(x, y)
end
```

## luna.camera

#### Camera(x, y, width, height [, zoom (1), angle (0)])
Constructor for camera class

#### :update(dt)
Update camera (needed for smooth functions and follow target)

#### :move(x, y [, smooth (false)])
Move camera to position

#### :rotate(angle [, smooth])
Rotate camera

#### :set_zoom(zoom [, smooth])
Zoom (scale) camera

#### :offset(ox (string or number) [, oy (ox)])
Change camera offset, `ox` string arg can be: "center", "left", "right" and `oy` string arg can be "top", "center", "bottom"

#### :attach()
Attach camera for apply transform

#### :detach()
Pop camera

```lua
local Camera = require("luna.camera")

function love.load()
	camera = Camera(0, 0, 320, 160)
end

function love.update(dt)
	camera:update(dt)
end

function love.draw()
	camera:attach()
	-- draw stuff here
	camera:detach()
end
```

## luna.canvas

#### Canvas(width, height [, filter ("nearest")])
Constructor for canvas

#### :attach()
Bind canvas

#### :detach()
Unbind canvas

#### :draw()
Draw canvas

#### :on_resize(w, h)
Callback function to autoscale canvas, if you rewrite `love.resize`, call that function inside that

You can use Canvas with Camera module

```lua
local Canvas = require("luna.canvas")
local Camera = require("luna.camera")

function love.load()
	canvas = Canvas(160, 90)
	camera = Camera(0, 0, 160, 90)
end

function love.update(dt)
	camera:update(dt)
end

function love.draw()
	canvas:attach()
	camera:attach()
	-- draw stuff here
	camera:detach()
	canvas:detach()

	canvas:draw()
end

```