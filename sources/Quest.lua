
Quest = Class{}

function Quest:init(def)
    -- info about quests
    self.name = def.name
    self.instructions = def.instructions

    self.completed = false
    self.progress = 0
    self.partsRequired = def.partsRequired
end

function Quest:update(dt)

end

function Quest:render(adjacentOffsetX, adjacentOffsetY)

end