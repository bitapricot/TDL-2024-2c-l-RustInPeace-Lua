local sti = require "sti"
local itemsData = require('assets/items/items')
local EnemyFactory = require("EnemyFactory")

local scaleX, scaleY = 1.7, 2
local Zone = {}
Zone.__index = Zone

function Zone:new(mapFile, zoneId, name, connections, enemyDefinitions)
    local obj = setmetatable({}, Zone)
    obj.map = sti(mapFile) -- Carga el mapa desde Tiled
    obj.id = zoneId
    obj.name = name
    obj.colliders = {}
    obj.items = {}
    obj.connections = {}
    obj.isActive = false
    obj.entryPoint = {}
    obj.enemies = Zone:loadCurrentEnemies(enemyDefinitions)

    -- Escalar las conexiones
    if connections then
        for _, connection in ipairs(connections) do
            local scaledConnection = {
                toZone = connection.toZone
            }

            print(scaledConnection)

            -- Escalar posición, si existe
            if connection.position then
                scaledConnection.position = {
                    x = connection.position.x * scaleX,
                    y = connection.position.y * scaleY
                }
            end

            -- Escalar área, si existe
            if connection.area then
                scaledConnection.area = {
                    x1 = connection.area.x1 * scaleX,
                    y1 = connection.area.y1 * scaleY,
                    x2 = connection.area.x2 * scaleX,
                    y2 = connection.area.y2 * scaleY
                }
            end

            if connection.entryPoint then
                scaledConnection.entryPoint = connection.entryPoint
            end

            table.insert(obj.connections, scaledConnection)
        end
    end

    return obj
end

function Zone:loadCurrentEnemies(enemyDefinitions)
    local enemies = {}
    for type, position in pairs(enemyDefinitions) do
        local enemy = EnemyFactory.createEnemy(type, position.x, position.y)
        table.insert(enemies, enemy)
        print("Spawnea enemigo de tipo " .. type .. " en la zona")
    end
    
    return enemies
end

function Zone:updateEnemies(dt, player)
    for _, enemy in ipairs(self.enemies) do
        enemy:update(dt, player)
    end
end

function Zone:drawEnemies()
    for _, enemy in ipairs(self.enemies) do
        enemy:draw()
    end
end

function Zone:loadCurrentCollisions()
    if self.map.layers["collisions"] then
        for _, objData in pairs(self.map.layers["collisions"].objects) do
            local collider = world:newRectangleCollider(objData.x * scaleX, objData.y * scaleY, objData.width * scaleX,
                objData.height * scaleY)
            collider:setType('static')
            table.insert(self.colliders, collider)
        end
    end
end

function Zone:loadCurrentItems()
    for _, itemData in ipairs(itemsData) do
        if itemData.zoneId == self.id then
            if self:hasItem(itemData.name) then break end
            table.insert(self.items, {
                data = itemData,
                x = itemData.x,
                y = itemData.y,
                quantity = itemData.quantity,
                effect = itemData.effect,
                img = itemData.sprite,
                sprite = love.graphics.newImage(itemData.sprite), -- Carga el sprite
                grabbed = false
            })
        end
    end
end

function Zone:hasItem(name)
    for _, item in ipairs(self.items) do
        if item.data.name == name then
            return true
        end
    end
    return false
end


function Zone:clear()
    world:destroy()
end

function Zone:update(dt, player)
    if self.isActive then
        for i = #self.items, 1, -1 do
            local item = self.items[i]
            local distance = math.sqrt((item.x - player.x) ^ 2 + (item.y - player.y) ^ 2)
            if distance < 20 and not item.grabbed then -- Rango de recogida
                player:addToInventory(item) -- Agrega al inventario
                -- table.remove(self.items, i) -- Remueve del mapa
                item.grabbed = true
            end
        end

        for _, enemy in ipairs(self.enemies) do
            enemy:update(dt, player)
        end

        -- self:checkConnectionPoint(player)
        self:checkConnectionArea(player)
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
        self.map:drawLayer(self.map.layers['interactions'])
        self.map:drawLayer(self.map.layers['connections'])
        -- self.map:drawLayer(self.map.layers['items'])

        love.graphics.pop()

        for _, item in ipairs(self.items) do
            if item.sprite and not item.grabbed then
                local spriteWidth = item.sprite:getWidth() * scaleX
                local spriteHeight = item.sprite:getHeight() * scaleY

                love.graphics.draw(item.sprite, item.x - spriteWidth / 2, item.y - spriteHeight / 2, 0, scaleX, scaleY)
            -- else
                -- love.graphics.print(item.data.name, item.x, item.y)
            end
        end

        for _, enemy in ipairs(self.enemies) do
            enemy:draw()
        end
    end
end

function Zone:setActive(active)
    self.isActive = active
end

function Zone:checkConnectionPoint(player)
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

function Zone:clearColliders()
    for _, collider in ipairs(self.colliders) do
        collider:destroy() -- Destruye el collider del mundo
    end
    self.colliders = {} -- Vacía la lista de colliders
end

function Zone:checkConnectionArea(player)
    for _, conn in ipairs(self.connections) do
        if conn.area then
            if player.x >= conn.area.x1 and player.x <= conn.area.x2 and player.y >= conn.area.y1 and player.y <=
                conn.area.y2 then
                print("Transición a: " .. conn.toZone)
                print(conn.entryPoint.x)
                print(conn.entryPoint.y)
                zoneManager:transitionTo(conn.toZone, player, conn.entryPoint)
            end
        end
    end
end

return Zone
