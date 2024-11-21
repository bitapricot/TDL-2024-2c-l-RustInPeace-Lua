Player = {}
Player.__index = Player

function Player:new(x, y, spriteSheet)
    local player = {}
    setmetatable(player, Player)
    player.x = x
    player.y = y
    player.speed = 250
    player.spriteSheet = love.graphics.newImage(spriteSheet)
    player.grid = anim8.newGrid(12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
    player.animations = {
        down = anim8.newAnimation(player.grid('1-4', 1), 0.2),
        left = anim8.newAnimation(player.grid('1-4', 2), 0.2),
        right = anim8.newAnimation(player.grid('1-4', 3), 0.2),
        up = anim8.newAnimation(player.grid('1-4', 4), 0.2),
    }
    player.anim = player.animations.down
    return player
end

function Player:update(dt, world)
    local vx, vy = 0, 0

    if love.keyboard.isDown("right") then
        vx = self.speed
        self.anim = self.animations.right
    elseif love.keyboard.isDown("left") then
        vx = -self.speed
        self.anim = self.animations.left
    elseif love.keyboard.isDown("down") then
        vy = self.speed
        self.anim = self.animations.down
    elseif love.keyboard.isDown("up") then
        vy = -self.speed
        self.anim = self.animations.up
    else
        self.anim:gotoFrame(2)
    end

    -- Actualiza posición con el mundo (ejemplo con colisiones)
    if world then
        local collider = world:newBSGRectangleCollider(self.x, self.y, 20, 30)
        collider:setLinearVelocity(vx * dt, vy * dt)
        self.x, self.y = collider:getPosition()
    else
        self.x = self.x + vx * dt
        self.y = self.y + vy * dt
    end

    self.anim:update(dt)
end

function Player:draw()
    self.anim:draw(self.spriteSheet, self.x, self.y, 0, 1, 1, 6, 9)
end
