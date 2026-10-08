require "src.Dependencies"
local ship = nil
local krell
local shipx
local shipy
local shipwidth
local shipheight
local laser
local krells = {}
local shiphealth = 50
local shieldhealth = 20
local damagecooldown = 0.5
--local explosionTimer = 0
--local explosionFrame = 1
local laserx
local lasery
local lasers = {}
local krelllasers = {}
local shootCooldown = 0
local shootDelay = 0.8
local explodingcooldown = 0.069
local explosionFrames = {}
for i = 1, 3, 1 do
   table.insert(krells, {
        explodingframe = 1,
        x = (i - 1) * 100,
        y = 0,
        type = "stationary",
        lasercooldown = 0.8,
        laserfire = false,
        exploding = false,
        explodingcooldown = explodingcooldown ,
    })
end
function love.load()
    for row = 0, 3 do
        for col = 0, 3 do
            table.insert(explosionFrames,
                love.graphics.newQuad(col * 612 / 4, row * 408 / 4, 612 / 4, 408 / 4 , 612, 408))
        end
    end
    love.graphics.setBackgroundColor(0 / 255, 0 / 255, 0 / 255)
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {
        upscale = "normal"
    })

    -- background = love.graphics.newImage("background.png")
    ship = love.graphics.newImage("spaceship.png")
    laser = love.graphics.newImage("laser.png")
    krell = love.graphics.newImage("krell.png")
    shipwidth = ship:getWidth() * (ship:getWidth() / (VIRTUAL_WIDTH * VIRTUAL_HEIGHT / 2400))
    shipheight = ship:getHeight() * (ship:getHeight() / (VIRTUAL_WIDTH * VIRTUAL_HEIGHT / 2002))
    shipx = VIRTUAL_WIDTH / 2 - shipwidth / 2
    shipy = VIRTUAL_HEIGHT - 80
end

function love.draw()
    love.graphics.print("Ship Health: " .. shiphealth, 0, 20)
    love.graphics.print("Shield Health: " .. shieldhealth, 0, 40)
    --love.graphics.draw(krell, explosionFrames[explosionFrame], 0, 0)

    local scalewidth = ship:getWidth() / (VIRTUAL_WIDTH * VIRTUAL_HEIGHT / 2400)
    local scaleheight = ship:getHeight() / (VIRTUAL_WIDTH * VIRTUAL_HEIGHT / 2002)
    love.graphics.draw(ship, shipx, shipy, 0, scalewidth, scaleheight)
    for i, l in ipairs(lasers) do
        l.y = l.y - 5
        love.graphics.draw(laser, l.x - 7, l.y + 20, 0, 0.1, 0.1)
        if l.y <= 0 then
            table.remove(lasers, i)
        end
        for j, k in ipairs(krells) do
            if (l.y <= k.y ) and (l.x >= k.x + 612 / 8 - 25 and l.x <= k.x + 612 / 8 + 15) then
                k.exploding = true
                table.remove(lasers, i)
                break
            end
        end

    end
    for i, k in ipairs(krells) do
        
        love.graphics.draw(krell, explosionFrames[k.explodingframe], k.x, k.y, 0)
        if k.explodingframe >= #explosionFrames then
            table.remove(krells, i)
        end
    end
    for i, l in ipairs(krelllasers) do
        l.y = l.y + 5
        love.graphics.draw(laser, l.x, l.y + 20, 0, 0.1, 0.1)
        if l.y >= VIRTUAL_HEIGHT then
            table.remove(krelllasers, i)
        end
        love.graphics.print("a",  l.x + 27, l.y + 40)
        if  (l.y + 40 >=  shipy + shipheight / 2 + 10 and l.y + 40 <= shipy + shipheight / 2 + 30) and (l.x + 27 >= shipx + shipwidth / 2 - 17 and l.x + 27<= shipx + shipwidth / 2 + 17) then
            -- Handle collision with the ship here
            if shieldhealth > 0 then
                if damagecooldown <= 0 then
                    shieldhealth = shieldhealth - 5
                    damagecooldown = 0.5
                end
            else
                if damagecooldown <= 0 then
                    shiphealth = shiphealth - 5
                    damagecooldown = 0.5
                end
            end
        end
    
    end
end
function love.update(dt)
    if damagecooldown > 0 then
        damagecooldown = damagecooldown - dt
  
    end
    for i, k in ipairs(krells) do
        k.lasercooldown = k.lasercooldown - dt
        if k.lasercooldown <= 0 then
            k.lasercooldown = 0.8
            if k.exploding == false then
            table.insert(krelllasers, {
                x = k.x + 612 / 8 - 17,
                y = k.y + 60 
            })
        end

        end
        if k.exploding then
            k.explodingcooldown = k.explodingcooldown - dt
            if k.explodingcooldown <= 0 then
                k.explodingframe = k.explodingframe + 1
                k.explodingcooldown = explodingcooldown
            end
        end
        if k.type == "targeting" then

        end
    end
    --explosionTimer = explosionTimer + dt

    -- if explosionTimer >= 0.08 then
    --     explosionTimer = explosionTimer - 0.08
    --     explosionFrame = explosionFrame + 1
    --     if explosionFrame > #explosionFrames then
    --         explosionFrame = #explosionFrames
    --     end
    -- end
 
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
        laserx = shipx + shipwidth / 2 - laser:getWidth() * 0.1 / 2
        lasery = shipy - laser:getHeight() * 0.1
        table.insert(lasers, {
            x = laserx,
            y = lasery
        })

    end
end
