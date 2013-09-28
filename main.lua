-----------------------------------------------------------------------------------------
-- 
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Fly By
-- Fox Dark
-- 2013-09-27

-- | VARIABLE DECLARATIONS | --
local _Physics = require "gamephysics"				-- This is the object that handles the world's physics
local _Plane = require "plane"

-- | PHYSICS PRIMER | --
_Physics.start()	-- Engage Physics
_Plane.init()		-- Engage Plane

local function onCollision( event )
        if ( event.phase == "began" ) then
 
                -- print( "began: " .. event.object1.myName .. " & " .. event.object2.myName )
				--event.object2:setLinearVelocity( 0, -100)
        elseif ( event.phase == "ended" ) then
 
                -- print( "ended: " .. event.object1.myName .. " & " .. event.object2.myName )
 
        end
end




Runtime:addEventListener( "collision", onCollision )

-- Runtime:addEventListener( "tap", handleScreenTap )



-- ----------------------------
local SCENE_BUFFER_SIZE = 3
local sceneSpeed = -20
local scenes = {}
local Scene = require('scene')

local function destroySceneHandler()
    --ground:removeSelf()
end

local function testFunc()
    print('test')
end

-- create initial scenes
table.insert(scenes, Scene:createScene(0))
table.insert(scenes, Scene:createScene(display.contentWidth))

local function drawScene()
    if(scenes[1].ground.x <= -(display.contentWidth/2)) then
        local scene = table.remove(scenes, 1)
        scene:removeSelf()
        table.insert(scenes, Scene:createScene(display.contentWidth))
    end
    for k,scene in pairs(scenes) do
        if scene then
            scene.ground:translate(sceneSpeed, 0)
        end
    end
end

timer.performWithDelay(1, drawScene, -1)