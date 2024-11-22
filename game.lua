local wf = require 'lib/windfield'
local camera = require 'lib/camera'
local scaleX, scaleY = 1.7, 2
local Game = {}
Game.__index = Game

local Zone = require 'Zone'
local PlayableCharacter = require 'PlayableCharacter'

function Game:new()
    local obj = setmetatable({}, Game)
    obj.world = wf.newWorld(0, 0)        -- Mundo físico
    obj.camera = camera()                -- Cámara
    obj.zones = {}                       -- Zonas del mapa
    obj.activeZone = nil                 -- Zona activa
    obj.player = nil                     -- Instancia del jugador
    return obj
end

function Game:load()
    -- Crear jugador
    self.player = PlayableCharacter:new(400, 200, self.world)

    -- Cargar zonas
    self.zones["bosque"] = Zone:new("map_catacombs.lua", self.world)
    self.activeZone = self.zones["bosque"]  -- Establece la zona inicial

    self.heartIcon = love.graphics.newImage('assets/sprites/icons/heart_hp.png')
    self.brainIcon = love.graphics.newImage('assets/sprites/icons/brain_sp.png')

    -- Ajustar cámara al jugador
    self.camera:lookAt(self.player.x, self.player.y)
end

function Game:update(dt)
    self.activeZone:update(dt, self.player)  -- Actualiza la zona activa
    self.player:update(dt, self.camera)  -- Actualiza el jugador
    self.world:update(dt)                -- Actualiza el mundo físico

    self.player.x = self.player.collider:getX()
    self.player.y = self.player.collider:getY()
    
    -- Limit char position inside map
    local mapWidth = self.activeZone.map.width * self.activeZone.map.tilewidth * scaleX
    local mapHeight = self.activeZone.map.height * self.activeZone.map.tileheight * scaleY
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
    local mapWidth = self.activeZone.map.width * self.activeZone.map.tilewidth * scaleX
    local mapHeight = self.activeZone.map.height * self.activeZone.map.tileheight * scaleY
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
    self.activeZone:draw()  -- Dibuja el mapa y objetos de la zona
    self.player:draw()      -- Dibuja al jugador
    self.camera:detach()

    self:drawInventory()
    self:drawStats()
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
        love.graphics.print("[" .. i .."] " .. item.name .. " x" .. item.quantity, inventoryX + 20, itemY + 2) -- Texto desplazado a la derecha del ícono
    end
end

function Game:drawStats()
    -- Coordenadas fijas en la esquina superior derecha
    local margin = 20  -- Espaciado desde los bordes
    local iconSize = 20  -- Tamaño de los íconos

    -- HP
    local xPos = love.graphics.getWidth() - margin - iconSize - 50
    local yPos = margin
    love.graphics.draw(self.heartIcon, xPos, yPos, 0, 0.85, 0.85)
    love.graphics.setColor(1, 1, 1)  -- Blanco para el texto
    love.graphics.print(self.player.health .. "/" .. self.player.maxHealth, xPos + iconSize + 5, yPos)

    -- Sanity
    yPos = yPos + iconSize + margin  -- Espaciado entre los iconos
    love.graphics.draw(self.brainIcon, xPos, yPos, 0, 0.85, 0.85)
    love.graphics.print(self.player.sanity .. "/" .. self.player.maxSanity, xPos + iconSize + 5, yPos)

    love.graphics.setColor(1, 1, 1)
end

return Game
