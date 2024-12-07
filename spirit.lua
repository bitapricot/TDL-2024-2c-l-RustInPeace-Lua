local anim8 = require 'lib/anim8'

local Enemy = require("Enemy")

local Spirit = {}
Spirit.__index = Spirit
setmetatable(Spirit, {
    __index = require("Enemy")
}) -- Hereda de Enemy

local spriteSheet = love.graphics.newImage("assets/sprites/enemies.png")
local spriteWidth = spriteSheet:getWidth() / 12 -- Total de columnas en el sprite sheet
local spriteHeight = spriteSheet:getHeight() / 8 -- Total de filas en el sprite sheet

-- Crear las animaciones del Spirit
local spiritAnimations = {
    down = {},
    up = {}
}

for col = 9, 11 do
    table.insert(spiritAnimations.down, love.graphics
        .newQuad(col * spriteWidth, 4 * spriteHeight, spriteWidth, spriteHeight, spriteSheet:getDimensions()))
end

for col = 9, 11 do
    table.insert(spiritAnimations.up, love.graphics
        .newQuad(col * spriteWidth, 7 * spriteHeight, spriteWidth, spriteHeight, spriteSheet:getDimensions()))
end

function Spirit:new(x, y)
    local spirit = Enemy:new(x, y, 200, 20) -- Velocidad moderada, poco daño
    spirit.state = "chasing" -- Estado inicial
    spirit.spriteIndex = 1
    spirit.animationTimer = 0
    spirit.animationSpeed = 0.2
    spirit.currentAnimation = "down" -- Animación inicial
    spirit.attackCooldown = 0.8 -- Tiempo de espera entre ataques
    spirit.attackTimer = 0 -- Contador para el cooldown
    spirit.attackEffectActive = false -- Controla el efecto de pantalla roja
    spirit.attackEffectTimer = 0 -- Temporizador para el efecto de daño
    spirit.attackEffectDuration = 0.3 -- Duración del efecto de pantalla roja
    setmetatable(spirit, Spirit)

    return spirit
end

function Spirit:update(dt, player)
    if self.state == "defeated" then return end
    if self.attackTimer > 0 then
        self.attackTimer = self.attackTimer - dt
    end

    local dx, dy = player.x - self.x, player.y - self.y
    local angle = math.atan2(dy, dx)
    self.x = self.x + math.cos(angle) * self.speed * dt
    self.y = self.y + math.sin(angle) * self.speed * dt

    if math.abs(dy) > math.abs(dx) then
        self.currentAnimation = (dy > 0) and "down" or "up"
    end

    -- Ataque si está cerca y el cooldown lo permite
    if math.sqrt(dx * dx + dy * dy) < 30 and self.attackTimer <= 0 then
        self.state = "attacking"
        player:takeDamage(self.damage)
        self.attackTimer = self.attackCooldown

        self.attackEffectActive = true
        self.attackEffectTimer = self.attackEffectDuration
    end

    self.animationTimer = self.animationTimer + dt
    if self.animationTimer >= self.animationSpeed then
        self.spriteIndex = self.spriteIndex + 1
        self.animationTimer = 0

        local animation = spiritAnimations[self.currentAnimation]
        if self.spriteIndex > #animation then
            self.spriteIndex = 1
        end
    end

    if self.attackEffectActive then
        self.attackEffectTimer = self.attackEffectTimer - dt
        if self.attackEffectTimer <= 0 then
            self.attackEffectActive = false
        end
    end
end

function Spirit:draw()
    if self.state == "defeated" then
        return
    end

    love.graphics.setColor(1, 1, 1, 1) -- Opacidad completa
    local animation = spiritAnimations[self.currentAnimation]
    local quad = animation[self.spriteIndex]
    love.graphics.draw(spriteSheet, quad, self.x, self.y, 0, 1, 1, spriteWidth / 2, spriteHeight / 2)

    if self.attackEffectActive then
        love.graphics.setColor(1, 0, 0, 0.3)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth() * scaleX, love.graphics.getHeight() * scaleY)  -- Dibuja el rectángulo sobre toda la pantalla
    end
end

function Spirit:stopChasing()
    self.state = "defeated"
    print("El Espíritu Vengativo ha dejado de perseguirte.")
end

return Spirit
