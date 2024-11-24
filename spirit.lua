local anim8 = require 'lib/anim8'

local Enemy = require("Enemy")

local Spirit = {}
Spirit.__index = Spirit
setmetatable(Spirit, { __index = require("Enemy") }) -- Hereda de Enemy

function Spirit:new(x, y)
    local spirit = Enemy:new(x, y, 200, 30) -- Velocidad rápida, mucho daño
    spirit.state = "hidden"
    spirit.effectTimer = 0
    
    setmetatable(spirit, Spirit)

    return spirit
end

function Spirit:update(dt, player)
  if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
    if self.state == "hidden" then
        self.effectTimer = self.effectTimer - dt
        if self.effectTimer <= 0 then
            self.state = "chasing"
            self.effectTimer = math.random(3, 5)
        end
    elseif self.state == "chasing" then
        -- Movimiento rápido hacia el jugador
        local dx, dy = player.x - self.x, player.y - self.y
        local angle = math.atan2(dy, dx)
        self.x = self.x + math.cos(angle) * self.speed * dt
        self.y = self.y + math.sin(angle) * self.speed * dt

        -- Ataque si está cerca
        if math.sqrt(dx * dx + dy * dy) < 30 then
            self.state = "attacking"
            player:takeDamage(self.damage)
            self.effectTimer = 2 -- Tiempo antes de desaparecer nuevamente
        end
    elseif self.state == "attacking" then
        self.state = "hidden"
    end
end

function Spirit:draw()
   if self.state == "hidden" then
       love.graphics.setColor(1, 0, 0, 0.3)
   else
      love.graphics.setColor(1, 0, 0, 1)
   end
   love.graphics.circle("fill", self.x, self.y, 20)
    
    love.graphics.setColor(1, 1, 1)
end

return Spirit