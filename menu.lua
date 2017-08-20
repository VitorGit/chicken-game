require "worldUtilities"

local menuImage = love.graphics.newImage( "sprites/GameOver.png" )
local fontSize = 27
local menuFont = love.graphics.newFont("fonts/bit.ttf", fontSize)

local menuScaleX = love.graphics.getWidth() / menuImage:getWidth()
local menuScaleY = love.graphics.getHeight() / menuImage:getHeight()

local buttonX, buttonY = love.graphics.getWidth()/3, love.graphics.getHeight()/3

local buttonW = menuFont:getWidth("Begin")
local buttonH = menuFont:getHeight()

local r,g,b = 255,255,255
local redLoop, greenLoop, blueLoop = true, false, false

menuUpdate = function()
	local x, y = love.mouse.getX(), love.mouse.getY()
	
	if pointInRectangle(x, y, buttonX, buttonY, buttonW, buttonH) and love.mouse.isDown(1) then
	menu = false
	end
	
	if redLoop then
		r = r - 1
		if r <= 30 then 
			r = 255
			redLoop, greenLoop = false, true
		end
	end
	
	if greenLoop then
		g = g - 1
		if g <= 30 then 
			g = 255
			greenLoop, blueLoop = false, true
		end
	end
	
	if blueLoop then
		b = b - 1
		if b <= 30 then 
			b = 255
			blueLoop, redLoop = false, true
		end
	end
end

menuDraw = function()
   love.graphics.setColor(r, g, b)
   love.graphics.rectangle( "fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
   
   love.graphics.setFont(menuFont)
   love.graphics.setColor(255, 20, 20)
   love.graphics.print( "Space TKen 2000", relative(0.3, 0.1))
   love.graphics.print( "Begin", buttonX, buttonY)
   love.graphics.print( "W e seta para cima para subir", relative(0, 0.5))
   love.graphics.print( "S e seta para baixo para descer", relative(0, 0.6))
end