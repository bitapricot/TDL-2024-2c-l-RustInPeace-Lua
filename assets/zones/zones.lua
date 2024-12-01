zones = { -- PENDIENTE COMPLETAR BIEN LAS COORDENADAS Y LOS MAPAS
{
    id = "zone1",
    name = "Forest",
    mapFile = "map_forest.lua",
    connections = {{
        toZone = "zone2",
        area = {
            x1 = 492,
            y1 = 94.67,
            x2 = 511.33,
            y2 = 144.67
        },
        entryPoint = {
            x = 20,
            y = 300
        }
    }}
}, {
    id = "zone2",
    name = "Forest (bridge)",
    mapFile = "map_forest2.lua",
    connections = {{
        toZone = "zone1",
        area = {
            x1 = 1.33,
            y1 = 94,
            x2 = 10.66,
            y2 = 156.67
        },
        entryPoint = {
            x = 840,
            y = 290
        }
    }, {
        toZone = "zone3",
        area = {
            x1 = 433.33,
            y1 = 305.67,
            x2 = 463.33,
            y2 = 462.34
        },
        entryPoint = {
            x = 800,
            y = 50
        }
    }}
}, {
    id = "zone3",
    name = "Forest (catacombs entrance)",
    mapFile = "map_forest3.lua",
    connections = {{
        toZone = "zone2",
        area = {
            x1 = 434.50,
            y1 = 0.5,
            x2 = 461,
            y2 = 19.5
        },
        entryPoint = {
            x = 800,
            y = 600
        }
    }, {
        toZone = "zone4",
        area = {
            x1 = 107.50,
            y1 = 180.50,
            x2 = 163.50,
            y2 = 200
        },
        entryPoint = {
            x = 760,
            y = 120
        }
    }}
}, {
    id = "zone4",
    name = "The Catacombs (main hall)",
    mapFile = "map_catacombs.lua",
    connections = {{
        toZone = "zone3",
        area = {
            x1 = 411.33,
            y1 = 1.33,
            x2 = 450.33,
            y2 = 31
        },
        entryPoint = {
            x = 200,
            y = 520
        }
    }, {
        toZone = "zone5",
        area = {
            x1 = 508.67,
            y1 = 70,
            x2 = 510.67,
            y2 = 320
        },
        entryPoint = {
            x = 100,
            y = 100
        }
    }}
}, {
    id = "zone5",
    name = "The Catacombs (hall end)",
    mapFile = "map_catacombs2.lua",
    connections = {{
        toZone = "zone4",
        area = {
            x1 = 0.50,
            y1 = 75.27,
            x2 = 10.50,
            y2 = 320.28
        },
        entryPoint = {
            x = 850,
            y = 160
        }
    }}
}}

return zones
