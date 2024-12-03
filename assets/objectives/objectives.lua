local objectivesData = {{
    id = "collectOfferings",
    description = "Recoger la ofrenda", -- Este item requiere que pongamos alguno con el id "offering" en el map_catacombs3
    condition = function(player)
        return player.inventory:hasItem("Offering")
    end,
    onCompletion = function(player)
        print("¡Has recogido la ofrenda!")
        -- Aca se revelaria la zona de map_catacombs2 (escaleras abajo)
    end
}, {
    id = "offerToCorpse",
    description = "Dar ofrenda al cadáver",
    condition = function(player)
        return player.inventory:hasItem("Offering") and player:isNearCorpse() -- supongo que comparamos por coordenadas?
    end,
    onCompletion = function(player)
        print("¡Has dado la ofrenda al cadáver!")
        zoneManager:spawnSpirit()
    end
}, {
    id = "escapeSpirit",
    description = "Escapar del espíritu vengativo",
    condition = function(player)
        return zoneManager.currentZone.id == "zone10"
    end,
    onCompletion = function(player)
        print("¡Has escapado del Espíritu Vengativo!")

        for _, enemy in ipairs(zoneManager.globalEnemies) do
            enemy:stopChasing() -- Cambiamos su estado para que deje de perseguir
        end
    end
}}

return objectivesData
