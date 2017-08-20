print("bar.lua loaded")

require "love.graphics"
require "entityManager"
require "worldUtilities"
vector = require "hump.vector"

local AlL, AlR

local image = love.graphics.newImage("sprites/bar_image.png")
local w, h = image:getWidth(), image:getHeight()

local rot = math.rad(180)
local old_rot = rot
local scale = 1

local center = vector.new(offX, offY)
local old_offX, old_offY = offX, offY
local lockDist = 95

local corners = rectCorners(center, w, h) --the four cornes of the rectangle
local rotdCorners = corners

local function setCenter(side)
--change the center of the rectangle which change the center of the rotation
--and the position of the four corners
	if side == "left" then offX, offY = 0, h/2
	pos = AlR.getPivot()
	end
	
	if side == "right" then offX, offY = w, h/2
	pos = AlL.getPivot()
	end
	
	center = vector.new(offX, offY)
end

local function updateRotation()
	if not AlL.isMoving() and not AlR.isMoving() then return end

	if AlL.isMoving() then 
		setCenter("left")
		rot = math.atan2(AlL.getPivot().y - pos.y, AlL.getPivot().x - pos.x)
	end
	if AlR.isMoving() then
		setCenter("right")
		rot = math.atan2(pos.y - AlR.getPivot().y,  pos.x - AlR.getPivot().x)
	end
end

local function updateCorners()
	if offX ~= old_offX or offY ~= old_offY then --calculate new corners only when the center changes
		corners = rectCorners(center, w, h)
		rotdCorners = rotateRectCorners(corners, rot)
		old_offX, old_offY = offX, offY
	end
	
	if rot ~= old_rot then --calculate the corners only when the rotation changes
		rotdCorners = rotateRectCorners(corners, rot)
		old_rot = rot
	end
end

local function checkLock()
	if AlL.getPos().y - AlR.getPos().y > lockDist then --L cannot go down, R cannot go up
		AlL.downLock()
		AlR.upLock()
	return true end
	
	if AlR.getPos().y - AlL.getPos().y > lockDist then --L cannot go up, R cannot go down
		AlL.upLock()
		AlR.downLock()
	return true end
	
	AlL.unlock()
	AlR.unlock()
	return false
end

return {
	init = function(AlienL, AlienR) --constructor
				AlL, AlR = AlienL, AlienR --keeps a reference to both aliens
				setCenter("left")
			end,
	
	draw = function()
				love.graphics.setColor(255, 255, 255, 255)
				love.graphics.draw(image, pos.x, pos.y, rot, scale, scale, offX, offY)
				
				---[[show collision box on the screen
				love.graphics.setColor(255, 255, 255)
				if showDebug then 
				love.graphics.setFont(normalFont)
				love.graphics.print("w "..w.." h "..h)
				love.graphics.print("x "..pos.x.." y "..pos.y, 0 , textSpacing * 1)
				love.graphics.print("AlPX ".. AlL.getPivot().x.." AlPY ".. AlL.getPivot().y, 0, textSpacing * 2)
				love.graphics.print("ARPX ".. AlR.getPivot().x.." ARPY ".. AlR.getPivot().y, 0, textSpacing * 3)
				
				love.graphics.print("topLeft ".. corners.topLeft.x.."  ".. corners.topLeft.y, 0, textSpacing * 4)
				love.graphics.print("downLeft ".. corners.topLeft.x.."  ".. corners.topLeft.y, 0, textSpacing * 5)
				love.graphics.print("topRight ".. corners.topRight.x.."  ".. corners.topRight.y, 0, textSpacing * 6)
				love.graphics.print("downRight ".. corners.downRight.x.."  ".. corners.downRight.y, 0, textSpacing * 7)
				
				love.graphics.print("lockdist1 ".. AlL.getPos().y - AlR.getPos().y, 0, textSpacing * 8)
				love.graphics.print("lockdist2 ".. AlR.getPos().y - AlL.getPos().y, 0, textSpacing * 9)
				love.graphics.print("islock1 ".. tostring(AlL.getLock()).." "..tostring(AlL.getLock1()), 0, textSpacing * 10)
				love.graphics.print("islock2 ".. tostring(AlR.getLock()).." "..tostring(AlR.getLock1()), 0, textSpacing * 11)
				
				love.graphics.print("offX ".. offX.." offY ".. offY, 0, textSpacing * 12)
				love.graphics.print("rot "..math.deg(rot), 0, textSpacing * 13)
				love.graphics.print("topMiddleX ".. pos.x + corners.topMiddle.x.." topMiddleY ".. pos.y + corners.topMiddle.y, 0, textSpacing * 14)
				end
				if showCollis then 
				love.graphics.circle("fill", pos.x, pos.y, 5)
				love.graphics.circle("fill", pos.x + rotdCorners.topLeft.x, pos.y + rotdCorners.topLeft.y, 5)
				love.graphics.circle("fill", pos.x + rotdCorners.downLeft.x, pos.y + rotdCorners.downLeft.y, 5)
				love.graphics.circle("fill", pos.x + rotdCorners.topRight.x, pos.y + rotdCorners.topRight.y, 5)
				love.graphics.circle("fill", pos.x + rotdCorners.downRight.x, pos.y + rotdCorners.downRight.y, 5)
				love.graphics.circle("fill", pos.x + rotdCorners.topMiddle.x, pos.y + topMiddle.y, 5) end
			end,
			
	update = function(dt)
				if checkLock() then return end
				updateRotation()
				updateCorners()
			end,
	
	getPos = function() return pos end, --allow those fields to be acessed from outside the table
	w = function() return w end,
	h = function() return h end,
	topLeft = function() return pos + rotdCorners.topLeft end,
	topRight = function() return pos + rotdCorners.topRight end,
	topMiddle = function() return pos + rotdCorners.topMiddle end,
	rotation = function() return rot end,
	
} --return (end of file)