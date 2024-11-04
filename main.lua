local sti = require "sti"
local anim8 = require 'lib/anim8'

function love.load()
  
  love.graphics.setDefaultFilter("nearest", "nearest")

  player = {}
  player.x = 400
  player.y = 200
  player.speed = 250
  player.spriteSheet = love.graphics.newImage('assets/sprites/player-sheet.png')
  player.grid = anim8.newGrid( 12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight() )

  player.animations = {}
  player.animations.down = anim8.newAnimation(player.grid('1-4', 1), 0.2)
  player.animations.left = anim8.newAnimation(player.grid('1-4', 2), 0.2)
  player.animations.right = anim8.newAnimation(player.grid('1-4', 3), 0.2)
  player.animations.up = anim8.newAnimation(player.grid('1-4', 4), 0.2)

  player.anim = player.animations.left
  
  map = sti("map_catacombs.lua") -- mapa exportado de Tiled a Lua
end


function love.update(dt)
  local isMoving = false

  if love.keyboard.isDown("right") then
    player.x = player.x + player.speed * dt
    player.anim = player.animations.right
    isMoving = true
  end

  if love.keyboard.isDown("left") then
    player.x = player.x - player.speed * dt
    player.anim = player.animations.left
    isMoving = true
  end

  if love.keyboard.isDown("down") then
    player.y = player.y + player.speed * dt
    player.anim = player.animations.down
    isMoving = true
  end

  if love.keyboard.isDown("up") then
    player.y = player.y - player.speed * dt
    player.anim = player.animations.up
    isMoving = true
  end

  if isMoving == false then
    player.anim:gotoFrame(2)
  end

  player.anim:update(dt)
end


function love.draw()
  map:draw(0, 0, 1.7, 2)
  player.anim:draw(player.spriteSheet, player.x, player.y, nil, 4)
end
