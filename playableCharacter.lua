local PlayableCharacter = {}
PlayableCharacter.__index = PlayableCharacter

local anim8 = require "lib/anim8"

local Item = require "item"
local Inventory = require "inventory"

function PlayableCharacter:new(x, y)
    local obj = setmetatable({}, PlayableCharacter)
    obj.x = x
    obj.y = y
    obj.speed = 25000
    obj.health = 50  -- Inicialización de HP
    obj.sanity = 50  -- Inicialización de Sanity
    obj.maxHealth = 100
    obj.maxSanity = 100
    obj.inventory = Inventory:new()
    obj.isDead = false
    obj.spriteSheet = love.graphics.newImage('assets/sprites/player-sheet.png')
    obj.grid = anim8.newGrid(12, 18, obj.spriteSheet:getWidth(), obj.spriteSheet:getHeight())
    obj.animations = {
        down = anim8.newAnimation(obj.grid('1-4', 1), 0.2),
        left = anim8.newAnimation(obj.grid('1-4', 2), 0.2),
        right = anim8.newAnimation(obj.grid('1-4', 3), 0.2),
        up = anim8.newAnimation(obj.grid('1-4', 4), 0.2)
    }
    obj.anim = obj.animations.down

    -- Collider
    obj.collider = world:newBSGRectangleCollider(x, y, 20, 30, 10)
    obj.collider:setFixedRotation(true)

    return obj
end

function PlayableCharacter:update(dt, camera)
    local vx, vy = 0, 0
    local isMoving = false

    -- Movimiento básico
    if love.keyboard.isDown("right") then
        vx = self.speed * dt
        self.anim = self.animations.right
        isMoving = true
    end
    if love.keyboard.isDown("left") then
        vx = -self.speed * dt
        self.anim = self.animations.left
        isMoving = true
    end
    if love.keyboard.isDown("down") then
        vy = self.speed * dt
        self.anim = self.animations.down
        isMoving = true
    end
    if love.keyboard.isDown("up") then
        vy = -self.speed * dt
        self.anim = self.animations.up
        isMoving = true
    end

    self.collider:setLinearVelocity(vx, vy)
    self.x, self.y = self.collider:getX(), self.collider:getY()

    if not isMoving then self.anim:gotoFrame(2) end
    self.anim:update(dt)

    -- Ajustar cámara
    camera:lookAt(self.x, self.y)

    -- self:checkUseItemKeys()
end

function PlayableCharacter:checkUseItemKeys()
    for i = 1, 9 do
        if love.keyboard.isDown(tostring(i)) then
            -- Usar el ítem correspondiente al índice de la tecla
            self:useItemByIndex(i)
            break  -- Evitar manejar múltiples teclas al mismo tiempo
        end
    end
end

function PlayableCharacter:draw()
    self.anim:draw(self.spriteSheet, self.x, self.y, nil, 4, 4, 6, 9)
end

function PlayableCharacter:addToInventory(item)
    self.inventory:addItem(item)
end

function PlayableCharacter:heal(amount)
    self.health = math.min(self.health + amount, self.maxHealth)  -- Suma HP sin exceder el máximo
end

function PlayableCharacter:restoreSanity(amount)
    self.sanity = math.min(self.sanity + amount, self.maxSanity)  -- Suma Sanity sin exceder el máximo
end

function PlayableCharacter:useItemByIndex(index)
    self.inventory:useItem(index, self)
end

function PlayableCharacter:takeDamage(amount)
    -- Reducir la salud del personaje
    local updatedHealth = self.health - amount
    if updatedHealth < 0 then updatedHealth = 0 end
    self.health = updatedHealth

    -- Imprimir mensaje en consola
    print("¡Has recibido " .. amount .. " de daño! Salud actual: " .. self.health .. "/" .. self.maxHealth)

    -- Verificar si la salud llega a 0 o menos
    if self.health <= 0 then
        self:die()
    end
end

function PlayableCharacter:die()
    -- Lógica para cuando el personaje muere
    print("El personaje ha muerto.")
    -- Aquí podrías reiniciar el nivel, mostrar una pantalla de "Game Over", etc.
end

function PlayableCharacter:setPosition(entryPoint)
    -- Actualizar posición del collider
    self.collider:setPosition(entryPoint.x, entryPoint.y)

    -- Sincronizar la posición del personaje con el collider
    self.x = self.collider:getX()
    self.y = self.collider:getY()
end

function PlayableCharacter:isNearCorpse()
    -- Coordenadas del cadáver
    local corpseX, corpseY = 259.82 * scaleX, 238.55 * scaleY
    
    local proximityRange = 50  -- Rango de proximidad de 50 píxeles

    local distance = math.sqrt((self.x - corpseX)^2 + (self.y - corpseY)^2)

    if distance <= proximityRange then
        if love.keyboard.isDown("e") then
            return true
        end
    end

    return false
end

function PlayableCharacter:die()
    self.isDead = true
    print("El personaje ha muerto.")
end

return PlayableCharacter
