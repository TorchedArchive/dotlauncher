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

function love.load()
    -- All the code about the player itself is up here
    -- Array/Object of the player containing info about it (speed, coordinates, etc)
    player = {}
    -- This is the coordinate of a player
    player.coords = {}
    player.coords.x = 0
    player.coords.y = 582
    -- How high and wide the rendered player will be
    player.height = 80
    player.width = 15
    -- This is how fast they will go along the x axis (speed)
    player.speed = 5
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
            dot.x = player.coords.x + 35
            dot.y = player.coords.y - 4
            table.insert(player.dots, dot)
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
                table.remove(enemies, i)
            end
        end
    end
end

function love.update(dt)
    -- All of this code relates to the player
    -- Here it will reduce the cooldown to 0
    player.cooldown = player.cooldown - 1
    -- Here it will move to the right if the right arrow is pressed/held
    if love.keyboard.isDown("right") then
        player.coords.x = player.coords.x + player.speed
    -- And will do the same thing above except to the left
    elseif love.keyboard.isDown("left") then
        player.coords.x = player.coords.x - player.speed
    end

    -- Shoots the bullets if space is held down/pressed
    if love.keyboard.isDown("space") then
        -- This function here will fire a dot
        player.launch()
    end

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
end

function love.draw()
    -- Code here relates to the player
    -- Gives the player a blue color
    love.graphics.setColor(0.2, 0.576, 1)
    -- Renders a character
    love.graphics.rectangle("fill", player.coords.x, player.coords.y, player.height, player.width)
    -- The loop down here checks if the launch function is called and makes a drawing of a bullet
    -- Makes the bullets white
    for _, d in pairs(player.dots) do
        love.graphics.rectangle("fill", d.x, d.y, 10, 10)
    end

    -- Code here relates to the enemies
    -- Renders an enemy anytime the spawn function is called
    for _, e in pairs(enemies_ai.enemies) do
        love.graphics.rectangle("fill", e.coords.x, e.coords.y, e.height, e.width)
    end
end