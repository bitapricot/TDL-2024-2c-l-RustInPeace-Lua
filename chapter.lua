Chapter = {}
Chapter.__index = Chapter

function Chapter:new(number, zones)
    local chapter = {}
    setmetatable(chapter, Chapter)
    chapter.number = number  -- Número o identificador del capítulo
    chapter.zones = zones or {}  -- Lista de zonas del capítulo
    chapter.objectives = {}  -- Lista de objetivos
    return chapter
end

function Chapter:addObjective(objective)
    table.insert(self.objectives, objective)
end

function Chapter:isCompleted()
    -- Verifica si todos los objetivos del capítulo fueron completados
    for _, objective in ipairs(self.objectives) do
        if not objective:checkCompletion() then
            return false
        end
    end
    return true
end

function Chapter:load(world, scaleX, scaleY)
    -- Cargar el mapa del capítulo
    self.map = Map:new("map_catacombs.lua", world, scaleX, scaleY)

    -- Crear al jugador
    self.player = Player:new(world, 400, 250, scaleX, scaleY)

    -- Inicializar objetivos y eventos
    table.insert(self.objectives, { id = 1, description = "Explorar el bosque", function()  return true end })
end

function Chapter:getPlayerPosition()
    return self.player.x, self.player.y
end

function Chapter:clampCamera(cam)
    self.map:clampCamera(cam, self.player)
end

function Chapter:update(dt)
    for _, objective in ipairs(self.objectives) do
        if not objective.isCompleted then
            objective:checkCompletion()
        end
    end
end
    -- Acá podríamos llamar a otros métodos de actualización para las zonas o IA de los enemigos

function Chapter:draw()
    -- Dibuja las zonas activas del capítulo
    for _, zone in ipairs(self.zones) do
        if zone.isActive then
            zone:draw()
        end
    end
end

return Chapter