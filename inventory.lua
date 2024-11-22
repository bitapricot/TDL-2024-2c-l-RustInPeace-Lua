Inventory = {}
Inventory.__index = Inventory

local Item = require 'item'

function Inventory:new()
    local inv = {}
    setmetatable(inv, Inventory)
    inv.items = {}  -- Lista de ítems
    return inv
end

-- Agrega un ítem al inventario
function Inventory:addItem(item)
    table.insert(self.items, Item:new(item.data.name, item.data.effect, item.data.quantity, love.graphics.newImage(item.data.sprite)))
    print(item.data.name .. " fue agregado al inventario.")
end

function Inventory:getItem(index)
    return self.items[index]
end

function Inventory:getItems()
    return self.items
end

-- Remueve un ítem específico del inventario
function Inventory:removeItem(item)
    for i, invItem in ipairs(self.items) do
        if invItem == item then
            table.remove(self.items, i)
            print(item.name .. " fue removido del inventario.")
            return true
        end
    end
    print("Item no encontrado en el inventario.")
    return false
end

-- Usa un ítem en el inventario
function Inventory:useItem(index, player)
    local item = self.items[index]
    if item then
        item:use(player)  -- Suponiendo que el ítem tiene un método `use` que interactúa con el jugador
        self:removeItem(item)  -- Opcionalmente removemos el ítem después de usarlo
    else
        print("No hay un ítem en esa posición del inventario.")
    end
end

return Inventory
