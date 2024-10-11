

StartState = Class{__includes = BaseState}

function StartState:init()
    -- to keep track of the menu
    self.number_of_options = 2
    self.current_option = 1
end

function StartState:update(dt)
    -- update menu based on key pressed
    if love.keyboard.wasPressed('down') then
        self.current_option = self.current_option + 1
    elseif love.keyboard.wasPressed('up') then
        self.current_option = self.current_option - 1
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['button_pressed']:play()
        if self.current_option == 1 then
            gStateMachine:change('story')
        elseif self.current_option == 2 then
            love.event.quit()
        end
    end

    if self.current_option > self.number_of_options then
        self.current_option = 1
    elseif self.current_option < 1 then
        self.current_option = self.number_of_options
    end

end

function StartState:render()
    love.graphics.draw(gTextures['game_background'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['game_background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['game_background']:getHeight())

    love.graphics.setColor(26/255, 33/255, 48/255, 0.3)
    love.graphics.rectangle("fill", 50, 10, 280, 200, 10)

    love.graphics.setFont(gFonts['title'])
    love.graphics.setColor(255, 255, 255, 1)
    love.graphics.printf('Quest', 2, VIRTUAL_HEIGHT / 2 - 70, VIRTUAL_WIDTH, 'center')

    -- first button
    -- color numbers in RGB
    a = 255
    b = 255
    c = 255

    love.graphics.setFont(gFonts['medium'])
    if self.current_option == 1 then
        a = 26
        b = 33
        c = 48
    end
    love.graphics.setColor(a/255, b/255, c/255, 1)
    love.graphics.printf('New Game', 2, VIRTUAL_HEIGHT - 100, VIRTUAL_WIDTH, 'center')

    -- second button
    -- color numbers in RGB
    a = 255
    b = 255
    c = 255

    love.graphics.setFont(gFonts['medium'])
    if self.current_option == 2 then
        a = 26
        b = 33
        c = 48
    end
    love.graphics.setColor(a/255, b/255, c/255, 1)
    love.graphics.printf('Exit', 2, VIRTUAL_HEIGHT - 70, VIRTUAL_WIDTH, 'center')
end