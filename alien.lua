print("alien.lua loaded")

require "love.graphics"
require "love.keyboard"
require "entityManager"
require "worldUtilities"
require "spriteManager"
vector = require "hump.vector"

local pos, r, g, b, up, down,image, isMoving, bar

local speed = 5

local upLock, downLock = false, false

local sprite = GetInstance("AlienSprite.lua")
sprite.size_scale = 0.2
local w = sprite.w * sprite.size_scale
local h = sprite.h * sprite.size_scale
sprite.off_w = 200
sprite.off_h = 200
print(sprite.off_w)
print(sprite.off_h)

return {
	--constructor to set if this alien is the right one or the left one
	--change the position and image accordinly
	init = function(side)
				if side ~= "left" and side ~= "right" then --checks for errors
				print("wrong argument for setPlace(); expected 'left' or 'right'") return nil end

				if side == "left" then 
					pos = vector.new(WMargin * 1, HMargin * 9)
					r, g, b = 255, 0, 255
					up, down = "w", "s"
				end
				if side == "right" then 
					pos = vector.new(WMargin * 9, HMargin * 9)
					r, g, b = 255, 255, 0
					up, down = "up", "down"
				end
			end,
	
	setBar = function(b) bar = b end,
	
	draw = function()
				love.graphics.setColor(255, 255, 255, 255)
				DrawInstance (sprite, pos.x, pos.y)
				
				--show collision box on the screen
				love.graphics.setColor(255, 255, 255)
				if showCollis then 
				love.graphics.circle("fill", pos.x, pos.y, 5)
				love.graphics.circle("fill", pos.x, pos.y - h, 5)
				love.graphics.rectangle("line", pos.x, pos.y, w, h) end
			end,
			
	update = function(dt)
				
				isMoving = false
				--check for direction keys
				if love.keyboard.isDown(up) and upLock == false then 
					pos.y = pos.y - speed
					isMoving = true
				end
	
				if love.keyboard.isDown(down) and downLock == false then
					pos.y = pos.y + speed 
					isMoving = true
				end
				
				UpdateInstance(sprite, dt)
			end,
	
	getPos = function() return pos end, --allow those fields to be acessed from outside the table
	getPivot = function() return vector.new(pos.x, pos.y - h/2) end,
	getWidth = function() return w end,	
	getHeight = function() return h end,
	isMoving = function() return isMoving end,
	upLock = function() upLock = true end,
	downLock = function() downLock = true end,
	getLock = function() return upLock end,
	getLock1 = function() return downLock end, --DELETE ME
	unlock = function() upLock, downLock = false, false end
	
} --return (end of file)