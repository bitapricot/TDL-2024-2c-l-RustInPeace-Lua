ZoneManager = {}
ZoneManager.__index = ZoneManager

local Zone = require('Zone')
local Spirit = require('Spirit')

function ZoneManager:new(filePath)
    local manager = {
        zones = self:loadZones(filePath),
        currentZone = nil,
        globalEnemies = {}  -- Lista global de enemigos (no se destruyen al cambiar de zona)
        -- Tener en cuenta que en esta demo solo contiene al espiritu vengativo
    } 
    setmetatable(manager, self)
    return manager
end

function ZoneManager:loadZones(filePath)
    local zonesData = require(filePath)
    local parsedZones = {}
    local currentZoneConnections = {}

    for _, zoneData in ipairs(zonesData) do
        table.insert(parsedZones, Zone:new(zoneData.mapFile, zoneData.id, zoneData.name, zoneData.connections, zoneData.enemies))
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

    -- Traer los enemigos globales a la zona activa
    for _, enemy in ipairs(self.globalEnemies) do
        table.insert(self.currentZone.enemies, enemy)
    end
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

function ZoneManager:addEnemy(enemy)
    table.insert(self.globalEnemies, enemy)
end

function ZoneManager:spawnSpirit()
    -- Coordenadas de aparición del Spirit
    local spawnX, spawnY = 240 * scaleX, 75 * scaleY

    local spirit = Spirit:new(spawnX, spawnY)

    -- Agregar al registro global de enemigos
    self:addEnemy(spirit)

    -- Agregar el Spirit a la zona actual
    table.insert(self.currentZone.enemies, spirit)

    print("¡El Espíritu Vengativo ha aparecido en la zona!")
end


return ZoneManager
