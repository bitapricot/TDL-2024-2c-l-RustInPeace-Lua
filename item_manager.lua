local ItemManager = {}
local items = {} -- Tabla para almacenar los ítems cargados.

function ItemManager:loadItems(filepath)
    local success, loadedItems = pcall(require, filepath)
    if success and type(loadedItems) == "table" then
        for _, item in ipairs(loadedItems) do
            items[item.id] = item -- Almacena los ítems por ID para acceso rápido.
        end
    else
        error("Error al cargar los ítems desde " .. filepath)
    end
end

function ItemManager:getItemById(id)
    return items[id]
end

function ItemManager:getAllItems()
    local allItems = {}
    for _, item in pairs(items) do
        table.insert(allItems, item)
    end
    return allItems
end

return ItemManager
