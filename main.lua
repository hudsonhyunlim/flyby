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

local _scenes = {}
local Scene = require('scene')

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

local function destroySceneHandler()
    --ground:removeSelf()
end

local function testFunc()
    print('test')
end

-- create initial scenes
table.insert(_scenes, Scene:createScene(0))
table.insert(_scenes, Scene:createScene(display.contentWidth))

local function drawScene()
    if(_scenes[1].ground.x <= -(display.contentWidth/2)) then
        -- remove scene
        local scene = table.remove(_scenes, 1)
        scene:removeSelf()
        
        -- add new scene off screen to right
        table.insert(_scenes, Scene:createScene(display.contentWidth))
    end
    for k,scene in pairs(_scenes) do
        if scene then
            -- move ground
            scene.ground:translate(-_Physics.sceneSpeed, 0)
            
            -- move ground objects
            for k, object in pairs(scene.obstacles) do
                object:translate(-_Physics.sceneSpeed, 0)
            end
            
        end
    end
end

timer.performWithDelay(1, drawScene, -1)