-----------------------------------------------------------------------------------------
-- 
-- plane.lua
--
-----------------------------------------------------------------------------------------
-- Fly By
-- Fox Dark
-- 2013-09-27

local plane = {}
local SPEED_RANGE_FACTOR = 20
local SPEED_BASE_FACTOR = 10
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
local _PlaneSheetData = { width=256, height=61, numFrames=5, sheetContentWidth=1280, sheetContentHeight=61 }
local _PlaneSheet = graphics.newImageSheet( "images/PlayerPlane_animation.png", _PlaneSheetData )
local _Plane = display.newSprite( _PlaneSheet, _PlaneSequenceData )
_Plane:play()

local _Physics = require "gamephysics"				-- This is the object that handles the world's physics
--local _Plane = display.newImage( "images/PlayerPlane.png" )	-- The player character object
local _Ascend = false							-- Is the user currently pressing to fly?
local _Ceiling = display.newRect(0, -1, display.contentWidth, 1)	-- Prevents plane from returning to its people
local _Gamestate = require "gamestate"


function plane.init()
	-- | PHYSICS PRIMER | --
    local planePhysicsData = (require "physicseditor.plane").physicsData(1.0)
    _Physics.addBody(_Plane, planePhysicsData:get("PlayerPlane_isolated") )

--	_Physics.addBody(_Plane, {density = 1.0, friction = 0.8, bounce = 0.01}) -- Add the plane to physics engine
	_Physics.addBody(_Ceiling, "static", {density = 1.0, friction = 0.3, bounce = 0.01}) -- Ceiling to prevent plane from flying to its people

	-- | PLANE PHYSICS | --
	_Plane.isFixedRotation = true
	_Plane.x = 150
	_Plane.y = 50
	_Plane.alpha = 1.0
	_Plane.id = '_Plane'
	_Plane.isAlive = true
	_Plane:setLinearVelocity(0,0)
end

function _Plane:timer(event)
    if(_Plane.isAlive) then
    	local vx, vy = _Plane:getLinearVelocity()
    	if _Ascend == true then
    		if vy > -500 then
    			_Plane:applyForce(0, -1000, 0, 0)
    		end
    	end
    	_Physics.sceneSpeed = math.floor( ((display.contentHeight - _Plane.y)/display.contentHeight) * SPEED_RANGE_FACTOR ) + SPEED_BASE_FACTOR
    	timer.performWithDelay(5, _Plane)
	end
end

local function onTouch( event )
	if event.phase == "began" then
		_Ascend = true
	elseif event.phase == "ended" then
		_Ascend = false
	end
end

Runtime:addEventListener("touch", onTouch)

timer.performWithDelay(5, _Plane)

local function onCollision(self, event)
    if(event.phase == "began") then
        if(event.other.id and event.other.id == "crate" and not event.other.isHandled) then
            event.other.isHandled = true
            local crate = event.other
            _Gamestate:addScore()
            
            -- remove and clean off crate from game
            local crate = event.other
            timer.performWithDelay(1, function()
                -- remove the crate
                crate.scene:removeCrate(crate)
            end, 1)
        end
        
        if(event.other.id and event.other.collisionType == "killer" and _Plane.isAlive) then
            -- dead
            print('should be dead')
            _Plane.alpha = 0.0  -- hide plane
            _Plane.isAlive = false
            local Explosion = require "explosion"
            Explosion:createExplosion(_Plane.x, _Plane.y)
            -- TODO: remove plane physics body as well?
			if ((event.other.id == "zepp") or (event.other.id == "zepp_fall"))then
				event.other.alpha = 0.0
				local ExplosionOther = require "explosion"
				ExplosionOther:createExplosion(event.other.x, event.other.y)
			end
            _Physics.sceneSpeed = 0
            timer.performWithDelay(2000, function()
                --plane.init()
                local gameover = display.newImage("images/game_over.png")
                gameover.x = display.contentWidth / 2
                gameover.y = display.contentHeight / 2
                gameover:addEventListener('touch', function(event)
                    if(not gameover.restarting) then
                        gameover.restarting = true
                        plane.init()
                        local monsters = require "monster"
                        monsters.init()
                        _Gamestate:initScene()
                        timer.performWithDelay(5, _Plane)
                        timer.performWithDelay(1, function()
                            gameover:removeSelf()
                        end, 1)
                    end
                end)
            end, 1)
        end
    end
end

_Plane.collision = onCollision
_Plane:addEventListener("collision", _Plane)

return plane