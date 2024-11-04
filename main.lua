local sti = require "sti"

function love.load()
    map = sti("map.lua") -- mapa exportado de Tiled a Lua
end

function love.draw()
    map:draw()
end
