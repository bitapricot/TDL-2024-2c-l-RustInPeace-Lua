local Enemy = require("Enemy")
local Soul = require("Soul")
local Draugr = require("Draugr")

local EnemyFactory = {}

function EnemyFactory.createEnemy(type, x, y)
    if type == "soul" then
        return Soul:new(x, y)
    elseif type == "draugr" then
        return Draugr:new(x, y)
    else
        return Enemy:new(x, y)
    end
end

return EnemyFactory
