--holds all objets in the game

require "love.graphics"
showDebug = false
showCollis = false

local obstacles = {}
gameOver = false

function loadEntities()
	alienL = love.filesystem.load("alien.lua")()
	alienL.init("left")
	
	alienR = love.filesystem.load("alien.lua")()
	alienR.init("right")
	
	bar = love.filesystem.load("bar.lua")()
	bar.init(alienL, alienR)
	
	alienL.setBar(bar)
	alienR.setBar(bar)
	
	chicken = love.filesystem.load("chicken.lua")()
	chicken.setAliens(alienL, alienR)
	chicken.setBar(bar)
end

function createObstacles(number)
	for i= #obstacles + 1,#obstacles + number,1 do
		--do something
	end
end

function updateEntities(dt)
	chicken.update(dt)
	alienL.update(dt)
	alienR.update(dt)
	bar.update(dt)
	
	if chicken.life() <= 0 then gameOver = true end
end
	
function drawEntities()
	chicken.draw()
	alienL.draw()
	alienR.draw()
	bar.draw()
end