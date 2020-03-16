local utils = {}

function utils.clamp(x, min, max)
  return math.max(min, math.min(x, max))
end

function utils.sign(x)
  return x < 0 and -1 or 1
end

function utils.split(str, sep)
  sep = sep or ","
  local words = str:gmatch("([^" .. sep .. "]+)")
  return words
end

function utils.lerp(v1, v2, delta)
  return v1 + (v2 - v1) * delta
end

function utils.distance(x1, y1, x2, y2)
  local dx = x2 - x1
  local dy = y2 - y1
  local val = dx * dx + dy * dy
  return math.sqrt(val)
end

function utils.angle(x1, y1, x2, y2)
  return math.atan2(y2 - y1, x2 - x1)
end

function utils.round(x)
  return x >= 0 and math.floor(x + .5) or math.ceil(x - .5)
end

return utils
