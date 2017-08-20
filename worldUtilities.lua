--functions created to provide basic functionality to the game
-- like collision detection etc

--[[DOCUMENTATION

checks collision for squares and rectangles
returns 1 boolean
CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)

checks if a point is inside a given area
returns 1 boolean
pointInRectangle(pointx, pointy, rectx, recty, rectwidth, rectheight)

rotates an object smoothly towards a given angle
returns 1 number: angle
smooth(goal, current, dt)

returns the new position of a point that has been rotate
overload of the last one, takes a vector intead of XY numbers
return 1 vector: p
rotatedPoint(p, radians)

gives the position of the 4 corners of a rectangle relative to its center
takes a table containing 4 vectors
returns a table containing 4 vectors: topLeft, topRight, downLeft, downRight
rectCorners(center, w, h, scale)

rotates the 4 corners of a rectangle by a given angle
takes a table containing 4 vectors
returns a table containing 4 vectors: topLeft, topRight, downLeft, downRight
rotateRectCorners(center, corners, radians)

prevents a graphical object from transpassing the window
vector pos need to be at the TOP LEFT corner of the rectangle/square
returns 1 vector: pos
boundToWindow(pos, w, h

--this function should be called by the love.load() event
configWindow()

--shows FPS, mouse position etc
showDebugInfo(projectName)
-------------------------------------------------------------------------------------------------]]

require "love.keyboard"
vector = require "hump.vector"

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function pointInRectangle(pointx, pointy, rectx, recty, rectwidth, rectheight)
    return pointx > rectx and 
			pointy > recty and 
			pointx < rectx + rectwidth and 
			pointy < recty + rectheight
end

function smooth(goal, current, dt)
  local diff = (goal-current+math.pi)%(2*math.pi)-math.pi --checking if there's a different between the goal and the current
  if(diff>dt)then --this means that we still need to speed up
    return current + dt
  end
  if(diff<-dt)then --and this means we need to slow down
    return current - dt
  end
  return goal --if diff equals 0 then just return goal
end

function rotatedPoint(p, radians)
	--X = x*cos(θ) - y*sin(θ)
	--Y = x*sin(θ) + y*cos(θ)
	local x = p.x * math.cos(radians) - p.y * math.sin(radians)
	local y = p.x * math.sin(radians) + p.y * math.cos(radians)
	return vector.new(x, y)
end

function rectCorners(center, w, h)
--center must in in LOCAL coordinates
	local leftX = -center.x
	local rightX = w - center.x
	
	local topY = -center.y
	local bottomY = h - center.y
	
	topLeft, topRight = vector.new(leftX, topY), vector.new(rightX, topY)
	downLeft, downRight = vector.new(leftX, bottomY), vector.new(rightX, bottomY)
	topMiddle = vector.new(w/2 - rightX, -center.y)
	
	return {topLeft = topLeft, topRight = topRight, downLeft = downLeft, downRight = downRight, topMiddle = topMiddle}
end

function rotateRectCorners(corners, radians)
	topLeftRotd = rotatedPoint(corners.topLeft, radians)
	downLeftRotd = rotatedPoint(corners.downLeft, radians)
	topRightRotd = rotatedPoint(corners.topRight, radians)
	downRightRotd = rotatedPoint(corners.downRight, radians)
	
	topMiddleRotd = rotatedPoint(corners.topMiddle, radians)
	
	return {topLeft = topLeftRotd, topRight = topRightRotd, downLeft = downLeftRotd, downRight = downRightRotd, topMiddle = topMiddleRotd}
end

function configWindow()
	normalFont = love.graphics.newFont(15)
	bigFont = love.graphics.newFont(20)
	
	love.graphics.setFont(normalFont)
	
	windowX, windowY = 720, 480
	
	love.window.setMode(windowX, windowY)
	
	WMargin, HMargin = love.graphics.getWidth()/10, love.graphics.getHeight()/10
	textSpacing = 20

    love.graphics.setBackgroundColor(0,0,0)
end

function boundToWindow(pos, w, h)
	--vector pos need to be at the TOP LEFT corner of the rectangle/square
	
	local borderX, borderY = love.graphics.getWidth(), love.graphics.getHeight()
	
	if pos.x + w > borderX then pos.x = borderX - w end
	if pos.x < 0 then pos.x = 0 end 
	
	if pos.y + h > borderY then pos.y = borderY - h end
	if pos.y < 0 then pos.y = 0 end

	return pos
end

function relative(w_percent, h_percent)
	return love.graphics.getWidth() * w_percent, love.graphics.getHeight() * h_percent
end

function showDebugInfo(projectName)
	love.graphics.setColor(255, 255, 255)
	love.graphics.setFont(normalFont)
    love.graphics.print(projectName..": ", WMargin * 6, HMargin * 6)
    love.graphics.print("Mouse X: "..love.mouse.getX().."Mouse Y: "..love.mouse.getY(), WMargin * 6, HMargin * 6 + textSpacing)
    love.graphics.print("Frame Rate: "..love.timer.getFPS(), WMargin * 6, HMargin * 6 + textSpacing * 2)
end