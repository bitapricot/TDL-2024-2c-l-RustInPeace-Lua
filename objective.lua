local Objective = {}
Objective.__index = Objective

function Objective:new(description, conditionFunc, onCompletion)
    local obj = setmetatable({}, Objective)
    obj.description = description
    obj.isCompleted = false
    obj.conditionFunc = conditionFunc
    obj.onCompletion = onCompletion
    return obj
end

-- Verifica si el objetivo se cumple
function Objective:update(player)
    if not self.isCompleted and self.conditionFunc(player) then
        self.isCompleted = true
        if self.onCompletion then
            self.onCompletion(player)  -- Ejecuta la acción al completar el objetivo
        end
    end
end

return Objective