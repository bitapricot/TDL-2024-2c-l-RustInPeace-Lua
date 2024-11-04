ICharacter = {}
ICharacter.__index = ICharacter

function ICharacter:new(x, y)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    return obj
end

function ICharacter:update(dt)
    -- Método para actualizar la posición o estado del personaje
end

function ICharacter:draw()
    -- Método para dibujar el personaje
end

PlayableCharacter = setmetatable({}, { __index = ICharacter })
PlayableCharacter.__index = PlayableCharacter

function PlayableCharacter:new(x, y)
    local obj = ICharacter.new(self, x, y)
    obj.health = 100
    obj.sanity = 100
    obj.inventory = {}
    obj.memories = {}
    return obj
end

function PlayableCharacter:takeDamage(amount)
    self.health = math.max(self.health - amount, 0)
end

function PlayableCharacter:useItem(item)
    -- Lógica para usar un ítem del inventario
end

Enemy = setmetatable({}, { __index = ICharacter })
Enemy.__index = Enemy

function Enemy:new(x, y, speed, detectionRange)
    local obj = ICharacter.new(self, x, y)
    obj.speed = speed
    obj.detectionRange = detectionRange
    return obj
end

function Enemy:dealDamage(character)
    character:takeDamage(10)  -- Por ejemplo, causa 10 de daño
end
