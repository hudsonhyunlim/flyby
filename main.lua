-----------------------------------------------------------------------------------------
-- 
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Fly By
-- Fox Dark
-- 2013-09-27

-- | VARIABLE DECLARATIONS | --
local _Physics = require "physics"				-- This is the object that handles the world's physics
local _Plane = display.newImage( "ika.png" )	-- The player character object
local _Ascend = false							-- Is the user currently pressing to fly?
local _Ceiling = display.newRect(0, -1, display.contentWidth, 1)	-- Prevents plane from returning to its people

-- | PHYSICS PRIMER | --
_Physics.start()	-- Engage Physics
_Physics.addBody(_Plane, {density = 1.0, friction = 0.8, bounce = 0.01}) -- Add the plane to physics engine
_Physics.addBody(_Ceiling, "static", {density = 1.0, friction = 0.3, bounce = 0.01})

-- | PLANE PHYSICS | --
_Plane.isFixedRotation = true
_Plane.x = display.contentWidth / 2
_Plane.y = 50
_Plane.myName = '_Plane'


local function onCollision( event )
        if ( event.phase == "began" ) then
 
                -- print( "began: " .. event.object1.myName .. " & " .. event.object2.myName )
				--event.object2:setLinearVelocity( 0, -100)
        elseif ( event.phase == "ended" ) then
 
                -- print( "ended: " .. event.object1.myName .. " & " .. event.object2.myName )
 
        end
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

Runtime:addEventListener( "collision", onCollision )

-- Runtime:addEventListener( "tap", handleScreenTap )

Runtime:addEventListener("touch", onTouch)

timer.performWithDelay(5, _Plane)

-- ----------------------------
local SCENE_BUFFER_SIZE = 3
local sceneSpeed = -20
local scenes = {}

local function createScene(initX)
    local scene = display.newGroup()
    local ground = display.newRect(initX, 640-50, 960, 50)
    ground:setFillColor(math.random(100,255), math.random(100,255), math.random(100,255))
    scene:insert(ground)
    scene.ground = ground
    return scene
end

local function destroySceneHandler()
    --ground:removeSelf()
end

local function testFunc()
    print('test')
end

-- create initial scenes
table.insert(scenes, createScene(0))
table.insert(scenes, createScene(960))

local function drawScene()
    if(scenes[1].ground.x <= -480) then
        local scene = table.remove(scenes, 1)
        scene:removeSelf()
        table.insert(scenes, createScene(960))
    end
    for k,scene in pairs(scenes) do
        if scene then
            scene.ground:translate(sceneSpeed, 0)
        end
    end
end

timer.performWithDelay(1, drawScene, -1)