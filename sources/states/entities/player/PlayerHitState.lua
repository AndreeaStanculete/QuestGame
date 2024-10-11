
PlayerHitState = Class{__includes = BaseState}

function PlayerHitState:init(player)
    self.player = player

    -- sword-left, sword-up, etc
    self.player:changeAnimation('hit-' .. self.player.direction)
end

function PlayerHitState:enter(params)
    self.player.currentAnimation:refresh()
end

function PlayerHitState:update(dt)
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')

        self.player.finishedAnimation = 1
    end

    if love.keyboard.wasPressed('space') then
        self.player:changeState('hit')
    end
end

function PlayerHitState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end