local wf = require 'lib/windfield'
local camera = require 'lib/camera'
-- local scaleX, scaleY = 1.7, 2
local Game = {}
Game.__index = Game

local objectivesData = require('assets/objectives/objectives')
local Objective = require("Objective")
local ZoneManager = require("zone_manager")
local Zone = require 'Zone'
local PlayableCharacter = require 'PlayableCharacter'

world = wf.newWorld(0, 0)
zoneManager = ZoneManager:new('assets/zones/zones') -- static
scaleX = 1.7
scaleY = 2

function Game:new()
    local obj = setmetatable({}, Game)
    obj.camera = camera() -- Cámara
    obj.player = nil -- Instancia del jugador
    obj.objectives = self:loadObjectives()
    return obj
end

function Game:load()
    -- Crear jugador
    self.player = PlayableCharacter:new(400, 200)

    -- self.activeZone = zoneManager:getZone("zone2")
    zoneManager:setCurrentZone("zone1")
    self.heartIcon = love.graphics.newImage('assets/sprites/icons/heart_hp.png')
    self.brainIcon = love.graphics.newImage('assets/sprites/icons/brain_sp.png')

    -- Ajustar cámara al jugador
    self.camera:lookAt(self.player.x, self.player.y)
end

function Game:update(dt)
    if self.player.isDead then
        return
    end

    zoneManager.currentZone:update(dt, self.player) -- Actualiza la zona activa
    self.player:update(dt, self.camera) -- Actualiza el jugador
    world:update(dt) -- Actualiza el mundo físico
    self.player.x = self.player.collider:getX()
    self.player.y = self.player.collider:getY()

    for _, objective in ipairs(self.objectives) do
        objective:update(self.player) -- Verifica si los objetivos se cumplen
    end

    -- Limit char position inside map
    local mapWidth = zoneManager.currentZone.map.width * zoneManager.currentZone.map.tilewidth * scaleX
    local mapHeight = zoneManager.currentZone.map.height * zoneManager.currentZone.map.tileheight * scaleY
    local playerWidth = 12 * scaleX
    local playerHeight = 18 * scaleY

    -- Limit x axis
    if self.player.x < playerWidth / 2 then
        self.player.collider:setX(playerWidth / 2)
    elseif self.player.x > mapWidth - playerWidth / 2 then
        self.player.collider:setX(mapWidth - playerWidth / 2)
    end

    -- Limit y axis
    if self.player.y < playerHeight / 2 then
        self.player.collider:setY(playerHeight / 2)
    elseif self.player.y > mapHeight - playerHeight / 2 then
        self.player.collider:setY(mapHeight - playerHeight / 2)
    end

    -- Ajustar la cámara al jugador
    self.camera:lookAt(self.player.x, self.player.y)

    -- Limitar la cámara al tamaño del mapa
    local mapWidth = zoneManager.currentZone.map.width * zoneManager.currentZone.map.tilewidth * scaleX
    local mapHeight = zoneManager.currentZone.map.height * zoneManager.currentZone.map.tileheight * scaleY
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Limitar posición de la cámara en el eje X
    if self.camera.x < screenWidth / 2 then
        self.camera.x = screenWidth / 2
    elseif self.camera.x > mapWidth - screenWidth / 2 then
        self.camera.x = mapWidth - screenWidth / 2
    end

    -- Limitar posición de la cámara en el eje Y
    if self.camera.y < screenHeight / 2 then
        self.camera.y = screenHeight / 2
    elseif self.camera.y > mapHeight - screenHeight / 2 then
        self.camera.y = mapHeight - screenHeight / 2
    end
end

function Game:draw()
    self.camera:attach()
    zoneManager.currentZone:draw() -- Dibuja el mapa y objetos de la zona
    self.player:draw() -- Dibuja al jugador
    self.camera:detach()

    self:drawInventory()
    self:drawStats()
    self:drawObjectives()

    if self.player.isDead then
        self:drawImportantMessage("¡Has muerto!")
    end

    if self:objectivesCompleted() then
        self:drawImportantMessage("¡Has escapado del Espíritu Vengativo!")
    end

end

function Game:drawImportantMessage(message)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    
    love.graphics.setColor(0, 0, 0, 0.6) -- Negro con opacidad (0.6)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight) -- Rectángulo cubriendo toda la pantalla

    local barHeight = 50
    local barY = (screenHeight / 2) - (barHeight / 2)

    love.graphics.setColor(1, 0, 0, 0.8)
    love.graphics.rectangle("fill", 0, barY, screenWidth, barHeight)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(message, 0, barY + 10, screenWidth, "center")

    love.graphics.setColor(1, 1, 1)
end

function Game:drawInventory()
    local inventoryX, inventoryY = 20, 20
    local width, height = 200, (#self.player.inventory + 1) * 25

    -- Fondo semi-transparente para el inventario
    love.graphics.setColor(0, 0, 0, 0.5) -- Negro con transparencia
    love.graphics.rectangle("fill", inventoryX - 2, inventoryY - 2, width, height)
    love.graphics.setColor(1, 1, 1) -- Blanco para el texto

    -- Texto del título del inventario
    love.graphics.print("Inventario:", inventoryX, inventoryY)

    -- Dibujar los ítems en el inventario
    for i, item in ipairs(self.player.inventory:getItems()) do
        local itemY = inventoryY + (i * 25) -- Espaciado entre ítems

        -- Dibujar el ícono del ítem si tiene sprite
        if item.sprite then
            love.graphics.draw(item.sprite, inventoryX, itemY)
        end

        -- La idea seria mostrar los items asi:
        -- "Nombre x{quantity} [{key_binding}]"
        love.graphics.print("[" .. i .. "] " .. item.name .. " x" .. item.quantity, inventoryX + 20, itemY + 2) -- Texto desplazado a la derecha del ícono
    end
end

function Game:drawStats()
    -- Coordenadas fijas en la esquina superior derecha
    local margin = 20 -- Espaciado desde los bordes
    local iconSize = 20 -- Tamaño de los íconos

    -- HP
    local xPos = love.graphics.getWidth() - margin - iconSize - 50
    local yPos = margin
    love.graphics.draw(self.heartIcon, xPos, yPos, 0, 0.85, 0.85)
    love.graphics.setColor(1, 1, 1) -- Blanco para el texto
    love.graphics.print(self.player.health .. "/" .. self.player.maxHealth, xPos + iconSize + 5, yPos)

    -- Sanity
    yPos = yPos + iconSize + margin -- Espaciado entre los iconos
    love.graphics.draw(self.brainIcon, xPos, yPos, 0, 0.85, 0.85)
    love.graphics.print(self.player.sanity .. "/" .. self.player.maxSanity, xPos + iconSize + 5, yPos)

    love.graphics.setColor(1, 1, 1)
end

function Game:loadObjectives()
    local parsedObjectives = {}

    for _, objectiveData in ipairs(objectivesData) do
        local objective = Objective:new(objectiveData.description, objectiveData.condition, objectiveData.onCompletion,
            {})
        table.insert(parsedObjectives, objective)
    end

    return parsedObjectives
end

function Game:drawObjectives()
    local startX, startY = 10, 500 -- Posición inicial para dibujar los objetivos
    local lineHeight = 30 -- Espacio entre cada línea de texto

    for _, objective in ipairs(self.objectives) do
        if not objective.isCompleted then
            love.graphics.print(objective.description, startX, startY)
            startY = startY + lineHeight
        end
    end
end

function Game:objectivesCompleted()
    for _, objective in ipairs(self.objectives) do
        if not objective.isCompleted then
            return false
        end
    end

    return true
end

return Game
