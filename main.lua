
require "spriteManager" --Including the file
require "worldUtilities"
require "entityManager"
require "Rocks"
require "gameOver"
require "menu"

	local scaleX, scaleY = 1, 1

	--TODO: create class collisionBox to abstract and simplify the collision of all objects
	
function love.load()
   
   --windows
   love.window.setTitle("Space Chicken 2000")
   local imagedata = love.image.newImageData("sprites/icon.png")
   love.window.setIcon(imagedata)
   configWindow()
   
   --mouse
   cursor = love.mouse.newCursor("sprites/pointer.png", 0, 0)
   love.mouse.setCursor(cursor)
   
   loadEntities()
   
    backLoad()
	createRock(10)
	
	menu = true
end

function love.update(dt)
	if menu then menuUpdate() return end
	if gameOver then gameOverUpdate() return end
	
	if gameIsPaused then return end
	backUpdate(dt)
	updateRock(dt)
	updateEntities(dt)
end

function love.draw()
	love.graphics.scale(scaleX, scaleY)
	if menu then menuDraw() return end
	
	love.graphics.setColor(255, 255, 255, 255)
   	backDraw()
	drawRock()
	
	drawEntities()
	
	if showDebug then
	showDebugInfo("CHICKEN") end
	
	if gameOver then gameOverDraw() end
end

function love.mousepressed(x, y, button)
   if button == '1' then
   
   end
end

function love.mousereleased(x, y, button)
   if button == '1' then
		
   end
end

function love.keypressed(key)
	if key == 'f4' then
		love.window.setFullscreen( not love.window.getFullscreen() )
	end
	
	if key == 'g' then
		showDebug = not showDebug
	end
	
	if key == 'h' then
		showCollis = not showCollis
	end
end

function love.keyreleased(key)
end

function love.resize(w, h)
	scaleX = w / windowX
    scaleY = h / windowY
	windowX, windowY = w, h
	print(scaleX)
	print(scaleY)
end

function love.focus(f) 
gameIsPaused = not f 
 print("LOST FOCUS")
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end