--[[
    This is the second part of the world. 
    This is where the first ruby is.
]]

Forest = Class{}

function Forest:init(player)
    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    self.player = player
    self.world = World(self.player)

    self:generateWorld()
end

function Forest:generateWorld()
    local positions = { {-20, 190}, {-10, 220},
        {20, 20}, {18, 100}, {22, 150}, 
        {50, 130}, {70, 150}, {60, 100},
        {120, 40}, {125, 80},
        {150, 10}, {170, 30}, {175, 70}, {185, 55}, {165, 100}, {150, 130}, {155, 180},
        {50, 200}, {80, 215},
        {10, 315}, {15, 340}, {25, 275}, {30, 300}, {55, 305}, {90, 310}, {20, 360},
        {70, 290}, {55, 345},
        {125, 260}, {80, 270}, {120, 320}, 
        {140, 300}, {150, 325}, {160, 350}, 
        {185, 220}, {180, 260}, {190, 305}, {200, 330},
    }
    self.world:generateObjects(positions, 'small_tree')

    positions = { {5, 15}, {30, 50}, {140, 70}, {5, 350}, {150, 285}, {90, 40} }
    self.world:generateObjects(positions, 'mushroom')

    positions = { {120, 350} }
    self.world:generateObjects(positions, 'chest')

    positions = { {120, 100}, {140, 100}, {20, 150}, {50, 180}, {150, 120} }
    self.world:generateSkeletons(positions)
end

function Forest:update(dt)
    self.world:update(dt)
end

function Forest:render()
    self.world:render()
end