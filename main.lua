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
        enemy.coords.x = xc
        enemy.coords.y = yc
        enemy.speed = 5
        enemy.cooldown = 22
        table.insert(self.enemies, enemy)
    end

    for i = 0, 10 do
        enemies_ai:spawn(i * 100, 0)
    end

    print(enemy)
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
    -- Without this, the loop below will only create a dot but it will not move
    for _, d in pairs(player.dots) do
        d.y = d.y - 10
    end

    
    -- This code here relates to the enemy
    for _, e in pairs(enemies_ai.enemies) do
        e.coords.y = e.coords.y + 0.8
    end
end

function love.draw()
    -- Code here relates to the player
    -- Renders a character
    love.graphics.rectangle("fill", player.coords.x, player.coords.y, 80, 15)
    -- The loop down here checks if the launch function is called and makes a drawing of a bullet
    for _, d in pairs(player.dots) do
        love.graphics.rectangle("fill", d.x, d.y, 10, 10)
    end

    -- Code here relates to the enemies
    -- Renders an enemy anytime the spawn function is called
    love.graphics.setColor(255, 0, 0)
    for _, e in pairs(enemies_ai.enemies) do
        love.graphics.rectangle("fill", e.coords.x, e.coords.y, 80, 15)
    end
end