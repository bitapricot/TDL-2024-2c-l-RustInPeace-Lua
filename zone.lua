local sti = require "sti"
local itemsData = require('assets/items/items')

local scaleX, scaleY = 1.7, 2
local Zone = {}
Zone.__index = Zone

function Zone:new(mapFile, world)
    local obj = setmetatable({}, Zone)
    obj.map = sti(mapFile)               -- Carga el mapa desde Tiled
    obj.colliders = {}                   
    obj.items = {}

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

    -- Cargar ítems para la zona actual
     for _, itemData in ipairs(itemsData) do
        -- if itemData.zone == zoneId and itemData.chapter == chapter then
            table.insert(obj.items, {
                data = itemData,
                x = itemData.x,
                y = itemData.y,
                sprite = love.graphics.newImage(itemData.sprite)  -- Carga el sprite
            })
        -- end
    end

    return obj
end

function Zone:update(dt, player)
   for i = #self.items, 1, -1 do
        local item = self.items[i]
        local distance = math.sqrt((item.x - player.x)^2 + (item.y - player.y)^2)
        if distance < 20 then -- Rango de recogida
            player:addToInventory(item) -- Agrega al inventario
            table.remove(self.items, i) -- Remueve del mapa
        end
    end
end

function loadItemSprites()
    return {
        [1] = love.graphics.newImage('assets/sprites/potion.png'),
        [2] = love.graphics.newImage('assets/sprites/sanity_elixir.png')
    }
end


function Zone:draw()
    love.graphics.push()
    love.graphics.scale(scaleX, scaleY)

    self.map:drawLayer(self.map.layers['ground'])
    self.map:drawLayer(self.map.layers['walls'])
    self.map:drawLayer(self.map.layers['connections'])
    self.map:drawLayer(self.map.layers['interactions'])
    -- self.map:drawLayer(self.map.layers['items'])

    love.graphics.pop()

    for _, item in ipairs(self.items) do
        if item.sprite then
            local spriteWidth = item.sprite:getWidth() * scaleX
            local spriteHeight = item.sprite:getHeight() * scaleY

            love.graphics.draw(
                item.sprite,
                item.x - spriteWidth / 2,
                item.y - spriteHeight / 2,
                0,
                scaleX,
                scaleY
            )
        else
            love.graphics.print(item.data.name, item.x, item.y)
        end
    end
end

function Zone:setActive(active)
    self.isActive = active
end

return Zone
