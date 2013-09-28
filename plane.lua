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
local _Physics = require "gamephysics"				-- This is the object that handles the world's physics
local _Plane = display.newImage( "ika.png" )	-- The player character object
local _Ascend = false							-- Is the user currently pressing to fly?
local _Ceiling = display.newRect(0, -1, display.contentWidth, 1)	-- Prevents plane from returning to its people


function plane.init()
	-- | PHYSICS PRIMER | --
	_Physics.addBody(_Plane, {density = 1.0, friction = 0.8, bounce = 0.01}) -- Add the plane to physics engine
	_Physics.addBody(_Ceiling, "static", {density = 1.0, friction = 0.3, bounce = 0.01}) -- Ceiling to prevent plane from flying to its people

	-- | PLANE PHYSICS | --
	_Plane.isFixedRotation = true
	_Plane.x = display.contentWidth / 2
	_Plane.y = 50
	_Plane.myName = '_Plane'
end

function _Plane:timer(event)
	local vx, vy = _Plane:getLinearVelocity()
	if _Ascend == true then
		if vy > -500 then
			_Plane:applyForce(0, -100, 0, 0)
		end
	end
	timer.performWithDelay(5, _Plane)
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

return plane