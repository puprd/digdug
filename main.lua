-- WINDOW_WIDTH = 500
-- WINDOW_HEIGHT = 550 
require 'src.Dependencies'
local background
local hole
local digdug
local digdugx = VIRTUAL_WIDTH / 2
local digdugy = 0
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
        upscale = "stretched"
    })

    background = love.graphics.newImage("background.png")
    digdug = love.graphics.newImage("digdug.png")
    hole = love.graphics.newImage("blockhole.png")
end
local function printgrid()
    for i = 1, 30, 1 do
        for j = 1, 30, 1 do
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
    local sx = VIRTUAL_WIDTH / background:getWidth()
    local sy = VIRTUAL_HEIGHT / background:getHeight()

    love.graphics.draw(background, 0, 0, 0, sx, sy)
    local sx = 0.2 -- VIRTUAL_WIDTH / 1500--2183.33
    local sy = 0.2 -- VIRTUAL_HEIGHT / 1625--2408.333333333333333333333333333333333333333333333333333333333
    -- each block = 50
    -- 12 x 12 block map
    local digdugwidth = digdug:getWidth() * sx / 2
    local digdugheight = digdug:getHeight() * sx / 2
    -- love.graphics.print(digdug:getWidth() * sx, 0, 0)
    -- love.graphics.print(holeS)
    -- --printgrid()
    -- for i = 2.5, 25, 1 do
    --     love.graphics.draw(hole, 0, i * 20, 0, holeS, holeS)
    -- end
    -- hi
    local holeS = 25 / 57 -- 0.4386

    love.graphics.draw(digdug, digdugx - digdugwidth, digdugy, 0, sx, sy)
    if HOLE == true then
        love.graphics.draw(hole, holex, holey, 0, holeS, holeS)
    end
    love.graphics.print(digdugy)
    push:finish()
            HOLE = false

end
local function drawhole(digdugx, digdugy)
    if digdugy % 20 == 0 and digdugy > 50 then
        HOLE = true
        holex = digdugx
        holey = digdugy
    end
end
function love.update()
    if love.keyboard.isDown('down') then
        digdugy = digdugy + 5

        drawhole(digdugx, digdugy)
    end
    
end
