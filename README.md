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