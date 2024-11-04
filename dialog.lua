-- Clase DialogLine
DialogLine = {}
DialogLine.__index = DialogLine

function DialogLine:new(character, text)
    local line = {}
    setmetatable(line, DialogLine)
    line.character = character    -- Personaje que habla (o puede ser "self" si es un pensamiento)
    line.text = text              -- Texto del diálogo
    return line
end

-- Clase Dialog
Dialog = {}
Dialog.__index = Dialog

function Dialog:new()
    local dialog = {}
    setmetatable(dialog, Dialog)
    dialog.lines = {}          -- Array de líneas de diálogo (DialogLine)
    -- dialog.responses = {}       -- Opciones de respuesta, si hay diálogo interactivo
    dialog.onCompletion = nil   -- Función que se ejecutará al finalizar el diálogo
    return dialog
end

function Dialog:addLine(character, text)
    table.insert(self.lines, DialogLine:new(character, text))
end

function Dialog:setResponses(responses)
    self.responses = responses  -- Array de opciones de respuesta
end

function Dialog:setCompletionCallback(callback)
    self.onCompletion = callback
end

function Dialog:start()
    -- Acá hay que iterar sobre líneas y mostrar opciones si aplica
end