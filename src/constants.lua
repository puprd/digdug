--[[
    CS50 2D 2025
    Breakout Remake

    -- constants --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Some global constants for our application.
]] WINDOW_WIDTH = 600
WINDOW_HEIGHT = 650

quality = 12.5

VIRTUAL_WIDTH = 600
VIRTUAL_HEIGHT = 650
GRID = {} -- Main table

-- Initialize the 2D array with zeros
for i = 1, VIRTUAL_WIDTH / 50, 1 do
    GRID[i] = {} -- Create a new row table
    for j = 1, VIRTUAL_HEIGHT / 50, 1 do
        GRID[i][j] = 0
    end
end

HOLEGRID = {} -- Main table

-- Initialize the 2D array with zeros
for i = 1, VIRTUAL_WIDTH / quality, 1 do
    HOLEGRID[i] = {} -- Create a new row table
    for j = 1, VIRTUAL_HEIGHT / quality, 1 do
        HOLEGRID[i][j] = 0
    end
end
-- size we're trying to emulate with push


-- paddle movement speed
