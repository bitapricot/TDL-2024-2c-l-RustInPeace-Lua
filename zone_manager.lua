ZoneManager = {}
ZoneManager.__index = ZoneManager

function ZoneManager:new(zones)
    local manager = {
        zones = zones or {},
        currentZone = nil
    }
    setmetatable(manager, self)
    return manager
end


function ZoneManager:loadZones(filePath)
    local data = dofile(filePath) -- pcall??
    self.zones = data.zones
end


function ZoneManager:setCurrentZone(zoneId)
    self.currentZone = self:getZone(zoneId)
end


function ZoneManager:getZone(zoneId)
    for _, zone in ipairs(self.zones) do
        if zone.id == zoneId then
            return zone
        end
    end
    return nil
end


function ZoneManager:getConnections(zoneId)
    local zone = self:getZone(zoneId)
    return zone and zone.connections or {}
end


function ZoneManager:transitionTo(zoneId, player, entryPoint)
    local targetZone = self:getZone(zoneId)
    if not targetZone then
        print("Error: Zona destino no encontrada: " .. zoneId)
        return
    end

    -- este metodo tendria la carga de la nueva zona y cualquier otra logica
    self:setCurrentZone(zoneId)
    print("Transición completada a la zona: " .. zoneId)

    -- para reposicionar al jugador
    if entryPoint then
        player.x = entryPoint.x
        player.y = entryPoint.y
    end
end