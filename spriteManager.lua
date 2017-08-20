print("AnimatedSprite.lua loaded")

local ManagerVersion = 1.0

sprFile_bank = {} --Map with all the sprite definitions
image_bank = {} --Contains all images that were already loaded

function LoadSprite (file_name)

    if file_name == nil then return nil end
    

    --Load the sprite definition file to ensure it exists
    local spr_file = love.filesystem.load(file_name)
	
    --If the file doesn't exist or has syntax errors, it'll be nil.
    if spr_file == nil then
        --Spit out a warning and return nil.
        print("Attempt to load an invalid file (inexistent or syntax errors?): "
                ..file_name)
        return nil
    end

    --[[Loading the sprite definition as an entry in our table.

        We can execute the file by calling it as a function
            with these () as we loaded with loadfile previously.
        If we used dofile with an invalid file path our program
            would crash. 
        At this point, executing the file will load all the necessary
            information in a single call. There's no need to parse
            this of serialization.
    ]]
    local old_sprite = sprFile_bank [file_name]
    sprFile_bank [file_name] = spr_file()
    
    --Check the version to verify if it is compatible with this one.
    if sprFile_bank[file_name].serialization_version ~= ManagerVersion then
        print("Attempt to load file with incompatible versions: "..file_name)
        print("Expected version "..ManagerVersion..", got version "
                ..sprFile_bank[file_name].serialization_version.." .")
        sprFile_bank[file_name] = old_sprite -- Undo the changes due to error
        -- Return old value (nil if not previously loaded)
        return sprFile_bank[file_name]
    end
    
    
    --All we need to do now is check if the image exist
    --  and load it.
    
    --Storing the path to the image in a variable (to add readability)
    local sprite_sheet = sprFile_bank[file_name].sprite_sheet

    --Load the image.
    local old_image = image_bank [sprite_sheet]
    image_bank [sprite_sheet] = love.graphics.newImage(sprite_sheet)
        
    --Check if the loaded image is valid.
    if image_bank[sprite_sheet] == nil then
        -- Invalid image, reverting all changes
        image_bank [sprite_sheet] = old_image   -- Revert image
        sprFile_bank[file_name] = old_sprite    -- Revert sprite
        
        print("Failed loading sprite "..file_name..", invalid image path ( "
                ..sprite_sheet.." ).")
    end
	
    return sprFile_bank[file_name]
end

function GetInstance (file_name)

    if file_name == nil then return nil end -- invalid use
    
    if sprFile_bank[file_name] == nil then
        --Sprite not loaded attempting to load; abort on failure.
        if LoadSprite (file_name) == nil then return nil end
    end
    
    --All set, return the table with the data for the update and draw

    return {
        sprite  = sprFile_bank[file_name],  --Sprite reference
        --Sets the animation as the first one in the list.
        curr_anim = sprFile_bank[file_name].animations_names[1],
		old_anim = curr_anim,
        curr_frame = 1,
        elapsed_time = 0,
        size_scale = 1,
        time_scale = 1,
        rotation = 0,
        off_w = 1,
        off_h = 1,
		w = sprFile_bank[file_name].Width(),
		h = sprFile_bank[file_name].Height()
    }
end

function UpdateInstance(isnt, dt)
    --Increment the internal counter.
    isnt.elapsed_time = isnt.elapsed_time + dt

    --We check we need to change the current frame.
    if isnt.elapsed_time > isnt.sprite.frame_duration * isnt.time_scale then
        --Check if we are at the last frame.
        --  # returns the total entries of an array.
        if isnt.curr_frame < #isnt.sprite.animations[isnt.curr_anim] then
            -- Not on last frame, increment.
            isnt.curr_frame = isnt.curr_frame + 1
        else
            -- Last frame, loop back to 1.
            isnt.curr_frame = 1
        end
        -- Reset internal counter on frame change.
        isnt.elapsed_time = 0
    end
end

function DrawInstance (isnt, x, y)
	--check if the animation was changed
	if curr_anim ~= old_anim then
		if isnt.sprite.animations[animation] == nil then print(animation.."Animation not found") return end
		isnt.sprite.curr_frame = 1
	else
    love.graphics.draw (
        image_bank[isnt.sprite.sprite_sheet], --The image
        --Current frame of the current animation
        isnt.sprite.animations[isnt.curr_anim][isnt.curr_frame],
        x,
        y,
        isnt.rotation,
        isnt.size_scale,
        isnt.size_scale,
        isnt.off_w,
        isnt.off_h
    )
	end
end