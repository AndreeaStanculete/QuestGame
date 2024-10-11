

EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity)
    self.entity = entity

    if self.entity.type == 'girl_npc' or self.entity.type == 'boy_npc' then
        self.entity:changeAnimation('idle')
    else
        self.entity:changeAnimation('idle-' .. self.entity.direction)
    end

    self.waitDuration = 0
    self.waitTimer = 0
end

function EntityIdleState:processAI(params, dt)
    if self.entity.type == 'girl_npc' or self.entity.type == 'boy_npc' then
        self.waitDuration = math.random(5)
    else
        if self.waitDuration == 0 then
            self.waitDuration = math.random(5)
        else
            self.waitTimer = self.waitTimer + dt

            if self.waitTimer > self.waitDuration then
                self.entity:changeState('walk')
            end
        end
    end
end

function EntityIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
end