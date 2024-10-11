
Entity = Class{}

function Entity:init(def)
    self.direction = 'right'
    self.walkSpeed = def.walkSpeed

    self.health = def.health or 1 
    self.dead = false

    self.type = def.type or 'entity'
    self.has_key = false

    self.animations = self:createAnimations(def.animations)

    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height

    self.offsetX = def.offsetX or 0
    self.offsetY = def.offsetY or 0

    self.collisionOffsetX = def.collisionOffsetX or 0
    self.collisionOffsetY = def.collisionOffsetY or 0
end

function Entity:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'entities',
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end

    return animationsReturned
end

function Entity:collides(target)
    return (self.x + self.width /2 >= target.x - target.collisionOffsetX / 4 and 
            self.x <= target.x + target.width /2 + target.collisionOffsetX and
            self.y >= target.y - target.height + target.collisionOffsetY and 
            self.y - self.height <= target.y - target.height + target.collisionOffsetY)
end

-- function Entity:interacts(target)
--     -- return (self.x + self.width /2  >= target.x + target.interactionOffsetX /4 and 
--     --         self.x <= target.x + target.width /2 - target.interactionOffsetX and
--     --         self.y >= target.y - target.height + target.interactionOffsetY and 
--     --         self.y - self.height <= target.y - target.height - target.interactionOffsetY)

--     return (self.x + self.width /2  >= target.x - target.collisionOffsetX /2 and 
--             self.x <= target.x + target.width /2 + target.collisionOffsetX + target.collisionOffsetX /2 and
--             self.y >= target.y - target.height + target.collisionOffsetY + target.collisionOffsetY / 2 and 
--             self.y - self.height <= target.y - target.height + target.collisionOffsetY + target.collisionOffsetY / 2 )
-- end

function Entity:interacts(target) 
    -- checks if expanded collision box of entity overlaps with the target's collision box
    return (self.x + self.width / 2 + self.interactionRange >= target.x - target.collisionOffsetX / 4 and 
            self.x - self.interactionRange <= target.x + target.width / 2 + target.collisionOffsetX and
            self.y + self.interactionRange >= target.y - target.height + target.collisionOffsetY and 
            self.y - self.height - self.interactionRange <= target.y - target.height + target.collisionOffsetY)
end

function Entity:changeState(name)
    self.stateMachine:change(name)
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Entity:update(dt)
    self.stateMachine:update(dt)

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

function Entity:processAI(params, dt)
    self.stateMachine:processAI(params, dt)
end

function Entity:render(adjacentOffsetX, adjacentOffsetY)
    self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
    self.stateMachine:render()
    love.graphics.setColor(1, 1, 1, 1)
    self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
end