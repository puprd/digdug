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
local locked = 0
local damagecooldown = 0.5
local pixelfont = love.graphics.newFont("pixelfont.ttf", 16)
-- local explosionTimer = 0
-- local explosionFrame = 1
local level = 1
local laserx
local lasery
local lasers = {}
local krelllasers = {}
local shootCooldown = 0
local shootDelay = 0.8
local explodingcooldown = 0.069
local explosionFrames = {}
local function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x1 + w1 > x2 and y1 < y2 + h2 and y1 + h1 > y2
end
function love.load()
    for row = 0, 3 do
        for col = 0, 3 do
            table.insert(explosionFrames,
                love.graphics.newQuad(col * 612 / 4, row * 408 / 4, 612 / 4, 408 / 4, 612, 408))
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
    newlevel()
end
function takedamage()
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
function newlevel()

    local types = {}
    if level == 1 then
        types = {"stationary", "stationary", "stationary"}
    end
    krells = {}
    for i = 1, #types, 1 do
        table.insert(krells, {
            explodingframe = 1,
            x = (i - 1) * 100,
            y = 0,
            type = types[i],
            lasercooldown = 0.8,
            laserfire = false,
            exploding = false,
            explodingcooldown = explodingcooldown
        })
    end
end
function love.draw()
    love.graphics.setFont(pixelfont)
    love.graphics.print("Ship Health: " .. shiphealth, 400, 20)
    love.graphics.print("Shield Health: " .. shieldhealth, 400, 40)
    -- love.graphics.draw(krell, explosionFrames[explosionFrame], 0, 0)

    local scalewidth = ship:getWidth() / (VIRTUAL_WIDTH * VIRTUAL_HEIGHT / 2400)
    local scaleheight = ship:getHeight() / (VIRTUAL_WIDTH * VIRTUAL_HEIGHT / 2002)
    love.graphics.draw(ship, shipx, shipy, 0, scalewidth, scaleheight)
    for i, l in ipairs(lasers) do
        love.graphics.draw(laser, l.x, l.y + 20, 0, 0.1, 0.1)
        l.y = l.y - 5
        love.graphics.setColor(0, 0.5, 1)

love.graphics.rectangle(
    "line",
    l.x + 28,
    l.y + 30,
    0.01 * laser:getWidth(),
    0.08 * laser:getHeight()
)

love.graphics.setColor(1, 1, 1)
        if l.y <= 0 then
            table.remove(lasers, i)
        end

        for j, k in ipairs(krells) do
            -- if (l.y <= k.y and l.y >= k.y - 40) and (l.x >= k.x + 612 / 8 - 50 and l.x <= k.x + 612 / 8 + 25) then
            if checkCollision(l.x + 28, l.y + 30, 0.01 * laser:getWidth(), 0.08 * laser:getHeight(), k.x + 55, k.y + 60, 612 / 8 - 10, 40) then
                k.exploding = true
                table.remove(lasers, i)
                -- x1, y1, w1, h1, x2, y2, w2, h2
            end

            -- end
        end

    end

    for i, k in ipairs(krells) do
        love.graphics.setColor(1, 1, 0)

love.graphics.rectangle(
    "line",
    k.x + 60,
    k.y + 60,
    612 / 8 - 20,
    40 
)

love.graphics.setColor(1, 1, 1)
        love.graphics.draw(krell, explosionFrames[k.explodingframe], k.x, k.y, 0)
        love.graphics.print("a", 0, shipy + shipheight / 2 + 10)
        love.graphics.print("a", 0, shipy + shipheight / 2 + 30)
        love.graphics.print("y", k.x, k.y)
        love.graphics.print("x", k.x, k.y)
        if shipy - shipheight / 2 <= k.y + 40 and shipy + shipheight / 2 >= k.y and shipx - shipwidth / 2 <= k.x + 612 /
            8 and shipx + shipwidth / 2 >= k.x then -- (k.y >= shipy + shipheight / 2 + 10 and k.y + 40 <= shipy + shipheight / 2 + 30) and (shipx  >= k.x + 612 / 8 - 25 and shipx + shipwidth + 10 <= k.x + 612 / 8 + 15) then 
            takedamage()
        end
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
        love.graphics.print("a", l.x + 27, l.y + 40)
        -- Draw the enemy laser hitbox in red

        if checkCollision(l.x + 30, l.y + 20, 0.01 * laser:getWidth(), 0.08 * laser:getHeight(), shipx, shipy,
            shipwidth, shipheight) then
            takedamage()
        end
        -- if ((l.y + 40 >= shipy + shipheight / 2 + 10 and l.y + 40 <= shipy + shipheight / 2 + 30) and
        --     (l.x + 27 >= shipx + shipwidth / 2 - 30 and l.x + 27 <= shipx + shipwidth / 2 + 17) )then
        --     -- Handle collision with the ship here
        --     takedamage()
        -- end
        -- x1, y1, w1, h1, x2, y2, w2, h2
    end
end
function love.update(dt)
    if #krells == 0 then
        newlevel()
    end
    if damagecooldown > 0 then
        damagecooldown = damagecooldown - dt

    end
    for i, k in ipairs(krells) do
        k.lasercooldown = k.lasercooldown - dt
        if k.lasercooldown <= 0 then
            k.lasercooldown = 0.8
            -- if k.type == "targeting" then
            --     k.lasercooldown = 0.5
            -- end
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
        if k.type == "mirror" then
            k.x = shipx - shipwidth / 2
        end
        if k.type == "targeting" then

            if shipx - shipwidth / 2 > k.x then

                -- repeat
                k.x = k.x + 2
                k.y = k.y + 2

                -- until k.y >= shipy
                -- -- k.y = 0

            else
                -- repeat
                k.x = k.x - 2
                k.y = k.y + 2
                -- until k.y >= shipy

                -- -- k.y = 0
            end
            if k.y >= VIRTUAL_HEIGHT - 10 or k.x >= VIRTUAL_WIDTH - 612 / 8 then
                k.y = 0
                k.x = VIRTUAL_WIDTH / 2 - 612 / 8
            end

        end
    end
    -- explosionTimer = explosionTimer + dt

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
