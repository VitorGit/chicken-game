 require "Rocks"
require "entityManager"

local rockImage = love.graphics.newImage( "sprites/rock.png" )
local x
local y
local xq
local yq
local larg
local alt

local w, h = rockImage:getWidth() * 0.2, rockImage:getHeight() * 0.2
 
 return {
 draw = function ()
  love.graphics.draw(rockImage, x, y, 0, 0.2, 0.2)
  
  if showCollis then
  love.graphics.rectangle("line", x, y, w, h)
  love.graphics.circle("fill", x, y, 5) end
 end,
 
 getRockWH = function() return w,h end, 
 getRockXY = function() return x,y end,
 
construtor = function (xquad,yquad, largura, altura)
	x = math.random(xquad, xquad + largura)
	y = math.random(yquad, yquad + altura)
	yq = yquad
	xq = xquad
	larg = largura
	alt = altura
end, 

update = function (dt)
	y = y + dt * vel
	
	if y > love.graphics.getHeight() then
		y = math.random(yq, yq + alt)
		x = math.random(xq, xq + larg)
	
	end
end
}