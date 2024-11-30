zones = { -- PENDIENTE COMPLETAR BIEN LAS COORDENADAS Y LOS MAPAS
    -- {
    --     id = "zone1",
    --     name = "Cursed Forest",
    --     mapFile = "map_catacombs.lua",
    --     connections = {
    --         { toZone = "zone2", type = "door", position = { x = 500, y = 300 } }, -- Puerta de entrada a las catacombs
    --     }
    -- },
    {
        id = "zone2",
        name = "The Catacombs (main hall)",
        mapFile = "map_catacombs.lua",
        connections = {
            { toZone = "zone1", position = { x = 50, y = 300 } }, -- Puerta de vuelta al forest
            { toZone = "zone3", area = { x1 = 800, y1 = 0, x2 = 900, y2 = 600 } }, -- pasillo final de las catacombs
            { toZone = "zone4", position = { x = 50, y = 300 } }, -- downstairs

        }
    },
    {
        id = "zone3",
        name = "The Catacombs (hall end)",
        mapFile = "map_catacombs2.lua",
        connections = {
            { toZone = "zone2", area = { x1 = 800, y1 = 0, x2 = 900, y2 = 600 } } -- vuelta al pasillo central de las catacombs
        }
    },
    -- {
    --     id = "zone4",
    --     name = "The Catacombs (downstairs)",
    --     mapFile = "map_catacombs.lua",
    --     connections = {
    --         { toZone = "zone2", position = { x = 50, y = 300 } }, -- vuelta al pasillo central de las catacombs
    --         { toZone = "zone5", position = { x = 50, y = 300 } }, -- entrada al castillo (subterraneo ??)
    --     }
    -- },
    -- {
    --     id = "zone5",
    --     name = "The Castle",
    --     mapFile = "map_catacombs.lua",
    --     connections = {
    --         -- dead end
    --     }
    -- }
}

return zones