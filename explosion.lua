Explosion = {}

local _ExplosionSequenceData = {
 
  { name = "explosionAnimation",  --name of animation sequence
    start = 1,  --starting frame index
    count = 7,  --total number of frames to animate consecutively before stopping or looping
    time = 250,  --optional, in milliseconds; if not supplied, the sprite is frame-based
    loopCount = 1,  --optional. 0 (default) repeats forever; a positive integer specifies the number of loops
    loopDirection = "forward"  --optional, either "forward" (default) or "bounce" which will play forward then backwards through the sequence of frames
  }  --if defining more sequences, place a comma here and proceed to the next sequence sub-table
 
}
local _ExplosionSheetData = { width=220, height=220, numFrames=7, sheetContentWidth=1540, sheetContentHeight=220 }
local _ExplosionSheet = graphics.newImageSheet( "images/explosion_plane_sprite.png", _ExplosionSheetData )


local function removeExplosion(event)
    if(event.phase == "ended") then
        event.target:removeSelf()
    end
end

function Explosion:createExplosion(x, y)
	local _Explosion = display.newSprite( _ExplosionSheet, _ExplosionSequenceData )
    _Explosion.x = x
    _Explosion.y = y
    _Explosion:addEventListener( "sprite", removeExplosion )
    _Explosion:play()
    
end

return Explosion