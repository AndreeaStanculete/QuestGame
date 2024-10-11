
PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(params)
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    if love.keyboard.wasPressed('space') and (self.entity.has_axe == 1 or self.entity.has_pickaxe == 1 or self.entity.has_sword == 1) then
        self.entity:changeState('hit')
    end
end