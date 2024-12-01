ZoneManager = {}
ZoneManager.__index = ZoneManager

local Zone = require('Zone')

function ZoneManager:new(filePath)
    local manager = {
        zones = self:loadZones(filePath),
        currentZone = nil
    } 
    setmetatable(manager, self)
    return manager
end

function ZoneManager:loadZones(filePath)
    local zonesData = require(filePath)
    local parsedZones = {}
    local currentZoneConnections = {}

    for _, zoneData in ipairs(zonesData) do
        table.insert(parsedZones, Zone:new(zoneData.mapFile, zoneData.id, zoneData.name, zoneData.connections))
    end

    return parsedZones
end

function ZoneManager:setCurrentZone(zoneId)
    if self.currentZone then
        self.currentZone:setActive(false)
        --self.currentZone:clear() -- clear current zone collisions and items from world
    end
    self.currentZone = self:getZone(zoneId)
    self.currentZone:setActive(true)
    print(self.currentZone.id)
    self.currentZone:loadCurrentCollisions()
    self.currentZone:loadCurrentItems()
end

function ZoneManager:getZone(zoneId)
    for _, zone in ipairs(self.zones) do
        if zone.id == zoneId then
            return zone
        end
    end
    return nil
end

-- function ZoneManager:getConnections(zoneId)
--     local zone = self:getZone(zoneId)
--     return zone and zone.connections or {}
-- end

function ZoneManager:transitionTo(zoneId, player, entryPoint)
    local targetZone = self:getZone(zoneId)
    if not targetZone then
        print("Error: Zona destino no encontrada: " .. zoneId)
        return
    end
    
    if self.currentZone then
        self.currentZone:clearColliders()
    end
    
    -- este metodo tendria la carga de la nueva zona y cualquier otra logica
    self:setCurrentZone(zoneId)
    print("Transición completada a la zona: " .. zoneId)

    -- para reposicionar al jugador
    if entryPoint then
        player:setPosition(entryPoint)
    end
end

return ZoneManager
