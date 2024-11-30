local sti = require "sti"
local itemsData = require('assets/items/items')

local scaleX, scaleY = 1.7, 2
local Zone = {}
Zone.__index = Zone

-- VER DONDE PONER LA INSTANCIACION DE ENEMIGOS
local Soul = require("Soul")
local Draugr = require("Draugr")
local Spirit = require("Spirit")

local enemies = {Soul:new(100, 100), Draugr:new(200, 200), Spirit:new(400, 400)}

function Zone:new(mapFile, world, zoneId, name, connections)
    local obj = setmetatable({}, Zone)
    obj.map = sti(mapFile) -- Carga el mapa desde Tiled
    obj.id = zoneId
    obj.name = name
    obj.colliders = {}
    obj.items = {}
    obj.connections = connections
    obj.isActive = false
    obj.world = world

    return obj
end

function Zone:loadCurrentCollisions()
    if self.map.layers["collisions"] then
        for _, objData in pairs(self.map.layers["collisions"].objects) do
            local collider = self.world:newRectangleCollider(objData.x * scaleX, objData.y * scaleY, objData.width * scaleX,
                objData.height * scaleY)
            collider:setType('static')
            table.insert(self.colliders, collider)
        end
    end
end

function Zone:loadCurrentItems()
    for _, itemData in ipairs(itemsData) do
        table.insert(self.items, {
            data = itemData,
            x = itemData.x,
            y = itemData.y,
            quantity = itemData.quantity,
            effect = itemData.effect,
            sprite = love.graphics.newImage(itemData.sprite) -- Carga el sprite
        })
    end
end

function Zone:clear()
    world:destroy()
end

function Zone:update(dt, player)
    if self.isActive then
        for i = #self.items, 1, -1 do
            local item = self.items[i]
            local distance = math.sqrt((item.x - player.x) ^ 2 + (item.y - player.y) ^ 2)
            if distance < 20 then -- Rango de recogida
                player:addToInventory(item) -- Agrega al inventario
                table.remove(self.items, i) -- Remueve del mapa
            end
        end

        for _, enemy in ipairs(enemies) do
            enemy:update(dt, player)
        end

        -- self:checkConnectionPoint(player)
        -- self:checkConnectionArea(player)
    end
end

function loadItemSprites()
    return {
        [1] = love.graphics.newImage('assets/sprites/potion.png'),
        [2] = love.graphics.newImage('assets/sprites/sanity_elixir.png')
    }
end

function Zone:draw()
    if self.isActive then
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

                love.graphics.draw(item.sprite, item.x - spriteWidth / 2, item.y - spriteHeight / 2, 0, scaleX, scaleY)
            else
                love.graphics.print(item.data.name, item.x, item.y)
            end
        end

        for _, enemy in ipairs(enemies) do
            enemy:draw()
        end
    end
end

function Zone:setActive(active)
    self.isActive = active
end

function checkConnectionPoint(player)
    for _, conn in ipairs(self.connections) do
        if conn.position then
            local dx = math.abs(player.x - conn.position.x)
            local dy = math.abs(player.y - conn.position.y)
            if dx < 10 and dy < 10 then -- Distancia mínima para interactuar
                print("Transición a: " .. conn.toZone)
            end
        end
    end
end

function checkConnectionArea(player)
    for _, conn in ipairs(self.connections) do
        if conn.area then
            if player.x >= conn.area.x1 and player.x <= conn.area.x2 and player.y >= conn.area.y1 and player.y <=
                conn.area.y2 then
                print("Transición a: " .. conn.toZone)
            end
        end
    end
end

return Zone