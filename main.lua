-- Basket position and size
local basket = { x = 400, y = 550, width = 100, height = 20, baseSpeed = 300 }

-- Falling object
local object = { x = math.random(0, 800), y = 0, speed = 200, width = 20, height = 20 }

-- Score and loss tracking
local score = 0
local losses = 0
local maxLosses = 10
local gameOver = false

-- Load game
function love.load()
    love.window.setTitle("Catch the Falling Objects")
    love.window.setMode(800, 600, {  resizable = true, vsync = 0 })
    love.window.maximize()
    love.mouse.setVisible(false) -- Hide the cursor at the start
end


-- Update game logic
function love.update(dt)
    if gameOver then return end -- Stop updates if game over

    -- Dynamically increase basket speed
    local basketSpeed = basket.baseSpeed + (object.speed * 0.5)

    -- Move basket
    if love.keyboard.isDown("left") then
        basket.x = basket.x - basketSpeed * dt
    elseif love.keyboard.isDown("right") then
        basket.x = basket.x + basketSpeed * dt
    end

    -- Prevent basket from moving out of bounds
    basket.x = math.max(0, math.min(basket.x, 800 - basket.width))

    -- Move falling object
    object.y = object.y + object.speed * dt

    -- Check for collision
    if object.y + object.height >= basket.y and
       object.x + object.width > basket.x and
       object.x < basket.x + basket.width then
        score = score + 1
        object.y = 0
        object.x = math.random(0, 800 - object.width)
        object.speed = object.speed + 10 -- Increase difficulty
    end

    -- Check if object is missed
    if object.y > 600 then
        object.y = 0
        object.x = math.random(0, 800 - object.width)
        losses = losses + 1 -- Increment losses

        -- Check for game over
        if losses >= maxLosses then
            gameOver = true
            love.mouse.setVisible(true) -- Show the cursor when the game is over
        end
    end
end

-- Handle mouse input for restart button
function love.mousepressed(x, y, button)
    if gameOver and button == 1 then -- Left mouse button
        if x >= 300 and x <= 500 and y >= 250 and y <= 300 then
            restartGame()
        end
    end
end

-- Restart the game
function restartGame()
    score = 0
    losses = 0
    object.y = 0
    object.speed = 200
    gameOver = false
    love.mouse.setVisible(false) -- Hide the cursor again when restarting
end

-- Draw game objects
function love.draw()
    if gameOver then
        -- Draw "Game Over" screen
        love.graphics.setColor(1, 1, 1) -- White
        love.graphics.printf("Game Over", 0, 200, 800, "center")
        love.graphics.printf("Score: " .. score, 0, 230, 800, "center")
        love.graphics.printf("Losses: " .. losses, 0, 260, 800, "center")

        -- Draw restart button
        love.graphics.setColor(0, 0.5, 1) -- Blue
        love.graphics.rectangle("fill", 300, 250, 200, 50)
        love.graphics.setColor(1, 1, 1) -- White
        love.graphics.printf("Restart", 300, 260, 200, "center")
        return
    end

    -- Draw basket
    love.graphics.setColor(0, 1, 0) -- Green
    love.graphics.rectangle("fill", basket.x, basket.y, basket.width, basket.height)

    -- Draw falling object
    love.graphics.setColor(1, 0, 0) -- Red
    love.graphics.rectangle("fill", object.x, object.y, object.width, object.height)

    -- Draw score and losses
    love.graphics.setColor(1, 1, 1) -- White
    love.graphics.print("Score: " .. score, 10, 10)
    love.graphics.print("Losses: " .. losses .. "/" .. maxLosses, 10, 30)
end
