local Enemy = require("Enemy")

local Draugr = {}
Draugr.__index = Draugr
setmetatable(Draugr, { __index = require("Enemy") }) -- Hereda de Enemy

function Draugr:new(x, y)
    local draugr = Enemy:new(x, y, 100, 15) -- Velocidad moderada, daño cuerpo a cuerpo
    draugr.health = 50
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

function Draugr:draw()
    love.graphics.setColor(0.5, 0.3, 0.2)
    love.graphics.rectangle("fill", self.x - 10, self.y - 10, 20, 20)
    love.graphics.setColor(1, 1, 1)
end

return Draugr