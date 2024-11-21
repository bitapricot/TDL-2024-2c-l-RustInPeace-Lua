local PlayableCharacter = {}
PlayableCharacter.__index = PlayableCharacter

local anim8 = require "lib/anim8"

function PlayableCharacter:new(x, y, world)
    local obj = setmetatable({}, PlayableCharacter)
    obj.x = x
    obj.y = y
    obj.speed = 25000
    obj.health = 100  -- Inicialización de HP
    obj.sanity = 100  -- Inicialización de Sanity
    obj.maxHealth = 100
    obj.maxSanity = 100
    obj.inventory = {}
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
end

function PlayableCharacter:draw()
    self.anim:draw(self.spriteSheet, self.x, self.y, nil, 4, 4, 6, 9)
end

function PlayableCharacter:addToInventory(item)
    table.insert(self.inventory, item)
    print(item.data.name .. " fue añadido al inventario.")
end

function PlayableCharacter:heal(amount)
    self.health = math.min(self.health + amount, self.maxHealth)  -- Suma HP sin exceder el máximo
end

function PlayableCharacter:restoreSanity(amount)
    self.sanity = math.min(self.sanity + amount, self.maxSanity)  -- Suma Sanity sin exceder el máximo
end

return PlayableCharacter
