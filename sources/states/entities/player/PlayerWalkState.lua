
PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(player)
    self.entity = player
end

function PlayerWalkState:update(dt)
    if love.keyboard.isDown('left') then
        gSounds['human_walk']:play()
        self.entity.x = self.entity.x - self.entity.walkSpeed * dt
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-left')
    elseif love.keyboard.isDown('right') then
        gSounds['human_walk']:play()
        self.entity.x = self.entity.x + self.entity.walkSpeed * dt
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-right')
    elseif love.keyboard.isDown('up') then
        gSounds['human_walk']:play()
        self.entity.y = self.entity.y - self.entity.walkSpeed * dt
        self.entity.direction = 'up'
        self.entity:changeAnimation('walk-up')
    elseif love.keyboard.isDown('down') then
        gSounds['human_walk']:play()
        self.entity.y = self.entity.y + self.entity.walkSpeed * dt
        self.entity.direction = 'down'
        self.entity:changeAnimation('walk-down')
    else
        self.entity:changeState('idle')
    end

    if love.keyboard.wasPressed('space') and (self.entity.has_axe == 1 or self.entity.has_pickaxe == 1 or self.entity.has_sword == 1) then
        self.entity:changeState('hit')
    end
end