--[[ 

    dotlauncher is a game inspired by Space Invaders. It is not made to recreate but simulate an experience similar to it.
    It was made for me (SamuraiStacks) to learn Lua, Love2D and what it's like to actually develop a game from scratch.

    dotlauncher © SamuraiStacks 2019

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.

    You are NOT allowed to:
    i. Copy any of this code and use it in your own projects without full credit.
    ii. Distribute a modified version of this application claiming it is entirely your work.
--]]

-- Here is the object containing enemy information (speed, coordinates, etc)
enemy = {}
enemy.coords = {}
enemies_ai = {}
enemies_ai.enemies = {}

-- Loading config here for multiple reasons
config = require("config")

function love.load()

    WW, WH = love.graphics:getDimensions()

    scale = 4
    -- Makes images not so blurry
    love.graphics.setDefaultFilter("nearest", "nearest")

    --[[
        These right here are just some images that we will load to use in our game.
        Instead of making stuff from rectangles and other shapes, we can use assets made in a app specifically for creating pixel art.
        Not everything will be pictures though, as the bullet can still be generated.
    ]]--
    background = love.graphics.newImage("background.png")

    dotlauncher_logo = love.graphics.newImage("dotlauncher.png")

    enemy_ship = love.graphics.newImage("ship.png")

    -- Since we need a new font, we got one on itch.io lol
    font = love.graphics.newFont("m5x7.ttf", 55)
    love.graphics.setFont(font)

    -- Instead of just saying "Untitled" at the top of the window, we can have it say our game name and version.
    love.window.setTitle("dotlauncher - v"..config.version)
    --[[
        So, to make a main menu we will have to have a different "state" for the game.
        My plan is to make it so there are 3 types of states:
        i. Game state
        ii. Main menu state
        iii. Pause menu state

        All this variable does is make it so we can know what state the game is currently in.
    ]]--
    state = "menu"
    -- All the code about the player itself is up here
    -- Array/Object of the player containing info about it (speed, coordinates, etc)
    player = {}

    player.image = love.graphics.newImage("dolta.png")
    player.width = player.image:getWidth() * scale
    player.height = player.image:getHeight() * scale

    -- This is the coordinate of a player
    player.coords = {}
    player.coords.x = 0
    player.coords.y = 470
    -- This is how fast they will go along the x axis (speed)
    player.speed = 300
    -- In order to stop the player from shooting a beam but instead an actual dot, we will add a cooldown to shoot
    player.cooldown = 22
    -- These are the bullets (Lets call them Dot) that the player will shoot out of their "Dot Launcher"
    player.dots = {}
    -- And here we will launch (fire/shoot) them
    player.launch = function()
        -- If the cooldown does ever reach 0 then it will set it back to the default
        if player.cooldown <= 0 then 
            player.cooldown = 22
            dot = {}
            dot.width = 10
            dot.height = 10
            dot.x = player.coords.x + 54
            dot.y = player.coords.y + 2
            table.insert(player.dots, dot)
        end
    end

    player.draw = function()
        -- Code here relates to the player
        -- Renders a character
        love.graphics.draw(player.image, player.coords.x, player.coords.y, 0, scale, scale)
        -- Makes anything here white
        love.graphics.setColor(1, 1, 1)
        -- A FPS counter for debugging purposes (which idk)
        love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 640, 10)
        -- The loop down here checks if the launch function is called and makes a drawing of a bullet
        for _, d in pairs(player.dots) do
            love.graphics.rectangle("fill", d.x, d.y, 10, 10)
        end
    end

    player.update = function(dt)
        -- All of this code relates to the player
        -- Here it will reduce the cooldown to 0
        player.cooldown = player.cooldown - 1
        -- Here it will move to the right if the right arrow is pressed/held
        if love.keyboard.isDown("right") then
            player.coords.x = player.coords.x + player.speed * dt
        -- And will do the same thing above except to the left
        elseif love.keyboard.isDown("left") then
            player.coords.x = player.coords.x - player.speed * dt
        end

        if player.coords.x < 0 then player.coords.x = 0 end
        if player.coords.x + player.width > WW then player.coords.x = WW - player.width end

        -- Shoots the bullets if space is held down/pressed
        if love.keyboard.isDown("space") then
            -- This function here will fire a dot
            player.launch()
        end
    end

    -- This is where all the code for the enemy firing and other stuff will be
    -- The code can be similar to the players' but without input from a keyboard (multiplayer could be made uwu)

    -- Here is a function that whenever it is called it will spawn an enemy on screen
    function enemies_ai:spawn(xc, yc)
        enemy = {}
        enemy.coords = {}
        enemy.height = 80
        enemy.width = 15
        enemy.coords.x = xc
        enemy.coords.y = yc
        enemy.speed = 5
        enemy.cooldown = 22
        table.insert(self.enemies, enemy)
    end

    -- This snippet of code right here spawns multiple enemies at once (in this case 5)
    for i = 0, 5 do
        enemies_ai:spawn(i * 100, 0)
    end
end

function collisionDetection(enemies, dots)
    for i, e in ipairs(enemies) do
        for _, d in pairs(dots) do
            if d.y + d.height <= e.coords.y and d.x > e.coords.x and e.coords.x < d.x + d.width then
                return table.remove(enemies, i)
            end
        end
    end
end

function love.draw()
    -- Loads in the background and uses it all the time
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(background, 0, 0)

    --[[ 
        If the game has just been launched, it will immediately be in the menu state.
        Here we will just create a simple menu where if the user presses Enter, it will start the game.
    --]]
    if state == "menu" then
        love.graphics.draw(dotlauncher_logo, 170, 30, 0, 8, 8)
        love.graphics.print("Press \"Enter\" to start!", 195, 480)
    elseif state == "p_menu" then
        love.graphics.print("Paused!", 340, 250)
        love.graphics.print("Press \"Enter\" to continue!", 190, 300)
    else
        player.draw()
        -- Code here relates to the enemies
        -- Renders an enemy anytime the spawn function is called
        for _, e in pairs(enemies_ai.enemies) do
            love.graphics.draw(enemy_ship, e.coords.x + 100, e.coords.y, 0, 6)
        end
    end
end

function love.update(dt)
    if state == "menu" then
        return
    elseif state == "p_menu" then
        return
    else
        -- All this loop here does is that anytime the launch function is called it will make it so that the bullet moves
        -- Without this, the first loop below in our draw function will only create a dot but it will not move
        for _, d in pairs(player.dots) do
            d.y = d.y - 10
        end

        
        -- This code here relates to the enemy
        for _, e in pairs(enemies_ai.enemies) do
            e.coords.y = e.coords.y + 0.8
        end

        -- Checks if the dots have hit the enemy
        collisionDetection(enemies_ai.enemies, player.dots)

        player.update(dt)
    end
end

function love.keypressed(key)
    if key == "return" then
        state = "game"
    end
    if key == "e" then love.event.quit() end
    -- "Pauses the game"
    if key == "escape" and state == "game" then
        state = "p_menu"
    end
end
