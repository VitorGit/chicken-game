print("chicken.lua loaded")

require "love.graphics"
require "entityManager"
require "worldUtilities"
require "spriteManager"
vector = require "hump.vector"

local eggImage = love.graphics.newImage("sprites/egg.png")
local eggScale = 0.1
local eggw, eggh = eggImage:getWidth() * eggScale, eggImage:getHeight()* eggScale

local distance, isMoving, isMovingL, isMovingR, AlL, AlR, barC, pos, leftDir, rightDir
local life = 5
local immortal = false
local elpTime = 0
local immortalTime = 3

local chickenSprite = GetInstance ("chickenSprite.lua")
chickenSprite.size_scale = 0.2
local w = chickenSprite.w * chickenSprite.size_scale
local h = chickenSprite.h * chickenSprite.size_scale

local speed = 1
local aceler = 50
				
--movey away from other entities when touched
local function move(p, dt)
	local isMoving = false
	distance = p - pos
	if distance:len() > 10 then
		local step = distance / distance:len()
		pos = pos + (step * speed * dt)
		isMoving = true
	end
	return pos, isMoving --boundToWindow(pos, w, h)
end

return {
	draw = function()
				if immortal == false then love.graphics.setColor(255, 255, 255, 255) else
				love.graphics.setColor(150, 150, 150, 150) end
				love.graphics.setFont(normalFont)
				
				DrawInstance (chickenSprite, pos.x, pos.y)
				
				--eggs
				love.graphics.setColor(255, 255, 255, 255)
				for i = 1, life do love.graphics.draw(eggImage, love.graphics.getWidth() - eggw * i, eggh/4, 0, eggScale, eggScale) end
				
				love.graphics.setColor(255, 255, 255)
				
				if showCollis then
				love.graphics.rectangle("line", pos.x, pos.y, w, h)
				love.graphics.circle("fill", pos.x, pos.y, 5)
				
				love.graphics.circle("fill", leftDir.x, leftDir.y, 5)
				love.graphics.circle("fill", rightDir.x, rightDir.y, 5)
				
				if isMovingL then love.graphics.line(leftDir.x, leftDir.y, pos.x, pos.y) end
				if isMovingR then love.graphics.line(rightDir.x, rightDir.y, pos.x, pos.y) end
				end
				
				if showDebug then 
				love.graphics.print( "x: "..string.format("%.1f",pos.x).." y: "..string.format("%.1f",pos.y),
									WMargin * 6, HMargin * 6 + textSpacing * 3)
				love.graphics.print( "degree: "..string.format("%.1f", inclin),
									WMargin * 6, HMargin * 6 + textSpacing * 4)
				end
			end,
			
	update = function(dt)
				UpdateInstance(chickenSprite, dt)
				--directions
				leftDir = vector.new(barC.topLeft().x, barC.topLeft().y - h)
				rightDir = vector.new(barC.topRight().x, barC.topRight().y - h)
				--rotation
				degree = math.abs( math.deg(barC.rotation()) )
				
				inclin = math.abs(degree - 180)
				
				chickenSprite.rotation = barC.rotation() - math.rad(180)
				
				speed = inclin * aceler
				--movement
				isMovingL, isMovingR = false, false
				
				if barC.rotation() < 0 then
				pos, isMovingL = move(leftDir, dt) end
				
				if barC.rotation() > 0 then
				pos, isMovingR = move(rightDir, dt) end
				
				--collision
				if rockCollision(pos.x,pos.y,w,h) and immortal == false then 
					immortal = true
					elpTime = 0
					life = life - 1
				end

				if immortal == true then
					elpTime = elpTime + dt
					if elpTime > immortalTime then immortal = false end
				end
				--bar collision
				if CheckCollision(barC.getPos().x,barC.getPos().y,barC.w(),barC.h(), pos.x,pos.y,w,h) then pos.y = pos.y - 1 end
			end,
	
	setAliens = function(AlienL, AlienR)
				AlL, AlR = AlienL, AlienR --keeps a reference to both aliens
			end,
	
	setBar = function(b)
				barC = b --keeps a reference to the bar
				pos = vector.new(barC.topMiddle().x, barC.topMiddle().y - h)
				leftDir = vector.new(barC.topLeft().x, barC.topLeft().y - h)
				rightDir = vector.new(barC.topRight().x, barC.topRight().y - h)
			end,
			
	life = function() return life end
	
} --return (end of file)