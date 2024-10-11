
--[[
    This is the base class for all parts of the world.
    Here can be found methods for adding objects and entities to the world.
]]
World = Class{}

function World:init(player)
    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    -- entities in the world
    self.entities = {}

    -- all game objects in the game: trees, rocks, chests etc
    self.game_objects = {}

    -- shows wheather the player is in dialogue or not
    -- in_dialogue = 2 for trees and rocks, where animation needs to end
    --             = 1 for the rest
    -- dialogue = {SIGN, NPC, W_CHEST, GIRL, BOY, COINS}
    self.in_dialogue = 0
    self.dialogue = "NONE"

    -- reference to player for collisions.
    self.player = player

    -- shows if player has found a reward
    self.found_reward = 0

    -- used to check in PlayState if player has a new reward
    self.set_coins = 0 
    self.set_wood = 0
    self.set_rocks = 0

    -- used for centering the rendering of the world
    self.renderOffsetX = MAP_RENDER_OFFSET_X
    self.renderOffsetY = MAP_RENDER_OFFSET_Y

    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0

    -- current option for shops
    self.current = 1
end

--[[
    generateObjects will add objects to the world
    params: 
        - positions: list of (x, y) positions where an object will be found
        - object: type of object that should be added (sign, small_tree, chest, house etc)
]]
function World:generateObjects(positions, object)
    -- generate other objects
    for i, position in ipairs(positions) do
        local y = position[1]
        local x = position[2]

        local obj = GameObject(
            GAME_OBJECTS[object],
            x,
            y
        )

        -- cut_wood and bench are made of two frames
        if (object == 'cut_wood' or object == 'bench') and i % 2 == 0 then
            obj.frame = obj.frame + 1
        end

        obj.onCollide = function()
            if self.player.direction == 'left' then
                self.player.x = self.player.x + 1
            elseif self.player.direction == 'right' then
                self.player.x = self.player.x - 1
            elseif self.player.direction == 'down' then
                self.player.y = self.player.y - 1
            elseif self.player.direction == 'up' then
                self.player.y = self.player.y + 1
            end
        end

        if object == 'chest' then
            -- chest that requires key
            obj.requiresKey = true
        elseif object == 'rock' then
            local rock_frames = {22, 23, 24}
            local frame = math.random(3)
            obj.frame = rock_frames[frame]
        end

        -- check interaction for each different object
        obj.onInteraction = function()
            if object == 'wood_chest'and love.keyboard.wasPressed('f') then
                self.in_dialogue = 1
                self.dialogue = "W_CHEST"

                self.found_reward = math.random(1, 5)
                obj.inPlay = 0
                gSounds['chest_open']:play()
            elseif object == 'chest' and love.keyboard.wasPressed('f') and self.player.has_key ~= 0 then
                self.in_dialogue = 1
                self.dialogue = "RUBY"
                obj.inPlay = 0
                self.player.has_ruby = self.player.has_ruby + 1 
                self.player.has_key = self.player.has_key - 1 
                gSounds['chest_open']:play()
            elseif object == 'rock' and love.keyboard.wasPressed('space') and self.player.has_pickaxe == 1 then
                self.in_dialogue = 2
                self.dialogue = "ROCK"

                self.found_reward = math.random(1, 2)
                obj.inPlay = 0
                gSounds['rock_hit']:play()
            elseif object == 'small_tree' and love.keyboard.wasPressed('space') and self.player.has_axe == 1 then
                self.in_dialogue = 2
                self.dialogue = "TREE"

                self.found_reward = math.random(1, 3)
                obj.inPlay = 0
                gSounds['tree_hit']:play()
            elseif object == 'sign' and love.keyboard.wasPressed('f') then
                self.in_dialogue = 1
                self.dialogue = "SIGN"
                gSounds['chest_open']:play()
            end
        end

        table.insert(self.game_objects, obj)
    end
end

function World:generateKey(y, x)
    -- generate key
    local key = GameObject(
        GAME_OBJECTS['silver_key'],
        x,
        y
    )

    key.onCollide = function()
        self.player.has_key = self.player.has_key + 1 
        key.inPlay = false
        gSounds['received']:play()
    end

    table.insert(self.game_objects, key)
end

function World:generateVillageNPCs()
    -- add boy npc
    local entity = Entity {
        animations = ENTITY_FRAMES['boy_npc'].animations,
        walkSpeed = 20,

        type = 'boy_npc',

        x = 250,
        y = 60,
        
        width = 32,
        height = 32,

        offsetY = 0,
        offsetX = 0
    }

    table.insert(self.entities, entity)
    self.entities[1].stateMachine = StateMachine {
        ['idle'] = function() return EntityIdleState(self.entities[1]) end
    }
    self.entities[1]:changeState('idle')

    -- add girl npc
    entity = Entity {
        animations = ENTITY_FRAMES['girl_npc'].animations,
        walkSpeed = 20,

        type = 'girl_npc',

        x = 150,
        y = 110,
        
        width = 32,
        height = 32,

        offsetY = 0,
        offsetX = 0
    }

    table.insert(self.entities, entity)
    self.entities[2].stateMachine = StateMachine {
        ['idle'] = function() return EntityIdleState(self.entities[2]) end
    }
    self.entities[2]:changeState('idle')
end

function World:generateSkeletons(skeleton_position)
    -- local counter = 1
    -- local maxim = 5

    for i, position in ipairs(skeleton_position) do
        local y = position[1]
        local x = position[2]

        local entity = Entity {
            animations = ENTITY_FRAMES['skeleton'].animations,
            walkSpeed = ENTITY_FRAMES['skeleton'].walkSpeed or 20,

            type = 'skeleton',

            x = x,
            y = y,
            
            width = 32,
            height = 32,

            health = 1,

            interactionOffsetX = -10,
            interactionOffsetY = -10
        }

        table.insert(self.entities, entity)
        self.entities[i].stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(self.entities[i]) end,
            ['idle'] = function() return EntityIdleState(self.entities[i]) end
        }
        self.entities[i]:changeState('walk')
    end

    -- one skeleton must have a key
    local len = table.getn(self.entities)
    self.entities[math.random(len)].has_key = true
end


function World:update(dt)
    -- checks if we already made an interaction
    local interaction_found = 0

    -- update everything as long as dialogue is not open
    if self.in_dialogue == 0 then
        self.player:update(dt)

        --for i, entity in pairs(self.entities) do
        for i = #self.entities, 1, -1 do
            local entity = self.entities[i]

            -- update and check for npcs
            if entity.type == 'boy_npc' or entity.type == 'girl_npc' then
                entity:processAI({current_world = self}, dt)
                entity:update(dt)

                if self.player:interacts(entity) and love.keyboard.wasPressed('f') then
                    self.in_dialogue = 1 

                    if entity.type == 'boy_npc' then
                        self.dialogue = 'BOY'
                    elseif entity.type == 'girl_npc' then 
                        self.dialogue = 'GIRL'
                    end
                end
            end

            -- update and check collisions only if skeleton is alive
            if entity.type == 'skeleton' and entity.dead == false then
                -- update entity
                entity:processAI({current_world = self}, dt)
                entity:update(dt)

                -- check for collision with player
                if entity:collides(self.player) and self.player.tookDamage == false then
                    self.player.health = self.player.health - 1
                    self.player.tookDamage = true
                    gSounds['human_damage']:play()
                end

                if self.player:interacts(entity) and love.keyboard.wasPressed('space') and self.player.has_sword == 1 and interaction_found == 0 then
                    entity.dead = true
                    gSounds['orc_damage']:play()
                    interaction_found = 1

                    if entity.has_key == true then
                        self:generateKey(entity.y, entity.x)
                    end
                end

                -- check collision between entities and objects
                for k, object in pairs(self.game_objects) do
                    if object.inPlay == 1 then
                        if entity:collides(object) then
                            if entity.direction == 'left' then
                                entity.direction = 'right'
                                entity.x = entity.x + 1
                            elseif entity.direction == 'right' then
                                entity.direction = 'left'
                                entity.x = entity.x - 1
                            elseif entity.direction == 'down' then
                                entity.direction = 'up'
                                entity.y = entity.y - 1
                            elseif entity.direction == 'up' then
                                entity.direction = 'down'
                                entity.y = entity.y + 1
                            end
                                
                            entity:changeAnimation('walk-' .. tostring(entity.direction))
                        end
                    end
                end
            end
        end

        -- check collision between player and objects
        for k, object in pairs(self.game_objects) do
            if object.inPlay == 1 then
                object:update(dt)

                -- trigger collision callback on object
                if self.player:collides(object) then
                    object:onCollide()
                end

                if self.player:interacts(object) and interaction_found == 0 then
                    object:onInteraction()
                    interaction_found = 1
                end
            end
        end

    elseif self.in_dialogue == 2 and self.player.finishedAnimation == 0 then
        -- let player first finish sword animation
        self.player:update(dt)
    else
        -- open dialogue with BOY_NPC
        if self.dialogue == 'BOY' then
            if love.keyboard.wasPressed('down') then
                self.current = self.current + 1
            elseif love.keyboard.wasPressed('up') then
                self.current = self.current - 1
            elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
                if self.current == 1 then
                    -- exit
                    self.in_dialogue = 0
                    self.dialogue = 'NONE'
                    self.found_reward = 0
                    self.player.finishedAnimation = 0
                elseif self.current == 2 then
                    -- sell all wood
                    gSounds['received']:play()
                    self.found_reward = self.player.wood * 2
                    self.player.wood = 0
                    self.dialogue = 'COINS'
                elseif self.current == 3 then
                    -- sell all rocks
                    gSounds['received']:play()
                    self.found_reward = self.player.rocks * 3
                    self.player.rocks = 0
                    self.dialogue = 'COINS'
                end

                self.current = 1
            end
        
            if self.current == 2 and self.player.wood == 0 then
                self.current = 3
            end
            if self.current == 3 and self.player.rocks == 0 then
                self.current = 1
            end
            if self.current < 1 then
                self.current = 1
            end
            if self.current > 3 then
                self.current = 3
            end

        elseif self.dialogue == 'GIRL' then    -- open dialogue with GIRL NPC
            if love.keyboard.wasPressed('down') then
                self.current = self.current + 1
            elseif love.keyboard.wasPressed('up') then
                self.current = self.current - 1
            elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
                if self.current == 1 then
                    -- exit
                    self.in_dialogue = 0
                    self.dialogue = 'NONE'
                    self.found_reward = 0
                    self.player.finishedAnimation = 0
                elseif self.current == 2 then
                    -- sell all wood
                    gSounds['received']:play()
                    self.player.has_sword = 1
                    self.dialogue = 'BUY'
                    self.found_reward = 10
                elseif self.current == 3 then
                    -- sell all rocks
                    gSounds['received']:play()
                    self.player.has_pickaxe = 1
                    self.dialogue = 'BUY'
                    self.found_reward = 20
                end

                self.current = 1
            end
        
            if self.current == 2 and (self.player.has_sword == 1 or self.player.coins < 20) then
                self.current = 3
            end
            if self.current == 3 and (self.player.has_pickaxe == 1 or self.player.coins < 10) then
                self.current = 1
            end
            if self.current < 1 then
                self.current = 1
            end
            if self.current > 3 then
                self.current = 3
            end
            
        elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            if self.found_reward ~= 0 then
                if self.dialogue == 'W_CHEST' or self.dialogue == 'COINS' then
                    self.set_coins = self.found_reward
                elseif self.dialogue == 'TREE' then
                    self.set_wood = self.found_reward
                elseif self.dialogue == 'ROCK' then
                    self.set_rocks = self.found_reward
                end
            end

            -- all relevant values will be reset once player leaves dialogue
            self.in_dialogue = 0
            self.dialogue = 'NONE'
            self.found_reward = 0
            self.player.finishedAnimation = 0
            
        end
    end
end

--[[
    Dialogue that will open when player interacts with sign object
]]
function World:signDialogue()
    love.graphics.setColor(26/255, 33/255, 48/255, 0.3)
    love.graphics.rectangle("fill", 50, 30, 280, 160, 10)

    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(255, 255, 255, 1)

    love.graphics.printf('Go north if you wish to trade and buy your necesities.', 60, VIRTUAL_HEIGHT / 2 - 70, 270, 'left')
    love.graphics.printf('Go east and north-east to find what you seek.', 60, VIRTUAL_HEIGHT / 2 - 30, 270, 'left')
    love.graphics.printf('Press enter to exit', 60, VIRTUAL_HEIGHT / 2 + 10, VIRTUAL_WIDTH, 'left')
end

--[[
    Dialogue that will show when player receives a reward (coins, wood, rocks etc)
]]
function World:rewardDialogue()
    love.graphics.setColor(26/255, 33/255, 48/255, 0.3)
    love.graphics.rectangle("fill", 50, 150, 280, 60, 10)

    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(255, 255, 255, 1)

    local reward = 'coins'
    if self.dialogue == 'TREE' then
        reward = 'wood'
    elseif self.dialogue == 'ROCK' then
        reward = 'rocks'
    elseif self.dialogue == 'RUBY' then
        self.found_reward = 1
        reward = 'ruby'
    end

    love.graphics.printf('You have received ' .. tostring(self.found_reward) .. ' ' .. reward, 60, VIRTUAL_HEIGHT / 2 + 50, 270, 'left')
    love.graphics.printf('Press Enter to exit', 60, VIRTUAL_HEIGHT / 2 + 80, 270, 'left')
end

--[[
    Dialogue that will open when player makes a purchase
]]
function World:purchaseCompleted()
    love.graphics.setColor(26/255, 33/255, 48/255, 0.3)
    love.graphics.rectangle("fill", 50, 120, 280, 90, 10)

    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(255, 255, 255, 1)

    local text = ''
    -- player has bought a sword
    if self.found_reward == 10 then
        text = 'Congratulations! You can now kill skeletons'
    elseif self.found_reward == 20 then    -- player has bought a pickaxe
        text = 'Congratulations! You can now destroy rocks'
    end

    love.graphics.printf(text, 60, VIRTUAL_HEIGHT / 2 + 20, 270, 'left')
    love.graphics.printf('Press Enter to exit', 60, VIRTUAL_HEIGHT / 2 + 60, 270, 'left')
end

--[[
    Dialogue for the sell shop
]]
function World:sellShop()
    if self.player.wood ~= 0 or self.player.rocks ~= 0 then
        love.graphics.setColor(26/255, 33/255, 48/255, 0.3)
        love.graphics.rectangle("fill", 50, 10, 280, 200, 10)
    
        love.graphics.setFont(gFonts['small'])
        love.graphics.setColor(255, 255, 255, 1)

        love.graphics.printf('Hey there! Do you have anything good to sell?', 60, VIRTUAL_HEIGHT / 2 - 90, 270, 'left')

        -- exit button
        -- color numbers in RGB
        a = 255
        b = 255
        c = 255

        love.graphics.setFont(gFonts['small'])
        if self.current == 1 then
            a = 26
            b = 33
            c = 48
        end
        love.graphics.setColor(a/255, b/255, c/255, 1)
        love.graphics.printf('exit', 80, VIRTUAL_HEIGHT / 2 - 50, 270, 'left')

        -- first button
        -- color numbers in RGB
        a = 255
        b = 255
        c = 255

        if self.current == 2 then
            a = 26
            b = 33
            c = 48
        end
        love.graphics.setColor(a/255, b/255, c/255, 1)
        if self.player.wood == 0 then
            love.graphics.setColor(a/255, b/255, c/255, 0.5)
        end
        love.graphics.printf('sell wood (' .. tostring(self.player.wood) .. ')', 80, VIRTUAL_HEIGHT / 2 - 30, 270, 'left')

        -- first button
        -- color numbers in RGB
        a = 255
        b = 255
        c = 255

        if self.current == 3 then
            a = 26
            b = 33
            c = 48
        end
        love.graphics.setColor(a/255, b/255, c/255, 1)
        if self.player.rocks == 0 then
            love.graphics.setColor(a/255, b/255, c/255, 0.5)
        end
        love.graphics.printf('sell rocks (' .. tostring(self.player.rocks) .. ')', 80, VIRTUAL_HEIGHT / 2 - 10, 270, 'left')

        love.graphics.setColor(255, 255, 255, 1)
        love.graphics.printf('Press Enter to choose', 60, VIRTUAL_HEIGHT / 2 + 20, VIRTUAL_WIDTH, 'left')
    else
        love.graphics.setColor(26/255, 33/255, 48/255, 0.3)
        love.graphics.rectangle("fill", 50, 120, 280, 90, 10)

        love.graphics.setFont(gFonts['small'])
        love.graphics.setColor(255, 255, 255, 1)

        love.graphics.printf('Hey there! You can sell all your wood and rocks to me.', 60, VIRTUAL_HEIGHT / 2 + 20, 270, 'left')
        love.graphics.printf('Press Enter to exit', 60, VIRTUAL_HEIGHT / 2 + 60, 270, 'left')
    end
end

--[[
    Dialogue for the buy shop
]]
function World:buyShop()
    if self.player.has_sword == 0 or self.player.has_pickaxe == 0 then
        love.graphics.setColor(26/255, 33/255, 48/255, 0.3)
        love.graphics.rectangle("fill", 50, 10, 280, 200, 10)
    
        love.graphics.setFont(gFonts['small'])
        love.graphics.setColor(255, 255, 255, 1)

        love.graphics.printf('Heya! Would you like to buy an item?', 60, VIRTUAL_HEIGHT / 2 - 90, 270, 'left')

        -- exit button
        -- color numbers in RGB
        a = 255
        b = 255
        c = 255

        if self.current == 1 then
            a = 26
            b = 33
            c = 48
        end
        love.graphics.setColor(a/255, b/255, c/255, 1)
        love.graphics.printf('exit', 80, VIRTUAL_HEIGHT / 2 - 50, 270, 'left')

        -- first button
        -- color numbers in RGB
        a = 255
        b = 255
        c = 255

        if self.current == 2 then
            a = 26
            b = 33
            c = 48
        end
        love.graphics.setColor(a/255, b/255, c/255, 1)
        if self.player.has_sword == 2 then
            love.graphics.setColor(a/255, b/255, c/255, 0.5)
        end
        love.graphics.printf('sword (20 coins)', 80, VIRTUAL_HEIGHT / 2 - 30, 270, 'left')

        -- first button
        -- color numbers in RGB
        a = 255
        b = 255
        c = 255

        if self.current == 3 then
            a = 26
            b = 33
            c = 48
        end
        love.graphics.setColor(a/255, b/255, c/255, 1)
        if self.player.has_pickaxe == 2 then
            love.graphics.setColor(a/255, b/255, c/255, 0.5)
        end
        love.graphics.printf('pickaxe (10 coins)', 80, VIRTUAL_HEIGHT / 2 - 10, 270, 'left')

        love.graphics.setColor(255, 255, 255, 1)
        love.graphics.printf('Press Enter to choose', 60, VIRTUAL_HEIGHT / 2 + 20, 270, 'left')
    else
        love.graphics.setColor(26/255, 33/255, 48/255, 0.3)
        love.graphics.rectangle("fill", 50, 120, 280, 90, 10)

        love.graphics.setFont(gFonts['small'])
        love.graphics.setColor(255, 255, 255, 1)

        love.graphics.printf('Sadly I have nothing new to the shop.', 60, VIRTUAL_HEIGHT / 2 + 20, 270, 'left')
        love.graphics.printf('Press Enter to exit', 60, VIRTUAL_HEIGHT / 2 + 60, VIRTUAL_WIDTH, 'left')
    end
end

function World:render()
    love.graphics.draw(gTextures['grass_background'], 0, 0, 0, 
    VIRTUAL_WIDTH / gTextures['grass_background']:getWidth(),
    VIRTUAL_HEIGHT / gTextures['grass_background']:getHeight())

    self.player:render()

    for k, entity in pairs(self.entities) do
        if entity.dead == false then
            entity:render(self.adjacentOffsetX, self.adjacentOffsetY)
        end
    end

    for k, object in pairs(self.game_objects) do
        if object.inPlay == 1 then
            object:render(self.adjacentOffsetX, self.adjacentOffsetY)
        end
    end

    if self.in_dialogue ~= 0 then
        if self.dialogue == 'SIGN' then
            self:signDialogue()
        elseif self.dialogue == 'W_CHEST' or self.dialogue == 'COINS' then
            self:rewardDialogue()
        elseif self.dialogue == 'RUBY' then
            self:rewardDialogue()
        elseif self.player.finishedAnimation == 1 and (self.dialogue == 'ROCK' or self.dialogue == 'TREE') then
            self:rewardDialogue()
        elseif self.dialogue == 'BOY' then
            self:sellShop()
        elseif self.dialogue == 'GIRL' then
            self:buyShop()
        elseif self.dialogue == 'BUY' then
            self:purchaseCompleted()
        end
    end
end