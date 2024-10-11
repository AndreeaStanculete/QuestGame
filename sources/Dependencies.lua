
Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'sources/StateMachine'
require 'sources/Util'

require 'sources/Entity'
require 'sources/Animation'
require 'sources/entity_frames'

require 'sources/GameObject'
require 'sources/game_objects'

require 'sources/Quest'
require 'sources/game_quests'

require 'sources/states/BaseState'

require 'sources/Constants'

require 'sources/states/entities/EntityIdleState'
require 'sources/states/entities/EntityWalkState'

require 'sources/Player'
require 'sources/states/entities/player/PlayerIdleState'
require 'sources/states/entities/player/PlayerWalkState'
require 'sources/states/entities/player/PlayerHitState'

require 'sources/world/World'
require 'sources/world/Parts/StartWorld'
require 'sources/world/Parts/Forest'
require 'sources/world/Parts/Village'
require 'sources/world/Parts/Rocks'

require 'sources/states/game/StartState'
require 'sources/states/game/StoryState'
require 'sources/states/game/GameOverState'
require 'sources/states/game/PlayState'

gTextures = {
    ['grass_background'] = love.graphics.newImage('graphics/grass_background.png'),
    ['game_background'] = love.graphics.newImage('graphics/game_bg.png'),

    ['heart'] = love.graphics.newImage('graphics/hearts.png'),

    -- assets found on the internet
    ['objects'] = love.graphics.newImage('graphics/Objects/Outdoor_Decor_Free.png'),
    ['chest'] = love.graphics.newImage('graphics/Objects/chest.png'),
    ['small_tree'] = love.graphics.newImage('graphics/Objects/Small_Tree.png'),
    ['house'] = love.graphics.newImage('graphics/Objects/House.png'),

    ['dungeon'] = love.graphics.newImage('graphics/DungeonTiles/Dungeon_Tileset.png'),

    ['player'] = love.graphics.newImage('graphics/character/Character.png'),
    ['NPCs'] = love.graphics.newImage('graphics/character/NPCs.png'),
    ['skeleton'] = love.graphics.newImage('graphics/character/Skeleton.png'),
}

gFrames = {
    ['heart'] = GenerateQuads(gTextures['heart'], 16, 16),

    ['objects'] = GenerateQuads(gTextures['objects'], 16, 16),
    ['chest'] = GenerateQuads(gTextures['chest'], 16, 16),
    ['small_tree'] = GenerateQuads(gTextures['small_tree'], 32, 48),
    ['house'] = GenerateQuads(gTextures['house'], 112, 96),
    ['dungeon'] = GenerateQuads(gTextures['dungeon'], 16, 16),

    ['player'] = GenerateQuads(gTextures['player'], 32, 32),
    ['NPCs'] = GenerateQuads(gTextures['NPCs'], 32, 32),
    ['skeleton'] = GenerateQuads(gTextures['skeleton'], 32, 32),
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf',16),
    ['subtitle'] = love.graphics.newFont('fonts/font.ttf', 40),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 30),
    ['title'] = love.graphics.newFont('fonts/font.ttf', 50),
}

gSounds = {
    ['human_walk'] = love.audio.newSource('sounds/human_walk.wav', 'static'),
    ['human_damage'] = love.audio.newSource('sounds/human_damage.wav', 'static'),
    ['orc_damage'] = love.audio.newSource('sounds/orc_damage.wav', 'static'),

    ['sword_hit'] = love.audio.newSource('sounds/sword_hit.wav', 'static'),
    ['tree_hit'] = love.audio.newSource('sounds/tree_hit.wav', 'static'),
    ['rock_hit'] = love.audio.newSource('sounds/rock_hit.mp3', 'static'),

    ['chest_open'] = love.audio.newSource('sounds/chest_open.wav', 'static'),
    ['received'] = love.audio.newSource('sounds/ruby_received.wav', 'static'),

    ['button_pressed'] = love.audio.newSource('sounds/button_press.wav', 'static'),
}
