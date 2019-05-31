function love.load()
    -- Array/Object of the player containing info about it (speed, coordinates, etc)
    player = {}
    -- This is the coordinate of a player
    player.coords = {}
    player.coords.x = 0
    -- This is how fast they will go along the x axis (speed)
    player.speed = 5
    -- These are the bullets (Lets call them Dot) that the player will shoot out of their "Dot Launcher"
    player.dots = {}
    -- And here we will launch (fire/shoot) them
    player.launch = function()
        dot = {}
        dot.x = player.coords.x
        dot.y = 584
        table.insert(player.dots, dot)
    end
end

function love.update(dt)
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

    for _, d in pairs(player.dots) do
        d.y = d.y - 10
    end
end

function love.draw()
    love.graphics.rectangle("fill", player.coords.x, 584, 80, 15)
    for _, d in pairs(player.dots) do
        love.graphics.rectangle("fill", d.x, d.y, 10, 10)
    end
end