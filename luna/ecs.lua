local ecs = {}

local ids = 0

local world = {
    entities = {},
    components = {},
    systems = {
        onLoad = {},
        onUpdate = {},
        onDraw = {}
    },
    onLoad = function(w)
        for id,sys in pairs(w.systems.onLoad) do
            for ent_id,ent in pairs(w.entities) do
                local row = {
                    entity = ent,
                    component = ent.components
                }
                if ent:has(sys.filters) then sys.fn(row) end
            end
        end
    end,
    onUpdate = function (w, dt)
        for id,sys in pairs(w.systems.onUpdate) do
            for ent_id,ent in pairs(w.entities) do
                local row = {
                    entity = ent,
                    component = ent.components
                }
                --print(ent.components)
                if ent:has(sys.filters) then sys.fn(row) end
            end
        end
    end,
    onDraw = function (w)
        for id,sys in pairs(w.systems.onDraw) do
            for ent_id,ent in pairs(w.entities) do
                local row = {
                    entity = ent,
                    component = ent.components
                }
                if ent:has(sys.filters) then sys.fn(row) end
            end
        end
    end,
    update = function(w, dt)
        w:onLoad()
        w:onUpdate(dt)
    end,
    draw = function(w)
        w:onDraw()
    end
}

local system = {
    id = 0,
    fn = function() end,
    filters = {}
}

local component = {
    id = 0
}

local entity = {
    id = ids,
    components = {},
    set = function(e, component, values)
        local comp = e.components[component]
        for key, val in pairs(values) do
            if comp[key] then comp[key] = val end
        end
    end,
    has = function(e, components)
        for _,key in ipairs(components) do
            if not e.components[key] then return false end
        end
        return true
    end
}

function ecs.world()
    return setmetatable({}, {__index=world})
end

function ecs.system(world, id, type, filters, fn)
    local sys = setmetatable({}, {__index=system})
    sys.id = id
    sys.filters = filters
    sys.fn = fn
    world.systems[type][id] = sys
    return sys
end

function ecs.component(world, id, comp)
    local o = setmetatable({}, {__index=comp})
    o.id = id
    world.components[id] = o
    return o
end

function ecs.entity(world, id, components)
    local o = setmetatable({}, {__index=entity})
    o.id = id
    o.components = {}
    for i,key in ipairs(components) do
        local cp = {}
        setmetatable(cp, {__index=world.components[key]})
        o.components[key] = cp
    end

    world.entities[id] = o

    return o
end

function ecs.fps()
    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 15)
end

return ecs