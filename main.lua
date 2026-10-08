require "src.Dependencies"
local ship = nil
local shipx
local shipy
local shipwidth
local shipheight
local laser
local laserx
local lasery
local lasers = {}
local shootCooldown = 0
local shootDelay = 0.3
function love.load()
    love.graphics.setBackgroundColor(0 / 255, 0 / 255, 0 / 255)
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {
        upscale = "normal"
    })
   
    --background = love.graphics.newImage("background.png")
    ship = love.graphics.newImage("spaceship.png")
    laser = love.graphics.newImage("laser.png")
    shipwidth = ship:getWidth() * (ship:getWidth() / (VIRTUAL_WIDTH * VIRTUAL_HEIGHT / 2002))
    shipheight = ship:getHeight() * (ship:getHeight() / (VIRTUAL_WIDTH * VIRTUAL_HEIGHT / 2002))
    shipx = VIRTUAL_WIDTH / 2 - shipwidth / 2 
    shipy = VIRTUAL_HEIGHT - 80
end

function love.draw()
        love.graphics.print(shipx .. ", " .. shipy, 0, 0)
    local scalewidth =  ship:getWidth() / (VIRTUAL_WIDTH * VIRTUAL_HEIGHT / 2002)
    local scaleheight =  ship:getHeight() / (VIRTUAL_WIDTH * VIRTUAL_HEIGHT / 2002)
    love.graphics.draw(ship, shipx, shipy, 0, scalewidth, scaleheight)
    for i, l in ipairs(lasers) do
        l.y = l.y - 5
        love.graphics.draw(laser, l.x - 7, l.y + 20, 0, 0.1, 0.1)
        if l.y <= 0 then
            table.remove(lasers, i)
        end
        
    end
end
function love.update(dt)
    if love.keyboard.isDown('left') and shipx > 0 then
        shipx = shipx - 3
    end
    if love.keyboard.isDown('right') and shipx < VIRTUAL_WIDTH - shipwidth then
        shipx = shipx + 3
    end
    if love.keyboard.isDown('up') and shipy > 0 then
        shipy = shipy - 3
    end
    if love.keyboard.isDown('down') and shipy < VIRTUAL_HEIGHT - shipheight then
        shipy = shipy + 3
    end
    shootCooldown = shootCooldown - dt
    if love.keyboard.isDown('space') and shootCooldown <= 0 then
        shootCooldown = shootDelay
        laserx = shipx + shipwidth / 2 - laser:getWidth() * 0.1 /2 
        lasery = shipy - laser:getHeight() * 0.1
        table.insert(lasers, {x = laserx, y = lasery})
       
        
    end
end