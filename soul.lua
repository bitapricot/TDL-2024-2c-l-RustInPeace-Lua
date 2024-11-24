local Enemy = require("Enemy")

local Soul = {}
Soul.__index = Soul
setmetatable(Soul, { __index = require("Enemy") }) -- Hereda de Enemy

function Soul:new(x, y)
    local soul = Enemy:new(x, y, 50, 5) -- Velocidad lenta, daño bajo
    soul.wanderTimer = 0
    setmetatable(soul, Soul)
    return soul
end

function Soul:update(dt, player)
    -- Llamar a la lógica base
    local baseUpdate = getmetatable(Soul).__index.update
    baseUpdate(self, dt, player)
end

function Soul:draw()
    love.graphics.setColor(0.8, 0.8, 1, 0.5)
    love.graphics.circle("fill", self.x, self.y, 15)
    
    love.graphics.setColor(1, 1, 1)
end

return Soul
