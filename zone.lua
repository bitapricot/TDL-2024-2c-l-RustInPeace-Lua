Zone = {}
Zone.__index = Zone

function Zone:new(name, mapFile)
    local zone = {}
    setmetatable(zone, Zone)
    zone.name = name
    zone.map = sti(mapFile)  -- Carga el mapa específico de la zona
    zone.enemies = {}  -- Lista de enemigos en la zona
    zone.isActive = false  -- Si la zona está activa
    return zone
end

function Zone:update(dt)
    if zone.isActive then
        self.map:update(dt)
        -- Actualizar enemigos acá
    end
end

function Zone:draw()
    if zone.isActive then
        self.map:draw()
        -- Dibujar enemigos acá
    end
end

function Zone:setActive(active)
    self.isActive = active
end
