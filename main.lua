function love.load()
    -- Array/Object of the player containing info about it (speed, coordinates, etc)
    player = {}
    -- This is the coordinate of a player
    player.coords = {}
    player.coords.x = 0
    -- This is how fast they will go along the x axis (speed)
    player.speed = 5
    -- These are the bullets (Lets call them Dot) that the player will shoot out of their "Dot Launcher"
end

function love.update(dt)
    if love.keyboard.isDown("right") then
        player.coords.x = player.coords.x + player.speed
    elseif love.keyboard.isDown("left") then
        player.coords.x = player.coords.x - player.speed
    end
end

function love.draw()
    love.graphics.rectangle("fill", x, 584, 80, 15)
end