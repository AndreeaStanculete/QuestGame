--[[
    This is the third part of the world. 
    This is where the player can sell and buy things.
]]

Village = Class{}

function Village:init(player)
    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    self.player = player
    self.world = World(self.player)

    self:generateWorld()
end

function Village:generateWorld()
    local positions = { {-10, -5}, {0, 50}, {100, 5}, {140, 20}, {180, 60}, {50, 204}, 
        {160, 100}, {166, 140}, {180, 200}, {190, 220}, {160, 260}
    }
    self.world:generateObjects(positions, 'small_tree')

    positions = { {40, 50} }
    self.world:generateObjects(positions, 'house')

    positions = { {15, 20} }
    self.world:generateObjects(positions, 'mushroom')

    positions = { {60, 280}, {64, 294} }
    self.world:generateObjects(positions, 'wheat')

    positions = { {90, 220}, {90, 236} }
    self.world:generateObjects(positions, 'bench')

    positions = { {20, 250}, {20, 266}, {26, 240}, {26, 256}, {150, 300}, {150, 316} }
    self.world:generateObjects(positions, 'cut_wood')

    positions = { {120, 338}, {124, 356} }
    self.world:generateObjects(positions, 'box')

    positions = { {122, 322}, {130, 50} }
    self.world:generateObjects(positions, 'water-bucket')

    self.world:generateVillageNPCs()
end

function Village:update(dt)
    self.world:update(dt)
end

function Village:render()
    self.world:render()
end