require "src.Dependencies"
local ship = nil
local krell
local shipx
local shipy
local shipwidth
local shipheight
 
lifebuster= nil
local bossy = VIRTUAL_HEIGHT / 2 - 300
local bossx = VIRTUAL_WIDTH / 2 - 50
local locked = "right"

local damage = false
local boss
local bosscooldown = 3
-- local globalcooldown = 1
-- local healingcooldown = 10
local laser
local titlefont = love.graphics.newFont("pixelfont.ttf", 40)
local title = true
local krells = {}
local shiphealth = 40
local shieldhealth = 20 -- initial shield health
local damagecooldown = 0.5
local pixelfont = love.graphics.newFont("pixelfont.ttf", 16)
-- local explosionTimer = 0
-- local explosionFrame = 1
local level = 1
-- local laserx
-- local lasery
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
    lifebuster = love.graphics.newImage("lifebuster.png")
    shipwidth = ship:getWidth() * (ship:getWidth() / (VIRTUAL_WIDTH * VIRTUAL_HEIGHT / 2400))
    shipheight = ship:getHeight() * (ship:getHeight() / (VIRTUAL_WIDTH * VIRTUAL_HEIGHT / 2002))
    shipx = VIRTUAL_WIDTH / 2 - shipwidth / 2
    shipy = VIRTUAL_HEIGHT - 80

    newlevel()
end
local message = ""
local messageTimer = 0
local timers = {}
table.insert(timers, 1, {
    time = 10,
    name = "healingcooldown",
    ogtime = 10
})
table.insert(timers, 2, {
    time = 1,
    name = "redflashcooldown",
    ogtime = 1
})
table.insert(timers, 3, {
    time = 0.5,
    name = "shielddowncooldown",
    ogtime = 0.5
})
function showMessage(text, duration)
    message = text
    messageTimer = duration or 1
end
function takedamage()
    damage = true
    if shieldhealth > 0 then
        if damagecooldown <= 0 then
            shieldhealth = shieldhealth - 10
            damagecooldown = 0.5
        end
    else
        if damagecooldown <= 0 then
            shiphealth = shiphealth - 10
            damagecooldown = 0.5
        end
    end
end
function wait(time)
    local start = love.timer.getTime()
    while love.timer.getTime() - start < time do
        love.event.pump()
        love.timer.sleep(0.01)
    end
end
function newlevel()
    local types = {}
    if level == 1 then
        types = {"stationary", "fixedright", "stationary"}
    end
    if level == 2 then
        types = {"stationary", "targeting", "stationary", "mirror", "stationary"}
    end
    if level == 3 then
        types = {"stationary", "targeting", "mirror", "stationary", "targeting"}
    end
    if level == 4 then
        types = {"stationary", "fixedleft", "targeting", "fixedright", "stationary"}
    end
    if level == 5 then
        boss = "lifebuster"
        types = {"stationary", "stationary", "laser", "laser", "stationary", "stationary"}
    end
    level = level + 1
    krells = {}
    for i = 1, #types, 1 do
        table.insert(krells, { -- krell traits
            explodingframe = 1,
            x = (i - 1) * 100,
            y = 0,
            type = types[i],
            lasercooldown = 0.8,
            laserfire = false,
            exploding = false,
            explodingcooldown = explodingcooldown,
            shield = true,
            shieldjustbroken = false,
            shieldcooldown = 0.5,
            locked = "right"
        })
    end
end
function love.draw()

    if title then

        love.graphics.setFont(titlefont)
        love.graphics.printf("SKYWARD FLIGHT", 0, VIRTUAL_HEIGHT / 2 - 60, VIRTUAL_WIDTH, "center") -- how do I make the text bigger? answer: 
        love.graphics.setFont(pixelfont)
        love.graphics.printf("Press Enter to Start", 0, VIRTUAL_HEIGHT / 2 + 20, VIRTUAL_WIDTH, "center")
        return
    end
    love.graphics.setFont(pixelfont)
    love.graphics.print("Ship Health: " .. shiphealth, 400, 20)
    love.graphics.print("Shield Health: " .. shieldhealth, 400, 40)

    if messageTimer > 0 then
        love.graphics.printf(message, 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, "center")
    end
    if messageTimer > 0 then
        messageTimer = messageTimer - love.timer.getDelta()
        if messageTimer <= 0 then
            message = ""
        end
    end
    -- love.graphics.draw(krell, explosionFrames[explosionFrame], 0, 0)

    local scalewidth = ship:getWidth() / (VIRTUAL_WIDTH * VIRTUAL_HEIGHT / 2400)
    local scaleheight = ship:getHeight() / (VIRTUAL_WIDTH * VIRTUAL_HEIGHT / 2002)

    if damage then
        love.graphics.setColor(1, 0, 0)
    end

    love.graphics.draw(ship, shipx, shipy, 0, scalewidth, scaleheight)
    love.graphics.setColor(1, 1, 1)
    for i, l in ipairs(lasers) do

        love.graphics.draw(laser, l.x, l.y + 20, 0, 0.1, 0.1)
        l.y = l.y - 5
        love.graphics.setColor(0, 0.5, 1)

        -- love.graphics.rectangle("line", l.x + 28, l.y + 30, 0.01 * laser:getWidth(), 0.08 * laser:getHeight())

        love.graphics.setColor(1, 1, 1)
        if l.y <= 0 then
            table.remove(lasers, i)
        end
        --love.graphics.rectangle("line", bossx + 40, bossy + 160, lifebuster:getWidth() * 0.3, lifebuster:getHeight() * 0.1)
        if checkCollision(l.x + 28, l.y + 50, 0.01 * laser:getWidth(), 0.04 * laser:getHeight(), bossx + 40, bossy + 160, lifebuster:getWidth() * 0.3, lifebuster:getHeight() * 0.1) and boss then
            table.remove(lasers, i)
        end
        for j, k in ipairs(krells) do
            -- if (l.y <= k.y and l.y >= k.y - 40) and (l.x >= k.x + 612 / 8 - 50 and l.x <= k.x + 612 / 8 + 25) then
            if checkCollision(l.x + 28, l.y + 50, 0.01 * laser:getWidth(), 0.04 * laser:getHeight(), k.x + 55, k.y + 60,
                612 / 8 - 10, 40) and (not k.exploding) and (not (k.type == "laser" and boss == "lifebuster")) then
                if k.shield then
                    k.shield = false
                    k.shieldjustbroken = true
                else
                    k.exploding = true
                end
                table.remove(lasers, i)
                -- x1, y1, w1, h1, x2, y2, w2, h2
            end

            -- end
        end

    end

    for i, k in ipairs(krells) do
        love.graphics.setColor(1, 1, 0)

        -- love.graphics.rectangle("line", k.x + 65, k.y + 60, 612 / 8 - 30, 40)

        love.graphics.setColor(1, 1, 1)
        if k.shieldjustbroken then
            love.graphics.setColor(0, 0, 1)
        end
        love.graphics.draw(krell, explosionFrames[k.explodingframe], k.x, k.y, 0)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("a", 0, shipy + shipheight / 2 + 10)
        love.graphics.print("a", 0, shipy + shipheight / 2 + 30)
        love.graphics.print("y", k.x, k.y)
        love.graphics.print("x", k.x, k.y)
        -- if (shipy - shipheight / 2 <= k.y + 40 and shipy + shipheight / 2 >= k.y and shipx - shipwidth / 2 <= k.x + 612 /
        --     8 and shipx + shipwidth / 2 >= k.x) and (k.exploding == false) then -- (k.y >= shipy + shipheight / 2 + 10 and k.y + 40 <= shipy + shipheight / 2 + 30) and (shipx  >= k.x + 612 / 8 - 25 and shipx + shipwidth + 10 <= k.x + 612 / 8 + 15) then 
        --     takedamage()
        -- end
        if checkCollision(k.x + 65, k.y + 60, 612 / 8 - 30, 40, shipx + 10, shipy + 10, shipwidth - 20, shipheight - 30) and
            k.exploding == false then
            takedamage()
        end
        if k.explodingframe >= #explosionFrames then
            table.remove(krells, i)
        end
    end
    if boss then
        if bosscooldown > 0 then
            -- love.graphics.push() how do i make a variable global? 
            love.graphics.setFont(titlefont)
            love.graphics.print("THE " ..  string.upper(boss), VIRTUAL_WIDTH / 4 + 10, VIRTUAL_HEIGHT / 2 - 50)
            love.graphics.setFont(pixelfont)
            -- love.graphics.pop()
        else
            love.graphics.print(boss)
            love.graphics.draw( _G[boss], bossx, bossy, 0, 0.5, 0.5)-- bad argument 1 to draw. How do I fix this ? the answer is to make sure that the global variable with the name stored in `boss` exists and is a valid drawable object (like an image). it is. but sometimes the image might not be loaded yet or there could be a typo in the variable name. It is loaded and there is no type. but you also need to ensure that the image is fully loaded before attempting to draw it. it is, it isn't. but 
            --love.graphics.print(locked, 0, 0)
        end
    end
    for i, l in ipairs(krelllasers) do
        love.graphics.setColor(1, 0, 0)
        -- love.graphics.rectangle(
        --     "line",
        --     l.x + 28, 
        --     l.y + 50,    
        --     0.01 * laser:getWidth(),
        --     0.04 * laser:getHeight()
        -- )
        love.graphics.setColor(1, 1, 1)

        l.y = l.y + 5
        love.graphics.draw(laser, l.x, l.y + 20, 0, 0.1, 0.1)
        if l.y >= VIRTUAL_HEIGHT then
            table.remove(krelllasers, i)
        end
        love.graphics.print("a", l.x + 27, l.y + 40)
        -- Draw the enemy laser hitbox in red
        love.graphics.rectangle("line", shipx + 10, shipy + 10, shipwidth - 20, shipheight - 30)

        if checkCollision(l.x + 30, l.y + 20, 0.01 * laser:getWidth(), 0.08 * laser:getHeight(), shipx + 10, shipy + 10,
            shipwidth - 20, shipheight - 30) then
            takedamage()
            table.remove(krelllasers, i)
            break
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

    if boss == "lifebuster" then
        if locked == "right" then

            bossx = bossx + 3
            if bossx >= VIRTUAL_WIDTH - 50 then
                locked = "left"

            end

        end
        if locked == "left" then
            bossx = bossx - 3
            if bossx <= 0 then
                locked = "right"
            end
        end

    end

    bosscooldown = bosscooldown - dt
    for _, timer in ipairs(timers) do
        timer.time = timer.time - dt

        if timer.time <= 0 then
            if timer.name == "healingcooldown" then
                if not boss then
                shieldhealth = shieldhealth + 5
                end
            end
            if timer.name == "redflashcooldown" then
                damage = false
            end

            timer.time = timer.ogtime
        end
    end
    for _, k in ipairs(krells) do
        if k.shieldjustbroken then
            k.shieldcooldown = k.shieldcooldown - dt
            if k.shieldcooldown <= 0 then
                k.shieldjustbroken = false
                k.shieldcooldown = 0.5
            end
        end
    end
    if shieldhealth < 0 then
        shieldhealth = 0
    end

    if title then
        if love.keyboard.isDown("return") then
            title = false

        end
    end
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
            -- if globalcooldown <= 0 then
            --     globalcooldown = 1
            --     k.shieldjustbroken = false
            -- end
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
        if k.type == "fixedright" then
            k.x = k.x + 2
            k.y = k.y + 2
            if k.x > VIRTUAL_WIDTH then
                k.x = 0
                k.y = 0
            end
        end
        if k.type == "fixedleft" then
            k.x = k.x - 2
            k.y = k.y + 2
            if k.x < 0 then
                k.x = VIRTUAL_WIDTH
                k.y = 0
            end
        end
        if k.type == "laser" then
            if boss == "lifebuster" then
                k.x = bossx + 10
                k.y = bossy + 100
                k.exploding = false
                k.shieldjustbroken = false
                k.explodingframe = 1
            else
                if k.locked == "right" then

                    bossx = bossx + 3
                    if bossx >= VIRTUAL_WIDTH - 50 then
                        k.locked = "left"

                    end

                end
                if k.locked == "left" then
                    bossx = bossx - 3
                    if bossx <= 0 then
                        k.locked = "right"
                    end
                end
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
        table.insert(lasers, {
            x = shipx + shipwidth / 2 - laser:getWidth() * 0.1 / 2,
            y = shipy - laser:getHeight() * 0.1
        })

    end
end
