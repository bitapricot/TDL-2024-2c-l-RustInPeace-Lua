local Enemy = {}
Enemy.__index = Enemy

function Enemy:new(x, y, speed, damage)
    local enemy = {
        x = x,
        y = y,
        speed = speed or 100,  -- Velocidad base
        damage = damage or 10, -- Daño base
        state = "idle",  -- Estados genéricos: "idle", "chasing", "attacking"
        detectionRadius = 150, -- Rango en el que detecta al jugador
    }
    setmetatable(enemy, Enemy)
    return enemy
end

function Enemy:update(dt, player)
    -- Movimiento básico hacia el jugador
    local dx, dy = player.x - self.x, player.y - self.y
    local distance = math.sqrt(dx * dx + dy * dy)

    if distance < self.detectionRadius then
        self.state = "chasing"
        local angle = math.atan2(dy, dx)
        self.x = self.x + math.cos(angle) * self.speed * dt
        self.y = self.y + math.sin(angle) * self.speed * dt

        -- Ataque si está lo suficientemente cerca
        if distance < 20 then
            self.state = "attacking"
            player:takeDamage(self.damage * dt)
        end
    else
        self.state = "idle"
    end
end

function Enemy:draw()
    -- Representación genérica (puede ser reemplazada por clases especializadas)
    love.graphics.setColor(1, 0, 0) -- Rojo
    love.graphics.circle("fill", self.x, self.y, 20)
    
     -- Restablecer el color a blanco
    love.graphics.setColor(1, 1, 1)
end

return Enemy
