local sti = require "sti"
local anim8 = require 'lib/anim8'
local camera = require 'lib/camera'
local wf = require 'lib/windfield'
local Game = require 'Game'

io.stdout:setvbuf("no")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Crear instancia del juego
    game = Game:new()
    game:load()  -- Carga inicial del juego (zonas, jugador, etc.)
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end


function love.keypressed(key)
    local num = tonumber(key)  -- Convertir la tecla a número
    if num and num >= 1 and num <= 9 then
        game.player:useItemByIndex(num)  -- Usar el ítem correspondiente al índice
    end
end