

StartWorld = Class{}

function StartWorld:init(player)
    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    self.player = player
    self.world = World(self.player)

    self:generateWorld()
end

function StartWorld:generateWorld()
    local positions = { {0, 5}, { 5, 50}, {-10, 80}, {-15, 140}, {5, 200}, {15, 170},
        {40, 30}, {60, 80}, {70, 10}, {100, 20}, {125, 50}, {150, -10}, {200, 65},
        {50, 300}, {25, 260}, {0, 320}, {120, 150}, {140, 200}, {150, 250}, {180, 175}, {175, 350}
    }
    self.world:generateObjects(positions, 'small_tree')

    positions = { {140, 80}, {5, 350}, {130, 200}, {150, 280}, {90, 40} }
    self.world:generateObjects(positions, 'mushroom')

    positions = { {40, 90}, {120, 290} }
    self.world:generateObjects(positions, 'wood_chest')

    positions = { {100, 100}}
    self.world:generateObjects(positions, 'sign')
end

function StartWorld:update(dt)
    self.world:update(dt)
end

function StartWorld:render()
    self.world:render()
end