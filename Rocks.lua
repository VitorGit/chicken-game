rocks = {}
rock_inst = love.filesystem.load("Rock.lua")
vel = 100
local backx, backy = 0, 0
local backx2, backy2 = 0, 0
local backh

local raiz
function createRock(number)
math.randomseed(os.time() * 10000)
	local raiz = math.ceil(math.sqrt(number))
	local larguraQuad = love.graphics.getWidth()/raiz
	local alturaQuad = -love.graphics.getHeight()/raiz
	local espacamento = larguraQuad/8
	
	local xquad = 0
	local yquad = 0 
	
	for cont = 1, number, 1 do
		rocks[cont] = rock_inst()
		rocks[cont].construtor(xquad + espacamento, yquad + espacamento, larguraQuad - espacamento, alturaQuad - espacamento)
		
		xquad = xquad + larguraQuad
		if cont%raiz == 1 then
			xquad = 0
			yquad = yquad + alturaQuad
		end
	end
		
end

function rockCollision(x1,y1,w1,h1)
	local x, y 
	local w, h
	for cont = 1, #rocks,1 do
		x, y = rocks[cont].getRockXY() 
		w, h = rocks[cont].getRockWH()
		if CheckCollision(x1,y1,w1,h1, x,y,w,h) then return true end
	end
	
	return false
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function updateRock(dt)
	for cont = 1, #rocks, 1 do
		rocks[cont].update(dt)
	end
end

function drawRock()
	for cont = 1, #rocks, 1 do
		rocks[cont].draw()
	end	
end

function backLoad()
	background = love.graphics.newImage( "sprites/ground.png" )

   backScaleX = love.graphics.getWidth() / background:getWidth()
   backScaleY = love.graphics.getHeight() / background:getHeight()

	swap = true
	
	backh = background:getHeight() * backScaleY
end

function move(y, dt)
	return y + dt * vel
end

function backUpdate(dt)
	if backy > love.graphics.getHeight() then
		backy = 0
		swap = not swap
	end
	
	if backy2 > love.graphics.getHeight() then
		backy2 = 0
		swap = not swap
	end
	
	if swap then
		backy = move(backy, dt)
		backy2 = backy - backh
	else
		backy2 = move(backy2, dt)
		backy = backy2 - backh
	end
end
function backDraw()
	love.graphics.setColor(255, 255, 255, 255)
   love.graphics.draw(background, backx, backy, 0, backScaleX, backScaleY)
   love.graphics.draw(background, backx2, backy2, 0, backScaleX, backScaleY)
end