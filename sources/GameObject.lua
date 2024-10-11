
GameObject = Class{}

function GameObject:init(def, x, y)
    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    self.collisionOffsetX = def.collisionOffsetX or 0
    self.collisionOffsetY = def.collisionOffsetY or 0

    -- shows type of object (sign, tree, chest etc)
    self.type = def.type

    -- check whether the object is in game or was destroyed
    self.inPlay = 1

    -- required for chests
    self.requiresKey = false

    self.texture = def.texture
    self.frame = def.frame or 1

    -- default empty collision and interaction callback
    self.onCollide = function() end
    self.onInteraction = function() end
end

function GameObject:update(dt)

end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    local x = self.x + adjacentOffsetX
    local y = self.y + adjacentOffsetY

    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], x, y)
end