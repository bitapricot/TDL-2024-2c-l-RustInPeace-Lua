local Enemy = require("Enemy")

local Draugr = {}
Draugr.__index = Draugr
setmetatable(Draugr, { __index = require("Enemy") }) -- Hereda de Enemy

local spriteSheet = love.graphics.newImage("assets/sprites/enemies.png")
local totalColumns, totalRows = 12, 8
local spriteWidth = spriteSheet:getWidth() / totalColumns
local spriteHeight = spriteSheet:getHeight() / totalRows

local draugrAnimations = {
    down = {},
    up = {}
}

for col = 3, 5 do
    table.insert(draugrAnimations.down, love.graphics.newQuad(
        col * spriteWidth, 4 * spriteHeight, spriteWidth, spriteHeight, spriteSheet:getDimensions()
    ))
end

-- Animación hacia arriba (fila 7)
for col = 3, 5 do
    table.insert(draugrAnimations.up, love.graphics.newQuad(
        col * spriteWidth, 7 * spriteHeight, spriteWidth, spriteHeight, spriteSheet:getDimensions()
    ))
end

function Draugr:new(x, y)
    local draugr = Enemy:new(x, y, 100, 1)
    draugr.health = 50
    draugr.state = "down"
    draugr.spriteIndex = 1
    draugr.animationTimer = 0
    draugr.attackCooldown = 0
    draugr.attackCooldownTime = 0.5
    draugr.animationSpeed = 0.2
    draugr.flashTimer = 0  -- Temporizador para el efecto visual
    draugr.flashDuration = 0.2  -- Duración del efecto visual
    setmetatable(draugr, Draugr)
    return draugr
end

function Draugr:takeDamage(amount)
    self.health = self.health - amount
    print("Draugr recibió " .. amount .. " de daño. Salud restante: " .. self.health)
    if self.health <= 0 then
        print("Draugr ha sido derrotado.")
    end
end

function Draugr:update(dt, player)
    -- Actualiza el temporizador de animación
    self.animationTimer = self.animationTimer + dt
    if self.animationTimer >= self.animationSpeed then
        self.spriteIndex = self.spriteIndex + 1
        self.animationTimer = 0

        local animation = draugrAnimations[self.state]
        if self.spriteIndex > #animation then
            self.spriteIndex = 1
        end
    end

    -- Mueve al Draugr hacia el jugador
    self:moveTowardsPlayer(dt, player)

    -- Si está cerca del jugador y el cooldown ha pasado, ataca
    self:attackPlayerIfClose(dt, player)

    -- Control del efecto visual de daño (si está activo)
    if self.flashTimer > 0 then
        self.flashTimer = self.flashTimer - dt
    end
end

function Draugr:moveTowardsPlayer(dt, player)
    local dx, dy = player.x - self.x, player.y - self.y
    local distance = math.sqrt(dx^2 + dy^2)
    if distance > 1 then
        self.x = self.x + (dx / distance) * self.speed * dt
        self.y = self.y + (dy / distance) * self.speed * dt

        if dy > 0 then
            self.state = "down" 
        elseif dy < 0 then
            self.state = "up"
        end
    else
        self.state = "down"
    end
end

function Draugr:attackPlayerIfClose(dt, player)
    local dx, dy = player.x - self.x, player.y - self.y
    local distance = math.sqrt(dx^2 + dy^2)

    if distance < 30 then
        if self.attackCooldown <= 0 then
            player:takeDamage(self.damage)
            print("El Draugr ha atacado al jugador y le ha hecho " .. self.damage .. " de daño.")
            self.attackCooldown = self.attackCooldownTime -- Reinicia el cooldown

            -- Activar el efecto visual de daño
            self.flashTimer = self.flashDuration
        end
    end

    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
end

function Draugr:draw()
    local animation = draugrAnimations[self.state]
    local quad = animation[self.spriteIndex]

    love.graphics.draw(spriteSheet, quad, self.x, self.y, 0, 1, 1, spriteWidth / 2, spriteHeight / 2)

    -- Dibuja el efecto de flash si está activo
    if self.flashTimer > 0 then
        love.graphics.setColor(1, 0, 0, 0.3)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth() * scaleX, love.graphics.getHeight() * scaleY)  -- Dibuja el rectángulo sobre toda la pantalla
        love.graphics.setColor(1, 1, 1, 1)  -- Vuelve al color normal
    end
end

return Draugr
