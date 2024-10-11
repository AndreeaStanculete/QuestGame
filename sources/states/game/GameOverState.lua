
GameOverState = Class{__includes = BaseState}

function GameOverState:init()
    -- false or true, based on whether the player won or lost
    self.state = false
end

function GameOverState:enter(params)
    self.state = params.won
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['button_pressed']:play()
        gStateMachine:change('start')
    end
end

function GameOverState:render()
    love.graphics.draw(gTextures['game_background'], 0, 0, 0, 
    VIRTUAL_WIDTH / gTextures['game_background']:getWidth(),
    VIRTUAL_HEIGHT / gTextures['game_background']:getHeight())

    love.graphics.setColor(26/255, 33/255, 48/255, 0.3)
    love.graphics.rectangle("fill", 50, 50, 280, 140, 10)

    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(255, 255, 255, 1)
    
    if self.state == false then
        love.graphics.printf('Opps! Seems like you have died.', 60, VIRTUAL_HEIGHT / 2 - 40, 270, 'center')
    elseif self.state == true then
        love.graphics.printf('Congratulations! You have finished the game as there are no more quests for you to complete!', 
        60, VIRTUAL_HEIGHT / 2 - 40, 270, 'center')
    end
    
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(255, 255, 255, 1)
    love.graphics.printf('Press Enter to play again...', 60, VIRTUAL_HEIGHT - 50 , 270, 'center')
end