-----------------------------------------------------------------------------------------
-- 
-- plane.lua
--
-----------------------------------------------------------------------------------------
-- Fly By
-- Fox Dark
-- 2013-09-27

local plane = {}
-- | VARIABLE DECLARATIONS | --
local _PlaneSequenceData = {
 
  { name = "planeAnimation",  --name of animation sequence
    start = 1,  --starting frame index
    count = 5,  --total number of frames to animate consecutively before stopping or looping
    time = 200,  --optional, in milliseconds; if not supplied, the sprite is frame-based
    loopCount = 0,  --optional. 0 (default) repeats forever; a positive integer specifies the number of loops
    loopDirection = "forward"  --optional, either "forward" (default) or "bounce" which will play forward then backwards through the sequence of frames
  }  --if defining more sequences, place a comma here and proceed to the next sequence sub-table
 
}
local _PlaneSheetData = { width=128, height=31, numFrames=5, sheetContentWidth=640, sheetContentHeight=31 }
local _PlaneSheet = graphics.newImageSheet( "images/PlayerPlane_animation.png", _PlaneSheetData )
local _Plane = display.newSprite( _PlaneSheet, _PlaneSequenceData )
_Plane:play()

local _Physics = require "gamephysics"				-- This is the object that handles the world's physics
--local _Plane = display.newImage( "images/PlayerPlane.png" )	-- The player character object
local _Ascend = false							-- Is the user currently pressing to fly?
local _Ceiling = display.newRect(0, -1, display.contentWidth, 1)	-- Prevents plane from returning to its people
local _Gamestate = require "gamestate"
local _Audio = require "gameaudio"


function plane.init()
	-- | PHYSICS PRIMER | --
    local planePhysicsData = (require "physicseditor.plane").physicsData(1.0)
    _Physics.addBody(_Plane, planePhysicsData:get("PlayerPlane_isolated") )

--	_Physics.addBody(_Plane, {density = 1.0, friction = 0.8, bounce = 0.01}) -- Add the plane to physics engine
	_Physics.addBody(_Ceiling, "static", {density = 1.0, friction = 0.3, bounce = 0.01}) -- Ceiling to prevent plane from flying to its people

	-- | PLANE PHYSICS | --
	_Plane.isFixedRotation = true
	_Plane.x = 120
	_Plane.y = 50
	_Plane.alpha = 1.0
	_Plane.id = '_Plane'
	_Gamestate.isAlive = true
	_Plane:setLinearVelocity(0,0)
	timer.performWithDelay(5, _Plane)
end

function _Plane:timer(event)
    if(not _Gamestate:hasFuel()) then
        _Ascend = false
    end
    if(_Gamestate.isAlive) then
    	local vx, vy = _Plane:getLinearVelocity()
    	if vx ~= 0 then
    	    _Plane.x = 120
    	end
    	if _Ascend == true then
    		if vy > -500 then
    			_Plane:applyForce(0, -1000, 0, 0)
    		end
            _Audio:stopLoop("descent")
            _Audio:playLoop("ascent", {loops=-1})
        else
            if vy < 0 then
                _Plane:applyForce(0, _Gamestate.TOP_TURN_FORCE, 0, 0)
            end
            _Audio:stopLoop("ascent")
            _Audio:playLoop("descent", {loops=-1})
    	end
    	_Physics.sceneSpeed = math.floor( ((display.contentHeight - _Plane.y)/display.contentHeight) * _Gamestate.SPEED_RANGE_FACTOR ) + _Gamestate.SPEED_BASE_FACTOR
    	timer.performWithDelay(5, _Plane)
	end
end

local function onTouch( event )
    if(_Gamestate:hasFuel()) then
    	if event.phase == "began" then
    		_Ascend = true
    	elseif event.phase == "ended" then
    		_Ascend = false
    	end
	end
end

Runtime:addEventListener("touch", onTouch)

local function onCollision(self, event)
    if(event.phase == "began") then
        if(event.other.id and (event.other.id == "crate_plain" or event.other.id == "crate_fuel") and not event.other.isHandled) then
            event.other.isHandled = true
            local crate = event.other
            if(event.other.id == "crate_plain") then
                --_Gamestate:addScore()
            else
                _Gamestate:addFuel()
            end
            
            -- remove and clean off crate from game
            local crate = event.other
            timer.performWithDelay(1, function()
                -- remove the crate
                crate.scene:removeCrate(crate)
            end, 1)
        end
        
        if(event.other.id and event.other.collisionType == "killer" and _Gamestate.isAlive) then
            
            -- stop audio
            _Audio:stopLoop('ascent')
            _Audio:stopLoop('descent')
            _Audio:playOnce('crash')
            
            _Plane.alpha = 0.0  -- hide plane
            _Gamestate.isAlive = false
            local Explosion = require "explosion"
            Explosion:createExplosion(_Plane.x, _Plane.y)
            -- TODO: remove plane physics body as well?
			if ((event.other.id == "zepp") or (event.other.id == "zepp_fall"))then
				event.other.alpha = 0.0
				local ExplosionOther = require "explosion"
				ExplosionOther:createExplosion(event.other.x, event.other.y)
			end
            _Physics.sceneSpeed = 0
            _Gamestate:gameOver()
        end
    end
end

_Plane.collision = onCollision
_Plane:addEventListener("collision", _Plane)

return plane