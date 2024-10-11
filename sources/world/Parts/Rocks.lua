--[[
    This is the fourth part of the world. 
    This is where the second ruby can be found.
]]

Rocks = Class{}

function Rocks:init(player)
    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    self.player = player
    self.world = World(self.player)

    self:generateWorld()
end

function Rocks:generateWorld()
    local positions = { {20, 70}, {150, 200}, {30, 250}, {36, 280}, {60, 260},
        {-5, 270}, {-10, 30}, {10, 300}, {16, 340},
        {160, 60}, {156, 86}, {170, 100}, {170, 140}, {168, 240}, {180, 260}

    }
    self.world:generateObjects(positions, 'small_tree')

    positions = {
        {100, 50}, {100, 66}, {110, 38}, {112, 54},
        {44, 150}, {40, 140}, {52, 140}, {68, 130}, {52, 150},
        {100, 150}, {100, 162}, {100, 174}, {110, 154}, {110, 168}, {110, 182},

        {70, 330}, {70, 342}, {70, 354}, {80, 324}, {82, 336}, {82, 350}, {84, 362}, {82, 376},
        {96, 324}, {98, 338}, {100, 312},
        {114, 312}, {120, 328},
        {126, 296}, {140, 310}, 
        {150, 316}, {154, 330}, {152, 324}, 
        {166, 338}, {166, 352}, {168, 366}, {164, 378}, {168, 392},
        {180, 364}, {178, 378}
    }
    self.world:generateObjects(positions, 'rock')


    --local mushroom_position = { {20, 25} }
    --self.world:generateMushrooms(mushroom_position)

    positions = { {120, 350} }
    self.world:generateObjects(positions, 'chest')

    positions = { {120, 100}, {140, 100}, {20, 150}, {50, 180}, {150, 120} }
    self.world:generateSkeletons(positions)
end

function Rocks:update(dt)
    self.world:update(dt)
end

function Rocks:render()
    self.world:render()
end