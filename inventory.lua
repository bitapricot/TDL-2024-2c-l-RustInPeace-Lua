Inventory = {}
Inventory.__index = Inventory

local Item = require 'item'

function Inventory:new()
    local inv = {}
    setmetatable(inv, Inventory)
    inv.items = {}  -- Lista de ítems
    return inv
end

function Inventory:addItem(item)
    -- Buscar si ya existe un ítem con el mismo nombre y que no esté eliminado
    local existingItem = nil
    for _, invItem in ipairs(self.items) do
        if invItem.name == item.data.name and not invItem.deleted then
            existingItem = invItem
            break
        end
    end

    if existingItem then
        -- Si el ítem ya existe y no está eliminado, incrementar su cantidad
        existingItem.quantity = existingItem.quantity + item.data.quantity
        print("Cantidad de " .. item.data.name .. " incrementada a " .. existingItem.quantity .. ".")
    else
        -- Si el ítem no existe o está eliminado, agregar uno nuevo
        table.insert(self.items, Item:new(item.data.name, item.data.effect, item.data.quantity, love.graphics.newImage(item.data.sprite)))
        print(item.data.name .. " fue agregado al inventario.")
    end
end


function Inventory:getItem(index)
    return self:getItems()[index]
end

function Inventory:getItems()
    local validItems = {}
    for _, item in ipairs(self.items) do
        if not item.deleted then
            table.insert(validItems, item)
        end
    end
    return validItems
end


-- Remueve un ítem específico del inventario
function Inventory:removeItem(item)
    for i, invItem in ipairs(self:getItems()) do
        if invItem == item then
            -- table.remove(self.items, i)
            item.deleted = true
            print(item.name .. " fue removido del inventario.")
            return true
        end
    end
    print("Item no encontrado en el inventario.")
    return false
end

function Inventory:useItem(index, player)
    local item = self:getItems()[index]
    if item and not item.deleted then
        -- Aplicar el efecto del ítem
        item:applyEffect(player)

        -- Reducir la cantidad del ítem
        item.quantity = item.quantity - 1
        print("Usaste " .. item.name .. ". Quedan " .. item.quantity .. ".")

        -- Si la cantidad es menor o igual a 0, remover el ítem
        if item.quantity <= 0 then
            self:removeItem(item)
        end
    else
        print("No hay un ítem en esa posición del inventario.")
    end
end

return Inventory
