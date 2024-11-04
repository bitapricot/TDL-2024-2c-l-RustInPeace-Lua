Cutscene = {}
Cutscene.__index = Cutscene

function Cutscene:new(steps, onCompletion)
    local cutscene = {}
    setmetatable(cutscene, Cutscene)
    cutscene.steps = steps or {}          -- Lista de CutsceneStep
    cutscene.currentStep = 1               -- Índice del paso actual
    cutscene.isPlaying = false             -- Estado de reproducción
    cutscene.onCompletion = onCompletion   -- Función que se llama al finalizar la cutscene
    return cutscene
end

function Cutscene:start()
    self.isPlaying = true
    self:playNextStep()
end

function Cutscene:playNextStep()
    local step = self.steps[self.currentStep]
    if step then
        step:execute(function() 
            self.currentStep = self.currentStep + 1
            self:playNextStep() 
        end)
    else
        self:complete()
    end
end

function Cutscene:complete()
    self.isPlaying = false
    if self.onCompletion then self.onCompletion() end
end

CutsceneStep = {}
CutsceneStep.__index = CutsceneStep

function CutsceneStep:new(action, params, duration)
    local step = {}
    setmetatable(step, CutsceneStep)
    step.action = action          -- Función de acción que realiza el paso (mover, aparecer enemigo, etc.)
    step.params = params or {}    -- Parámetros específicos de la acción (ej. destino de movimiento)
    step.duration = duration or 1 -- Duración de la acción en segundos
    return step
end

function CutsceneStep:execute(onComplete)
    -- Ejecuta la acción específica
    self.action(self.params)
    
    -- Si tiene una duración, espera antes de llamar al callback
    if self.duration > 0 then
        Timer.after(self.duration, onComplete)
    else
        onComplete()
    end
end
