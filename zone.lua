local sti = require "sti"
local scaleX, scaleY = 1.7, 2
local Zone = {}
Zone.__index = Zone

function Zone:new(mapFile, world)
    local obj = setmetatable({}, Zone)
    obj.map = sti(mapFile)               -- Carga el mapa desde Tiled
    obj.colliders = {}                   -- Lista de colisionadores

    -- Crear colisiones basadas en el mapa
    if obj.map.layers["collisions"] then
        for _, objData in pairs(obj.map.layers["collisions"].objects) do
            local collider = world:newRectangleCollider(
                objData.x * scaleX, objData.y * scaleY, objData.width * scaleX, objData.height * scaleY
            )
            collider:setType('static')
            table.insert(obj.colliders, collider)
        end
    end

    return obj
end

function Zone:update(dt)
    -- Aquí se puede manejar lógica adicional específica de la zona
end

function Zone:draw()
    love.graphics.push()
    love.graphics.scale(scaleX, scaleY)
    -- Dibuja capas del mapa
    self.map:drawLayer(self.map.layers['ground'])
    self.map:drawLayer(self.map.layers['walls'])
    self.map:drawLayer(self.map.layers['connections'])
    self.map:drawLayer(self.map.layers['interactions'])
    self.map:drawLayer(self.map.layers['items'])

    love.graphics.pop()
end

function Zone:setActive(active)
    self.isActive = active
end

return Zone
