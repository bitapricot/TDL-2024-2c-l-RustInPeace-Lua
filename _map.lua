Map = {}
Map.__index = Map

function Map:new(filename, world, scaleX, scaleY)
    local map = {}
    setmetatable(map, Map)
    map.tiledMap = sti(filename)
    map.collisions = {}

    -- Cargar colisiones
    if map.tiledMap.layers["collisions"] then
        for _, obj in ipairs(map.tiledMap.layers["collisions"].objects) do
            local collision = world:newRectangleCollider(
                obj.x * scaleX, obj.y * scaleY, obj.width * scaleX, obj.height * scaleY
            )
            collision:setType("static")
            table.insert(map.collisions, collision)
        end
    end

    return map
end

function Map:draw(layers)
    for _, layerName in ipairs(layers) do
        self.tiledMap:drawLayer(self.tiledMap.layers[layerName])
    end
end
