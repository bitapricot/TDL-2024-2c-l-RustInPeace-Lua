local Enemy = require("Enemy")

local Soul = {}
Soul.__index = Soul
setmetatable(Soul, { __index = require("Enemy") }) -- Hereda de Enemy

local spriteSheet = love.graphics.newImage("assets/sprites/enemies.png")
local totalColumns, totalRows = 12, 8
local spriteWidth = spriteSheet:getWidth() / totalColumns
local spriteHeight = spriteSheet:getHeight() / totalRows

-- Animaciones para Soul
local soulAnimations = {
    down = {},
    up = {}
}

for col = 6, 8 do
    table.insert(soulAnimations.down, love.graphics.newQuad(
        col * spriteWidth, 4 * spriteHeight, spriteWidth, spriteHeight, spriteSheet:getDimensions()
    ))
end

for col = 6, 8 do
    table.insert(soulAnimations.up, love.graphics.newQuad(
        col * spriteWidth, 7 * spriteHeight, spriteWidth, spriteHeight, spriteSheet:getDimensions()
    ))
end

function Soul:new(x, y)
    local soul = Enemy:new(x, y, 50, 5) -- Velocidad lenta, daño bajo
    soul.health = 30
    soul.state = "down" -- Estado inicial, mirando hacia abajo
    soul.spriteIndex = 1
    soul.animationTimer = 0 -- Tiempo acumulado para animación
    soul.animationSpeed = 0.3 -- Velocidad de cambio de sprite (más lenta que Draugr)
    soul.attackCooldown = 0 -- Tiempo de cooldown del ataque
    soul.attackCooldownTime = 1.5 -- Tiempo de cooldown entre ataques (ajústalo como desees)
    soul.flashTimer = 0 -- Temporizador para el efecto visual de daño
    soul.flashDuration = 0.2 -- Duración del efecto visual de daño (en segundos)
    setmetatable(soul, Soul)
    return soul
end

function Soul:update(dt, player)
    -- Lógica de animación
    self.animationTimer = self.animationTimer + dt
    if self.animationTimer >= self.animationSpeed then
        self.spriteIndex = self.spriteIndex + 1
        self.animationTimer = 0

        -- Reiniciar el índice si sobrepasa el rango de sprites del estado actual
        local animation = soulAnimations[self.state]
        if self.spriteIndex > #animation then
            self.spriteIndex = 1
        end
    end

    -- Comportamiento del enemigo: seguimiento lento al jugador
    self:moveTowardsPlayer(dt, player)

    -- Ataque con cooldown
    self:attackPlayerIfClose(dt, player)

    -- Control del efecto visual de daño (si está activo)
    if self.flashTimer > 0 then
        self.flashTimer = self.flashTimer - dt
    end
end

function Soul:moveTowardsPlayer(dt, player)
    -- Calcular la distancia y dirección al jugador
    local dx, dy = player.x - self.x, player.y - self.y
    local distance = math.sqrt(dx^2 + dy^2)
    if distance > 1 then
        -- Normalizar dirección y mover
        self.x = self.x + (dx / distance) * self.speed * dt
        self.y = self.y + (dy / distance) * self.speed * dt

        -- Actualizar el estado según el movimiento vertical
        if dy > 0 then
            self.state = "down" -- Moviéndose hacia abajo
        elseif dy < 0 then
            self.state = "up" -- Moviéndose hacia arriba
        end
    else
        self.state = "down" -- Default a "mirar hacia abajo" cuando está quieto
    end
end

function Soul:attackPlayerIfClose(dt, player)
    -- Calcula la distancia al jugador
    local dx, dy = player.x - self.x, player.y - self.y
    local distance = math.sqrt(dx^2 + dy^2)

    -- Si está lo suficientemente cerca y ha pasado el tiempo de cooldown, ataca
    if distance < 30 then -- Distancia de ataque
        -- Si el cooldown ha pasado, ataca
        if self.attackCooldown <= 0 then
            player:takeDamage(self.damage)
            print("El Soul ha atacado al jugador y le ha hecho " .. self.damage .. " de daño.")
            self.attackCooldown = self.attackCooldownTime -- Reinicia el cooldown

            -- Activar el efecto visual de daño
            self.flashTimer = self.flashDuration
        end
    end

    -- Reduce el cooldown (solo si es mayor que 0)
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
end

function Soul:draw()
    -- Dibuja el sprite actual basado en el estado
    local animation = soulAnimations[self.state]
    local quad = animation[self.spriteIndex]

    love.graphics.draw(spriteSheet, quad, self.x, self.y, 0, 1, 1, spriteWidth / 2, spriteHeight / 2)

    -- Dibuja el efecto de flash si está activo
    if self.flashTimer > 0 then
        love.graphics.setColor(1, 0, 0, 0.3)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth() * scaleX, love.graphics.getHeight() * scaleY)  -- Dibuja el rectángulo sobre toda la pantalla
        love.graphics.setColor(1, 1, 1, 1)  -- Vuelve al color normal
    end
end

return Soul
