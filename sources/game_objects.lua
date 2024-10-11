
GAME_OBJECTS = {
    -- from outdoor decor sheet
    ['mushroom'] = {
        type = 'mushroom',
        texture = 'objects',
        frame = 52,
        width = 16,
        height = 16,
        solid = true,
    },
    ['sign'] = {
        type = 'sign',
        texture = 'objects',
        frame = 42,
        width = 16,
        height = 16,
        solid = true,
        collisionOffsetX = 0,
        collisionOffsetY = 0,
    },
    ['rock'] = {
        type = 'rock',
        texture = 'objects',
        frame = 1,
        width = 16,
        height = 16,
        solid = false,
    },

    ['empty-bucket'] = {
        type = 'bucket',
        texture = 'objects',
        frame = 49,
        width = 16,
        height = 16,
        solid = false,
    },
    ['water-bucket'] = {
        type = 'bucket',
        texture = 'objects',
        frame = 56,
        width = 16,
        height = 16,
        solid = false,
    },
    ['wheat'] = {
        type = 'wheat',
        texture = 'objects',
        frame = 63,
        width = 16,
        height = 16,
        solid = false,
    },
    ['box'] = {
        type = 'box',
        texture = 'objects',
        frame = 70,
        width = 16,
        height = 16,
        solid = false,
    },

    ['bench'] = {
        type = 'bench',
        texture = 'objects',
        frame = 53,
        -- this is in two pieces, but frames are one after the other
        width = 16,
        height = 16,
        solid = true,
    },
    ['cut_wood'] = {
        type = 'wood',
        texture = 'objects',
        frame = 50,
        -- this is in two pieces, but frames are one after the other
        width = 16,
        height = 16,
        solid = true,
    },

    --trees
    ['small_tree'] = {
        type = 'small_tree',
        texture = 'small_tree',
        frame = 1,
        width = 32,
        height = 48,
        solid = true,
        collisionOffsetX = 0,
        collisionOffsetY = 60,
    },

    -- chest
    ['chest'] = {
        type = 'chest',
        texture = 'chest',
        frame = 1,
        width = 16,
        height = 16,
        solid = true,
    },

    -- house
    ['house'] = {
        type = 'house',
        texture = 'house',
        frame = 1,
        width = 112,
        height = 96,
        solid = true,
        collisionOffsetX = 36,
        collisionOffsetY = 150
    },

    ['gold_key'] = {
        type = 'key',
        texture = 'dungeon',
        frame = 100,
        width = 16,
        height = 16,
        solid = true,
    },
    ['silver_key'] = {
        type = 'key',
        texture = 'dungeon',
        frame = 89,
        width = 16,
        height = 16,
        solid = true,
    },
    -- from dungeon sprite sheet
    ['wood_chest'] = {
        type = 'wood_chest',
        texture = 'dungeon',
        frame = 84,
        width = 16,
        height = 16,
        solid = true,
    },
    ['health_potion'] = {
        type = 'potion',
        texture = 'dungeon',
        frame = 88,
        width = 16,
        height = 16,
        solid = true,
    },
    

}