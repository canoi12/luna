io.stdout:setvbuf("no")

function love.conf(t)
    t.title = "Luna"
    t.window.vsync = 0
    t.window.width = 640
    t.window.height = 360
    t.window.resizable = true
end