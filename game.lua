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

    -- Ajustar cámara al jugador
    self.camera:lookAt(self.player.x, self.player.y)
end

function Game:update(dt)
    self.activeZone:update(dt)  -- Actualiza la zona activa
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
end

return Game
