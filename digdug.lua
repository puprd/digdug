-- --[[
--     Bird Class
--     Author: Colton Ogden
--     cogden@cs50.harvard.edu

--     The Bird is what we control in the game via clicking or the space bar; whenever we press either,
--     the bird will flap and go up a little bit, where it will then be affected by gravity. If the bird hits
--     the ground or a pipe, the game is over.
-- ]] digdug = Class {}
-- local sx = 0.2 -- VIRTUAL_WIDTH / 1500--2183.33
-- local sy = 0.2 -- VIRTUAL_HEIGHT / 1625--2408.333333333333333333333333333333333333333333333333333333333
-- local GRAVITY = 980

-- function digdug:init()
--     self.image = love.graphics.newImage("digdug.png")

--     self.x = VIRTUAL_WIDTH / 2 - 8
--     self.y = VIRTUAL_HEIGHT / 2 - 8

--     self.width = digdug:getWidth() * sx / 2
--     self.height = digdug:getHeight() * sx / 2
--     -- hi
-- end

-- --[[
--     AABB collision that expects a pipe, which will have an X and Y and reference
--     global pipe width and height values.
-- ]]



-- function digdug:render()
--     love.graphics.print("hi")
--     love.graphics.draw(self.image, self.x, self.y)
    
-- end

-- digdug:init()
-- digdug:render()