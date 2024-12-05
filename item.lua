Item = {}
Item.__index = Item

function Item:new(name, effect, quantity, sprite)
    local item = {}
    setmetatable(item, Item)
    item.name = name                    -- Nombre del ítem
    item.effect = effect                -- Función de efecto del ítem
    item.quantity = quantity
    item.sprite = sprite
    item.grabbed = false
    item.deleted = false
    return item
end

-- Aplica el efecto del ítem al objetivo proporcionado
function Item:applyEffect(target)
    if target and self.effect then
        self.effect(target)
        print(self.name .. " ha sido utilizado.")
    else
        print("No se puede aplicar el efecto de " .. self.name .. ".")
    end
end

-- Dibuja el ítem en pantalla (para interfaz o inventario)
-- function Item:draw(x, y)
--     -- Ejemplo básico de visualización
--     love.graphics.print(self.name, x, y)
-- end

function Item:grab()
    self.grabbed = true
end

function Item:drop()
    self.grabbed = false
end

return Item