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
    }},
    enemies = {}
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
    }},
    enemies = {}
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
    }},
    enemies = {
        draugr = {
            x = 450,
            y = 300
        }
    }
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
    }, {
        toZone = "zone6",
        area = {
            x1 = 364.5,
            y1 = 250,
            x2 = 384,
            y2 = 290
        },
        entryPoint = {
            x = 100,
            y = 200
        }
    }},
    enemies = {
        soul = {
            x = 450,
            y = 300
        },
        draugr = {
            x = 220,
            y = 120
        }
    }
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
    }},
    enemies = {
        soul = {
            x = 250,
            y = 300
        },
        draugr = {
            x = 430,
            y = 100
        }
    }
}, {
    id = "zone6",
    name = "The Catacombs (ritual)",
    mapFile = "map_catacombs3.lua",
    connections = {{
        toZone = "zone4",
        area = {
            x1 = 15.33,
            y1 = 62,
            x2 = 50.66,
            y2 = 79.33
        },
        entryPoint = {
            x = 520,
            y = 580
        }
    }, {
        toZone = "zone7",
        area = {
            x1 = 498,
            y1 = 96.67,
            x2 = 512,
            y2 = 191.34
        },
        entryPoint = {
            x = 150,
            y = 150
        }
    }},
    enemies = {}
}, {
    id = "zone7",
    name = "The Catacombs (ritual cont.)",
    mapFile = "map_catacombs4.lua",
    connections = {{
        toZone = "zone6",
        area = {
            x1 = 0,
            y1 = 98.67,
            x2 = 16.33,
            y2 = 188.67
        },
        entryPoint = {
            x = 850,
            y = 160
        }
    }, {
        toZone = "zone8",
        area = {
            x1 = 384,
            y1 = 2.50,
            x2 = 420,
            y2 = 21
        },
        entryPoint = {
            x = 150,
            y = 150
        }
    }},
    enemies = {
        soul = {
            x = 450,
            y = 300
        },
        draugr = {
            x = 220,
            y = 120
        }
    }
}, {
    id = "zone8",
    name = "The Catacombs (exit)",
    mapFile = "map_catacombs5.lua",
    connections = {{
        toZone = "zone9",
        area = {
            x1 = 486.67,
            y1 = 102,
            x2 = 511.34,
            y2 = 322
        },
        entryPoint = {
            x = 150,
            y = 150
        }
    }},
    enemies = {
        soul = {
            x = 450,
            y = 300
        },
        draugr = {
            x = 220,
            y = 120
        }
    }
}, {
    id = "zone9",
    name = "The Catacombs (castle garden)",
    mapFile = "map_catacombs6.lua",
    connections = {{
        toZone = "zone10",
        area = {
            x1 = 410.67,
            y1 = 0.33,
            x2 = 468,
            y2 = 31
        },
        entryPoint = {
            x = 800,
            y = 600
        }
    }},
    enemies = {}
}, {
    id = "zone10",
    name = "The Castle (entrance)",
    mapFile = "map_castle.lua",
    connections = {},
    enemies = {}
}}

return zones
