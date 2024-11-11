local sti = require "sti"
local anim8 = require 'lib/anim8'
local camera = require 'lib/camera'
local wf = require 'lib/windfield'

-- Define el factor de escala para facilitar su uso en todo el código
local scaleX, scaleY = 1.7, 2

function love.load()
  world = wf.newWorld(0, 0)
  
  cam = camera()
  
  love.graphics.setDefaultFilter("nearest", "nearest")

  player = {}
  player.collider = world:newBSGRectangleCollider(400, 250, 20 * scaleX, 30 * scaleY, 10)
  player.collider:setFixedRotation(true)
  player.x = 400
  player.y = 200
  player.speed = 25000
  player.spriteSheet = love.graphics.newImage('assets/sprites/player-sheet.png')
  player.grid = anim8.newGrid( 12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight() )

  player.animations = {}
  player.animations.down = anim8.newAnimation(player.grid('1-4', 1), 0.2)
  player.animations.left = anim8.newAnimation(player.grid('1-4', 2), 0.2)
  player.animations.right = anim8.newAnimation(player.grid('1-4', 3), 0.2)
  player.animations.up = anim8.newAnimation(player.grid('1-4', 4), 0.2)

  player.anim = player.animations.left
  map = sti("map_catacombs.lua") -- mapa exportado de Tiled a Lua

  collisions = {}
  if map.layers["collisions"] then
    for i, obj in pairs(map.layers["collisions"].objects) do
      -- Escala las posiciones y tamaños de los colliders para que coincidan con el mapa escalado
      local collision = world:newRectangleCollider(obj.x * scaleX, obj.y * scaleY, obj.width * scaleX, obj.height * scaleY)
      collision:setType('static')
      table.insert(collisions, collision)
    end
  end
end


function love.update(dt)
  local isMoving = false
  
  -- Collider velocity
  local vx = 0
  local vy = 0
  
  if love.keyboard.isDown("right") then
    vx = player.speed * dt
    player.anim = player.animations.right
    isMoving = true
  end

  if love.keyboard.isDown("left") then
    vx = player.speed * -1 * dt
    player.anim = player.animations.left
    isMoving = true
  end

  if love.keyboard.isDown("down") then
    vy = player.speed * dt
    player.anim = player.animations.down
    isMoving = true
  end

  if love.keyboard.isDown("up") then
    vy = player.speed * -1 * dt
    player.anim = player.animations.up
    isMoving = true
  end
  
  player.collider:setLinearVelocity(vx, vy)
  
  if isMoving == false then
    player.anim:gotoFrame(2)
  end
  
  world:update(dt)
  player.x = player.collider:getX()
  player.y = player.collider:getY()
  
   -- Limit char position inside map
  local mapWidth = map.width * map.tilewidth * scaleX
  local mapHeight = map.height * map.tileheight * scaleY
  local playerWidth = 12 * scaleX 
  local playerHeight = 18 * scaleY

  -- Limit x axis
  if player.x < playerWidth / 2 then
    player.collider:setX(playerWidth / 2)
  elseif player.x > mapWidth - playerWidth / 2 then
    player.collider:setX(mapWidth - playerWidth / 2)
  end

  -- Limit y axis
  if player.y < playerHeight / 2 then
    player.collider:setY(playerHeight / 2)
  elseif player.y > mapHeight - playerHeight / 2 then
    player.collider:setY(mapHeight - playerHeight / 2)
  end


  player.anim:update(dt)
  
  cam:lookAt(player.x, player.y)
  
  -- Calculate cam limits based on map size and scale
  local mapWidth = map.width * map.tilewidth * scaleX
  local mapHeight = map.height * map.tileheight * scaleY
  local screenWidth = love.graphics.getWidth()
  local screenHeight = love.graphics.getHeight()

  -- Limit cam so it doesnt go outside map edges
  if cam.x < screenWidth / 2 then
    cam.x = screenWidth / 2
  elseif cam.x > mapWidth - screenWidth / 2 then
    cam.x = mapWidth - screenWidth / 2
  end

  if cam.y < screenHeight / 2 then
    cam.y = screenHeight / 2
  elseif cam.y > mapHeight - screenHeight / 2 then
    cam.y = mapHeight - screenHeight / 2
  end
end


function love.draw()
  cam:attach()

    love.graphics.push()
    love.graphics.scale(scaleX, scaleY)  -- X, Y scale

    map:drawLayer(map.layers['ground'])
    map:drawLayer(map.layers['walls'])
    map:drawLayer(map.layers['connections'])
    map:drawLayer(map.layers['interactions'])
    map:drawLayer(map.layers['items'])

    love.graphics.pop()

    player.anim:draw(player.spriteSheet, player.x, player.y, nil, 4, nil, 6, 9)
    --world:draw()
  cam:detach()
  
  -- Will use this for showing fixed info, for instance player stats
  love.graphics.print("=== !!! SHOW STATS HERE !!! ===", 10, 10)
end
