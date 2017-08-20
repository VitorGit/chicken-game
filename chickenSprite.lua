
print("chickenSprite.lua loaded")

require "love.graphics"

local image_w = 1360 --This info can be accessed with a Löve2D call
local image_h = 500 --      after the image has been loaded. I'm creating these for readability.
local sprite_w = 1360/4
local sprite_h = 500

return {
	Width = function() return sprite_w end,
	Height = function() return sprite_h end,
	
    serialization_version = 1.0, -- The version of this serialization process

    sprite_sheet = "sprites/Tken.png", -- The path to the spritesheet
	sprite_name = "chicken", -- The name of the sprite

    frame_duration = 0.09,
    
    
    --This will work as an array.
    --So, these names can be accessed with numeric indexes starting at 1.
    --If you use < #sprite.animations_names > it will return the total number
    --      of animations in in here.
    animations_names = {
        "idle",
        "idle_back"
    },

    --The list with all the frames mapped to their respective animations
    --  each one can be accessed like this:
    --  mySprite.animations["idle"][1]
    animations = {
        idle = {
        --  love.graphics.newQuad( X, Y, Width, Height, Image_W, Image_H)
            love.graphics.newQuad( 0, 0, sprite_w, sprite_h, image_w, image_h ),
            love.graphics.newQuad( sprite_w * 1, 0, sprite_w, sprite_h, image_w, image_h ),
            love.graphics.newQuad( sprite_w * 2, 0, sprite_w, sprite_h, image_w, image_h ),
            love.graphics.newQuad( sprite_w * 3, 0, sprite_w, sprite_h, image_w, image_h )
        }
        
        
        
    } --animations

} --return (end of file)
