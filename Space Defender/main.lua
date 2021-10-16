VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 272

WINDOW_WIDTH = 768
WINDOW_HEIGHT = 816

BUTTON_HEIGHT = 60

SHIP_VELOCITY = 150

BULLET_SPEED = 200

SHIP_X = 120
SHIP_Y = 200

timer_small = 0

game_timer = 0
-- install push and class into library
push = require 'push'

-- develop the UI
local function newButton(text, fn)
    return
    {
        text = text,
        fn = fn,

        now = false,
        last = false
    }
end

-- set up local variables & tables
local buttons = {}
local endButton = {}
local mainFont = nil


local objects = {}
local listOfBullets = {}
local enemies = {}

function love.load()
    -- spawn timer
    Stimer = 0
    Mtimer = 0
    Ltimer = 0

    total_points = 0
    -- default filter (make font clear)
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- load in classic to perform object oriented programming
    Object = require "classic"
    require "ship"
    require "enemy_small"
    require "enemy_mid"
    require "enemy_large"
    require "bullet"
    ship = ship()

    -- load in the necessary sounds
    sounds = {
        ['background'] = love.audio.newSource('sounds/background.mp3', 'static'),
        ['menu'] = love.audio.newSource('sounds/menu.mp3', 'static'),
        ['pew'] = love.audio.newSource('sounds/pew.mp3', 'static'),
        ['defeat'] = love.audio.newSource('sounds/defeat.mp3', 'static'),
        ['boom'] = love.audio.newSource('sounds/boom.mp3', 'static')
    }

    -- initialize mainfont
    mainFont = love.graphics.newFont('fonts/font.ttf', 20)

    gameOverFont = love.graphics.newFont('fonts/font.ttf', 60)
    -- set up screen
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    -- Set title for the file title (top right)
    love.window.setTitle('SPACE DEFENDER')
    
    -- set gamestate as 'menu'
    -- this is the default gamestate and will change based on
    -- which button is clicked
    gameState = 'menu'

    -- table (set name & function of each button)
    -- buttons
    table.insert(buttons, newButton(
        "Start Game",
        function()
            gameState = 'start'
        end))
    table.insert(buttons, newButton(
        "Exit",
        function()
            love.event.quit(0)
        end))
    table.insert(endButton, newButton(
    	"Retry",
    	function()
    		gameState = 'start'
    	end))

    background = love.graphics.newImage("backgrounds/desert-backgorund.png")
    background:setWrap("repeat", "repeat")
    quad = love.graphics.newQuad(0, 0, background:getWidth(), background:getHeight(), background:getWidth(), background:getHeight())
    y = 0
end 

function love.update(dt)

    ship:update(dt)
    
    for i, v in ipairs(listOfBullets) do
        v:update(dt)

        if v.dead then
            table.remove(listOfBullets, i)
        end
    end

    for i, v in ipairs(enemies) do
        v:update(dt)
        v:checkCollision(ship)

        if v.dead then
            table.remove(enemies, i)
        end
    end

    -- take in entities from 2 tables, check for collision
    for i, v in ipairs(listOfBullets) do
        for a, b in ipairs(enemies) do
            local entityA = v
            local entityB = b
            if collides(entityA, entityB) then
                entityA.dead = true
                entityB.hp = entityB.hp - 1
            elseif gameState == 'gameover' then
                table.remove(listOfBullets, i)
                table.remove(enemies, a)
            end
        end
    end

    -- keyboard controls for player
    if love.keyboard.isDown('s') then
        ship.y = ship.y + SHIP_VELOCITY * dt
    elseif love.keyboard.isDown('w') then
        ship.y = ship.y - SHIP_VELOCITY * dt
    elseif love.keyboard.isDown('a') then
        ship.x = ship.x - SHIP_VELOCITY * dt
    elseif love.keyboard.isDown('d') then
        ship.x = ship.x + SHIP_VELOCITY * dt
    end

    -- parameters for ship (don't leave the screen boundary)
    if ship.y < 0 then
        ship.y = 0
    elseif ship.y > VIRTUAL_HEIGHT - 20 then
        ship.y = VIRTUAL_HEIGHT - 20
    end

    if ship.x < 0 then
        ship.x = 0
    elseif ship.x > VIRTUAL_WIDTH - 16 then
        ship.x = VIRTUAL_WIDTH - 16
    end

    if ship.dead == true then
        gameState = 'gameover'
    end

    if gameState == 'start' then
        -- spawn timer for small enemy
        Stimer = Stimer + dt
        if Stimer >= 0.8 then
            table.insert(enemies, enemy_small(ship.x, 0))
            Stimer = 0
        end

        Mtimer = Mtimer + dt
        if Mtimer >= 1 then
            table.insert(enemies, enemy_mid(math.random(0, 224), 0))
            Mtimer = 0
        end

        Ltimer = Ltimer + dt
        if Ltimer >= 1.5 then
            table.insert(enemies, enemy_large(math.random(0, 224), 0))
            Ltimer = 0
        end
    end

    if enemy_large.dead == true then
        total_points = total_points + 5
    elseif enemy_mid.dead == true then
        total_points = total_points + 3
    elseif enemy_small.dead == true then
        total_points = total_points + 1
    end

    if gameState == 'start' then
        game_timer = game_timer + dt
    end
end

function love.draw()

    -- set the font to mainfont
    -- set backdrop colour
    love.graphics.setFont(mainFont)
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
 
    -- set local variables
    local margin = 8
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    local total_height = (BUTTON_HEIGHT + margin) * #buttons
    local cursor_y = 0
    local BUTTON_WIDTH =  ww * 1/2

    -- initialize menu
    -- will swap depending on what the gamestate is
    if gameState == 'menu' then
        for i, button in ipairs(buttons) do 

            button.last = button.now

            local bx = (ww * 0.5) - (BUTTON_WIDTH * 0.5)
            local by = (wh * 0.5) - total_height + cursor_y
                

            -- this is the original color
            local color = {0.4, 0.4, 0.5, 1.0}
                
            -- take in mouse position
            local mousex, mousey = love.mouse.getPosition()
                
            -- see if mouse is over the buttons
            local hot = mousex > bx and mousex < bx + BUTTON_WIDTH and
                            mousey > by and mousey < by + BUTTON_HEIGHT


            if hot then
                    -- if mouse is over button, light up button
                color = {0.8, 0.8, 0.9, 1.0}
            end
                
            button.now = love.mouse.isDown(1)
            if button.now and not button.last and hot then
                button.fn()
            end

            love.graphics.setColor(unpack(color))
            love.graphics.rectangle(
                'fill', 
                bx,
                by,
                BUTTON_WIDTH,
                BUTTON_HEIGHT
            )

            love.graphics.setColor(0, 0, 0, 1)

            local TEXT_WIDTH = mainFont:getWidth(button.text)
            local TEXT_HEIGHT = mainFont:getHeight(button.text)

            love.graphics.print(
                button.text, 
                mainFont, 
                (ww * 0.5) - (TEXT_WIDTH * 0.5), 
                by * 1.05 + TEXT_HEIGHT * 0.5
            )
                
            cursor_y = cursor_y + (BUTTON_HEIGHT + margin)

            love.graphics.setColor(255, 255, 255, 1)
        end

    -- if game starts, draw these
    elseif gameState == 'start' then
        -- scale everything up by 3 to match screen size
        love.graphics.scale(3,3)

        -- draw the background
        y = y - 0.5
        quad:setViewport(0, y, background:getWidth(), background:getHeight())
        love.graphics.draw(background, quad, 0, 0, 0)

        -- draw the necessary assets
        ship:draw()

        for i, v in ipairs(listOfBullets) do
            v:draw()
        end

        for i, v in ipairs(enemies) do
            v:draw()
        end

            -- play background music
            sounds['background']:setLooping(true)
            sounds['background']:play()
    elseif gameState == 'gameover' then
        sounds['background']:stop()
        sounds['defeat']:setLooping(false)
        sounds['defeat']:play()

        love.graphics.clear(40/255, 45/255, 52/255, 255/255)
        love.graphics.print('GAME OVER', gameOverFont, 216, 150)
        love.graphics.print(math.floor((game_timer * 10) / 10).. ' seconds', gameOverFont, 216, 260)

        for i, button in ipairs(endButton) do 

            button.last = button.now

            local bx = (ww * 0.5) - (BUTTON_WIDTH * 0.5)
            local by = (wh * 0.5) - total_height + cursor_y
                

            -- this is the original color
            local color = {0.4, 0.4, 0.5, 1.0}
                
            -- take in mouse position
            local mousex, mousey = love.mouse.getPosition()
                
            -- see if mouse is over the buttons
            local hot = mousex > bx and mousex < bx + BUTTON_WIDTH and
                            mousey > by and mousey < by + BUTTON_HEIGHT


            if hot then
                    -- if mouse is over button, light up button
                color = {0.8, 0.8, 0.9, 1.0}
            end
                
            button.now = love.mouse.isDown(1)
            if button.now and not button.last and hot then
                button.fn()
            end

            love.graphics.setColor(unpack(color))
            love.graphics.rectangle(
                'fill', 
                bx,
                by,
                BUTTON_WIDTH,
                BUTTON_HEIGHT
            )

            love.graphics.setColor(0, 0, 0, 1)

            local TEXT_WIDTH = mainFont:getWidth(button.text)
            local TEXT_HEIGHT = mainFont:getHeight(button.text)

            love.graphics.print(
                button.text, 
                mainFont, 
                (ww * 0.5) - (TEXT_WIDTH * 0.5), 
                by * 1.05 + TEXT_HEIGHT * 0.5
            )
                
            cursor_y = cursor_y + (BUTTON_HEIGHT + margin)

            love.graphics.setColor(255, 255, 255, 1)
        end
    end
end

function love.keypressed(key)
    if key == "space" then
        --Put a new instance of Bullet inside listOfBullets.
        sounds['pew']:stop()
        sounds['pew']:play()
        table.insert(listOfBullets, bullet(ship.x, ship.y))
    end
end

function collides(entityA, entityB)
    if entityA.x < entityB.x + entityB.width and 
    entityB.x < entityA.x + entityA.width and 
    entityA.y < entityB.y + entityB.height and 
    entityB.y < entityA.y + entityA.height then
        return true
    elseif entityA == nil or entityB == nil then
        return false
    end
end

