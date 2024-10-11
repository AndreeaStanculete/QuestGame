
PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player = Player {
        animations = ENTITY_FRAMES['player'].animations,
        walkSpeed = ENTITY_FRAMES['player'].walkSpeed,

        health = 3,

        type = 'player',
        
        x = VIRTUAL_WIDTH / 2 - 8,
        y = VIRTUAL_HEIGHT / 2 - 11,
        
        width = 32,
        height = 32,

        offsetY = 0,
        offsetX = 0
    }

    -- check in which part of the world the player is
    self.window_number = 1

    -- parts of the game world
    self.worlds = {StartWorld(self.player), Forest(self.player), Village(self.player), Rocks(self.player)}

    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player) end,
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['hit'] = function() return PlayerHitState(self.player) end
    }
    self.player:changeState('idle')

    self.new_game = true

    -- for pause game 
    self.pause_game = 0
    self.pause_options = 3
    self.current_option = 1

    -- for inventory
    self.open_inventory = 0

    -- for quest menu
    self.quest_menu = 0
    self.number_of_quests = 0
    self.quests = {}
    self:getQuests()

    -- player has won the game
    self.won = false
    self.lost = false
end

function PlayState:getQuests()
    for questName, questDetails in pairs(GAME_QUESTS) do
        table.insert(self.quests, Quest(GAME_QUESTS[questName]) )
    end

    self.number_of_quests = table.getn(self.quests)
end

--[[
    Method that checks whether the player should be moved from
    one part of the world to another.
]]
function PlayState:checkBounds()
    if self.window_number == 1 then
        if self.player.direction == 'left' and self.player.x <= 0 then
            self.player.x = 0
        elseif self.player.direction == 'up' and self.player.y <= 0 then
            self.player.y = 0
        elseif self.player.direction == 'right' and self.player.x >= 380 then
            self.window_number = 2
            self.player.x = 1
        elseif self.player.direction == 'down' and self.player.y >= 212 then
            self.window_number = 3
            self.player.y = 1
        end
    elseif self.window_number == 3 then
        if self.player.direction == 'right' and self.player.x >= 380 then
            self.window_number = 4
            self.player.x = 1
        elseif self.player.direction == 'down' and self.player.y >= 212 then
            self.player.y = 212
        elseif self.player.direction == 'left' and self.player.x <= 0 then
            self.player.x = 0
        elseif self.player.direction == 'up' and self.player.y <= 0 then
            self.window_number = 1
            self.player.y = 211
        end
    elseif self.window_number == 2 then
        if self.player.direction == 'left' and self.player.x <= 0 then
            self.window_number = 1
            self.player.x = 379
        elseif self.player.direction == 'up' and self.player.y <=0 then
            self.player.y = 0
        elseif self.player.direction == 'right' and self.player.x >= 380 then
            self.player.x = 380
        elseif self.player.direction == 'down' and self.player.y >= 212 then
            self.window_number = 4
            self.player.y = 1
        end
    elseif self.window_number == 4 then
        if self.player.direction == 'left' and self.player.x <= 0 then
            self.window_number = 3
            self.player.x = 379
        elseif self.player.direction == 'up' and self.player.y <= 0 then
            self.window_number = 2
            self.player.y = 211
        elseif self.player.direction == 'right' and self.player.x >= 380 then
            self.player.x = 380
        elseif self.player.direction == 'down' and self.player.y >= 212 then
            self.player.y = 212
        end
    end
end

function PlayState:update(dt)
    -- check state of quests
    for i, quest in ipairs(self.quests) do
        local progress = 0
        if quest.name == 'rubies' then
            local aux = 100 / quest.partsRequired
            progress = aux * self.player.has_ruby
        end

        quest.progress = progress
        if progress == 100 then
            quest.completed = true
            self.number_of_quests = self.number_of_quests - 1
        end
    end

    -- check if there are no more quests
    if self.number_of_quests == 0 then
        self.won = true
    end

    -- check if player is still alive
    if self.player.health == 0 then
        self.lost = true
    end

    if self.new_game == true then -- check if this is a new game
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            self.new_game = false
            gSounds['button_pressed']:play()
        end
    else
        -- check if player wants to pause the game or open inventory
        if love.keyboard.wasPressed('p') then
            gSounds['button_pressed']:play()
            if self.pause_game == 0 then
                self.pause_game = 1
            else
                self.pause_game = 0
            end
        elseif love.keyboard.wasPressed('i') then
            gSounds['button_pressed']:play()
            if self.open_inventory == 0 then
                self.open_inventory = 1
            else 
                self.open_inventory = 0
            end
        elseif love.keyboard.wasPressed('q') then
            gSounds['button_pressed']:play()
            if self.quest_menu == 0 then
                self.quest_menu = 1
            else 
                self.quest_menu = 0
            end
        end
    end

    -- check if game is paused/open inventory/open quest menu etc
    if self.pause_game == 0 and self.open_inventory == 0 and self.quest_menu == 0 and self.new_game == false and self.won == false and self.lost == false then
        self:checkBounds()

        self.worlds[self.window_number]:update(dt)
        if self.worlds[self.window_number].world.set_coins ~= 0 then
            self.player.coins = self.player.coins + self.worlds[self.window_number].world.set_coins 
            self.worlds[self.window_number].world.set_coins = 0
        end

        if self.worlds[self.window_number].world.set_wood ~= 0 then
            self.player.wood = self.player.wood + self.worlds[self.window_number].world.set_wood 
            self.worlds[self.window_number].world.set_wood = 0
        end

        if self.worlds[self.window_number].world.set_rocks ~= 0 then
            self.player.rocks = self.player.rocks + self.worlds[self.window_number].world.set_rocks 
            self.worlds[self.window_number].world.set_rocks = 0
        end

    else
        if self.won == true or self.lost == true then
            if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
                gStateMachine:change('start')
            end
        elseif self.pause_game == 1 then
            -- update pause menu based on key pressed
            if love.keyboard.wasPressed('down') then
                self.current_option = self.current_option + 1
            elseif love.keyboard.wasPressed('up') then
                self.current_option = self.current_option - 1
            elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
                gSounds['button_pressed']:play()
                if self.current_option == 1 then
                    self.pause_game = 0
                elseif self.current_option == 2 then
                    self.new_game = true
                    self.pause_game = 0
                elseif self.current_option == 3 then
                    love.event.quit()
                end
            end

            if self.current_option > self.pause_options then
                self.current_option = 1
            elseif self.current_option < 1 then
                self.current_option = self.pause_options
            end
        end
    end
end

--[[
    Dialogue for initial menu with possible actions
]]
function PlayState:initialMenu()
    love.graphics.setColor(26/255, 33/255, 48/255, 0.3)
    love.graphics.rectangle("fill", 50, 10, 280, 200, 10)

    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(255, 255, 255, 1)

    love.graphics.printf('Actions', 140, VIRTUAL_HEIGHT / 2 - 90, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('Use the arrows to more around', 60, VIRTUAL_HEIGHT / 2 - 70, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('Press i to open inventory', 60, VIRTUAL_HEIGHT / 2 - 50, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('Press q to open quest list', 60, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('Press p to pause game', 60, VIRTUAL_HEIGHT / 2 - 10, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('Press f to interact with', 60, VIRTUAL_HEIGHT / 2 + 10, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('objects or entities', 80, VIRTUAL_HEIGHT / 2 + 30, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('Press space to use items', 60, VIRTUAL_HEIGHT / 2 + 50, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('Press enter to continue', 60, VIRTUAL_HEIGHT / 2 + 80, VIRTUAL_WIDTH, 'left')
end

--[[
    Dialogue for the quest menu
]]
function PlayState:questMenu()
    love.graphics.setColor(26/255, 33/255, 48/255, 0.3)
    love.graphics.rectangle("fill", 50, 30, 280, 160, 10)

    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(255, 255, 255, 1)

    love.graphics.printf('Quests', 140, VIRTUAL_HEIGHT / 2 - 70, VIRTUAL_WIDTH, 'left')

    local x = -50

    for i, quest in ipairs(self.quests) do
        love.graphics.printf(tostring(i) .. '. ' .. quest.instructions, 60, VIRTUAL_HEIGHT / 2 + x, 280, 'left')
        x = x + 40

        love.graphics.printf('Progress ' ..  tostring(quest.progress) .. '%', 80, VIRTUAL_HEIGHT / 2 + x, VIRTUAL_WIDTH, 'left')
        x = x + 20
    end
end

--[[
    Dialogue for the inventory
]]
function PlayState:inventoryMenu()
    -- rendering the inventory
    love.graphics.setColor(26/255, 33/255, 48/255, 0.3)
    love.graphics.rectangle("fill", 50, 30, 280, 160, 10)

    local coins = self.player.coins
    local has_inventory = 0
    local inventory = {}
    local objects_in_inventory = {}

    -- check all objects the player may posses
    if self.player.potions ~= 0 then
        table.insert(inventory, self.player.potions)
        table.insert(objects_in_inventory, 'Potions')
        has_inventory = 1
    end

    if self.player.has_sword ~= 0 then
        table.insert(inventory, 1)
        table.insert(objects_in_inventory, 'Sword')
        has_inventory = 1
    end

    if self.player.has_axe ~= 0 then
        table.insert(inventory, 1)
        table.insert(objects_in_inventory, 'Axe')
        has_inventory = 1
    end

    if self.player.has_pickaxe ~= 0 then
        table.insert(inventory, 1)
        table.insert(objects_in_inventory, 'Pickaxe')
        has_inventory = 1
    end

    if self.player.wood ~= 0 then
        table.insert(inventory, self.player.wood)
        table.insert(objects_in_inventory, 'Wood')
        has_inventory = 1
    end

    if self.player.rocks ~= 0 then
        table.insert(inventory, self.player.rocks)
        table.insert(objects_in_inventory, 'Rocks')
        has_inventory = 1
    end

    if self.player.has_key ~= 0 then
        table.insert(inventory, self.player.has_key)
        table.insert(objects_in_inventory, 'Key')
        has_inventory = 1
    end

    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(255, 255, 255, 1)
    love.graphics.printf('Inventory', 140, VIRTUAL_HEIGHT / 2 - 70, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('Coins: ' .. tostring(coins), 60, VIRTUAL_HEIGHT / 2 - 50, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('Items: ', 60, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'left')

    if has_inventory == 0 then
        love.graphics.printf('none', 80, VIRTUAL_HEIGHT / 2 - 10, VIRTUAL_WIDTH, 'left')
    else 
        local x = -10
        local y = 80
        for k, item in pairs(objects_in_inventory) do
            love.graphics.printf(item .. ' (' .. inventory[k] .. ')' , y, VIRTUAL_HEIGHT / 2 + x, VIRTUAL_WIDTH, 'left')
            x = x + 20

            if x == 50 then
                y = 180
                x = -10
            end
        end
    end
end

--[[
    Dialogue for the pause menu
]]
function PlayState:pauseMenu()
    love.graphics.setFont(gFonts['subtitle'])
    love.graphics.setColor(255, 255, 255, 1)
    love.graphics.printf('PAUSED GAME', 50, VIRTUAL_HEIGHT / 2 - 70, 270, 'center')

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
    love.graphics.printf('Resume', 2, VIRTUAL_HEIGHT - 100, VIRTUAL_WIDTH, 'center')

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
    love.graphics.printf('Help', 2, VIRTUAL_HEIGHT - 70, VIRTUAL_WIDTH, 'center')

    -- third button
    -- color numbers in RGB
    a = 255
    b = 255
    c = 255

    love.graphics.setFont(gFonts['medium'])
    if self.current_option == 3 then
        a = 26
        b = 33
        c = 48
    end
    love.graphics.setColor(a/255, b/255, c/255, 1)
    love.graphics.printf('Exit', 2, VIRTUAL_HEIGHT - 40, VIRTUAL_WIDTH, 'center')
end

function PlayState:render()
    love.graphics.push()
    
    self.worlds[self.window_number]:render()

    love.graphics.setColor(255, 255, 255, 1)
    for i=1, self.player.health do 
        love.graphics.draw(gTextures['heart'], gFrames['heart'][1],
            (i - 1) * (TILE_SIZE + 1), 2)
    end

    if self.new_game == true then
        self:initialMenu()
    elseif self.pause_game == 1 then
        self:pauseMenu()
    elseif self.open_inventory == 1 then
        self:inventoryMenu()
    elseif self.quest_menu == 1 then
        self:questMenu()
    elseif self.won == true then
        --self:playerHasWonMenu()
        gStateMachine:change('game_over', {
            won = true
        })
    elseif self.lost == true then
        --self:playerHasLostMenu()
        gStateMachine:change('game_over', {
            won = false
        })
    end

    love.graphics.pop()
end