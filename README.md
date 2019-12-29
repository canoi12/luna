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