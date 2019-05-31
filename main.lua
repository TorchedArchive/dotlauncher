function love.load()
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
end

function love.update(dt)
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
end

function love.draw()
    love.graphics.rectangle("fill", player.coords.x, player.coords.y, 80, 15)
    -- The loop down here checks if the launch function is called and makes a drawing of a bullet
    for _, d in pairs(player.dots) do
        love.graphics.rectangle("fill", d.x, d.y, 10, 10)
    end
end
