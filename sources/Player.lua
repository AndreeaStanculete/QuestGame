
Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
    self.finishedAnimation = 0
    self.tookDamage = false
    self.timer = 0

    self.collisionOffsetX = 0
    self.collisionOffsetY = 0

    self.interactionRange = 10

    -- objects the player may have
    self.coins = 3
    self.wood = 0
    self.rocks = 0

    self.potions = 0
    self.food = 0

    self.has_key = 0 
    self.has_sword = 0
    self.has_axe = 1
    self.has_pickaxe = 0

    self.has_ruby = 0
end

function Player:update(dt)
    if self.tookDamage == true then
        self.timer = self.timer + dt

        if self.timer > 2 then
            self.tookDamage = false
            self.timer = 0
        end
    end

    Entity.update(self, dt)
end

function Player:render()
    Entity.render(self)
end