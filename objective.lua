Objective = {}
Objective.__index = Objective

function Objective:new(description, conditionFunc, onCompletion, dependencies)
    local objective = {}
    setmetatable(objective, Objective)
    objective.description = description
    objective.isCompleted = false
    objective.conditionFunc = conditionFunc
    objective.onCompletion = onCompletion or nil
    objective.dependencies = dependencies or {}  -- Lista de objetivos que deben cumplirse primero
    return objective
end

function Objective:checkCompletion()
    -- Comprobamos que todas las dependencias estén completas antes de verificar la condición
    for _, dependency in ipairs(self.dependencies) do
        if not dependency.isCompleted then
            return false
        end
    end

    -- Verificamos la condición de este objetivo
    if self.conditionFunc() then
        self.isCompleted = true
        if self.onCompletion then
            self.onCompletion:handle()
        end
    end
    return self.isCompleted
end
