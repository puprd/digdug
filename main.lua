-- WINDOW_WIDTH = 500
-- WINDOW_HEIGHT = 550 
require 'src.Dependencies'
local background
local hole
local digdug
local directionx = 0
local state = "dig"
local directiony = 0
local dug
local digdugx = 300
local digdugy = 25
local digdugorient = 0
local HOLE = false
local holex = 0
local holey = 0

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {
        upscale = "normal"
    })

    background = love.graphics.newImage("background.png")
    digdug = love.graphics.newImage("digdug.png")
    dug = love.graphics.newImage("dug.png")
    hole = love.graphics.newImage("blockhole.png")
end
local function printholegrid()
    for i = 1, 600 / quality, 1 do
        for j = 1, 650 / quality, 1 do
            love.graphics.print(HOLEGRID[i][j], i * 10, j * 10) -- Set the default value
        end
    end
end
local function printgrid()
    for i = 1, 600 / 50, 1 do
        for j = 1, 650 / 50, 1 do
            love.graphics.print(GRID[i][j], i * 10, j * 10) -- Set the default value
        end
    end
end
-- function love.resize(w, h)
--     push.resize(w, h)
-- en

-- love.graphics.draw(gTextures['background'], 0, 0)
-- local backgroundWidth = gTextures['background']:getWidth()
-- local backgroundHeight = gTextures['background']:getHeight()

-- love.graphics.draw(gTextures['background'],
--     -- draw at coordinates 0, 0
--     0, 0,
--     -- no rotation
--     0,
--     -- scale factors on X and Y axis so it fills the screen
--     1.9, 1.9
function love.draw()
    push:start()
    
    love.graphics.print(background:getWidth(), 0, 30)
    local sx = VIRTUAL_WIDTH / background:getWidth()

    local sy = VIRTUAL_HEIGHT / background:getHeight()
    love.graphics.draw(background, 0, 0, 0, sx, sy)
    local sx = 0.2 -- VIRTUAL_WIDTH / 500--2183.33i
    local sy = 0.2 -- VIRTUAL_HEIGHT / 1625--2408.333333333333333333333333333333333333333333333333333333333
    -- each block = 50
    -- 12 x 12 block map
    local digdugwidth = digdug:getWidth() * sx / 2
    local digdugheight = digdug:getHeight() * sx / 2
    -- love.graphics.print(digdug:getWidth() * sx, 0, 0)
    -- love.graphics.print(holeS)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, 25, 650)
    love.graphics.rectangle("fill", 625, 0, 175, 650)
    love.graphics.setColor(1, 1, 1)
    printgrid()
    -- for i = 2.5, 25, 1 do
    --     love.graphics.draw(hole, 0, i * 20, 0, holeS, holeS)
    -- end
    -- hi
    local holeS = 25 / 64.5

    for i = 1, 600 / quality, 1 do
        for j = 1, 650 / quality, 1 do
            if HOLEGRID[i][j] == 1 then
                love.graphics.draw(hole, i * quality - digdugwidth, j * quality + 40 - digdugheight, 0, holeS, holeS)
            end
        end
    end

    local gridX = (digdugx - digdugx % quality) / quality
    local gridY = (digdugy - digdugy % quality) / quality
    -- love.graphics.print(gridX + directionx)
    -- love.graphics.print(gridY + directiony, 0, 200)
    love.graphics.print(digdugy, 0, 500)
    love.graphics.print(directiony, 0, 600)

    if HOLEGRID[gridX + directionx][gridY + directiony] == 1 then
        love.graphics.draw(dug, digdugx - digdugwidth - 5, digdugy - digdugheight, digdugorient, sx / 2 + 0.021, sy / 2 + 0.021)
        -- love.graphics.print(HOLEGRID[digdugx / quality + directionx][digdugy / quality + directiony], 0, 50)
    else
        love.graphics.draw(digdug, digdugx - digdugwidth, digdugy - digdugheight, digdugorient, sx - 0.001, sy - 0.001)
        state = "dig"
    end

    -- love.graphics.print(digdugx, 0, 10)
    push:finish()

end
local function drawhole(digdugx, digdugy)
    --digdugx = digdugx - 25
    if digdugy % quality == 0 and digdugx % quality == 0 and digdugy >= 50 then
        HOLEGRID[digdugx / quality][digdugy / quality - 1] = 1
    end
    if digdugy % 50 == 0 and digdugx % 50 == 0 and digdugy >= 50 then
        GRID[digdugx / 50][digdugy / 50 - 1] = 1
    end
end
local function resetdirection(x, y)
    directionx = x
    directiony = y
end
function love.update()

    if love.keyboard.isDown('down') and digdugy < 600 then
        if digdugx % 50 == 0 then
            digdugy = digdugy + 2.5
            resetdirection(0, 1)
        end
        -- digdugorient = -0.5
        drawhole(digdugx, digdugy)
    end
    if love.keyboard.isDown('up') and digdugy > 25 then
        if digdugx % 50 == 0 then
            digdugy = digdugy - 2.5
            resetdirection(0, -1)
        end

        drawhole(digdugx, digdugy)
    end
    if love.keyboard.isDown('left') and digdugx > 50 then
        if digdugy % 50 == 0 then
            digdugx = digdugx - 2.5
            resetdirection(-1, 0)

        end

        drawhole(digdugx, digdugy)
    end
    if love.keyboard.isDown('right') and digdugx < 600 then
        if digdugy % 50 == 0 then
            digdugx = digdugx + 2.5
            resetdirection(1, 0)

        end
        
        drawhole(digdugx, digdugy)
    end
end
