
require 'sources/Dependencies'

function love.load()

    math.randomseed(os.time())
    love.window.setTitle('Quest')
    --love.window.setFullscreen(true)
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })

    love.graphics.setFont(gFonts['small'])

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['story'] = function() return StoryState() end,
        ['play'] = function() return PlayState() end,
        ['you_won'] = function() return YouWonState() end,
        ['game_over'] = function() return GameOverState() end
    }
    gStateMachine:change('start')

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end


function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    Timer.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end