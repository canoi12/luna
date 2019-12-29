local input = {}

local mouse_buttons = {1, 2, 3}

local states = {
	mouse = {
		down = {},
		pressed = {}
	},
	key = {

	}
}

old_state = {
	mouse = {
		down = {}
	},
	key = {}
}

local anykeydown = false
local mouse = {
	x = 0,
	y = 0,
	fix_x = 0,
	fix_y = 0
}

local keys = {}

function input.update(dt)
	anykeydown = false
	mouse.x, mouse.y = love.mouse.getPosition()
	for i,button in ipairs(mouse_buttons) do
		old_state.mouse.down[button] = states.mouse.down[button]
		states.mouse.down[button] = input.isMouseDown(button)
		states.mouse.pressed[button] = states.mouse.down[button] and not old_state.mouse.down[button]
	end

	for k,key in pairs(states.key) do
		old_state.key[k].down = states.key[k].down
		states.key[k].down = love.keyboard.isDown(k)
		states.key[k].pressed = states.key[k].down and not old_state.key[k].down
		if states.key[k].down then anykeydown = true end 
	end
end

function input.registerKey(name, ...)
	local args = {...}
	keys[name] = {}
	for i,key in ipairs(args) do
		table.insert(keys[name], key)
	end
end

function input.isDown(name)
	for i,key in ipairs(keys[name]) do
		if input.isKeyDown(key) then return true end
	end
	return false
end

function input.isPressed(name)
	for i,key in ipairs(keys[name]) do
		if input.isKeyPressed(key) then return true end
	end
	return false
end

function input.isMouseDown(button)
	return love.mouse.isDown(button)
end

function input.isMouseUp(button)
	return not input.isMouseDown(button)
end

function input.isMouseClicked(button)
	return states.mouse.pressed[button]
end

function input.isKeyDown(key)
	input.initKey(key)
	return states.key[key].down
end

function input.isKeyPressed(key)
	input.initKey(key)
	return states.key[key].pressed
end

function input.isKeyUp(key)
	input.initKey(key)
	return not states.key[key].down
end

function input.initKey(key)
	if states.key[key] == nil then
		states.key[key] = {
			down = false,
			pressed = false
		}
		old_state.key[key] = {
			down = false
		}
	end
end

function input.mousePos()
	return mouse.x, mouse.y
end

function input.fixMousePos()
	mouse.fix_x = mouse.x
	mouse.fix_y = mouse.y
end

function input.getMouseDelta()
	local dx = mouse.x - mouse.fix_x
	local dy = mouse.y - mouse.fix_y
	return dx, dy
end


return input