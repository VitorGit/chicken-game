goImage = love.graphics.newImage( "sprites/GameOver.png" )
local goFont = love.graphics.newFont(50)

goScaleX = love.graphics.getWidth() / goImage:getWidth()
goScaleY = love.graphics.getHeight() / goImage:getHeight()
   
gameOverUpdate = function()
	if love.keyboard.isDown("return") then
	gameOver = false
	love.load()
	end
end

gameOverDraw = function()
   love.graphics.setColor(255, 255, 255, 255)
   love.graphics.draw(goImage, 0, 0, 0, goScaleX, goScaleY)
   
   love.graphics.setFont(goFont)
   love.graphics.setColor(255, 20, 20)
   love.graphics.print( "Game over!", love.graphics.getWidth()/2, love.graphics.getHeight()/2)
   
end