-----------------------------------------------------------------------------------------
-- 
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Fly By
-- Fox Dark
-- 2013-09-27

-- | iphone status bar | --
display.setStatusBar( display.HiddenStatusBar )

-- | VARIABLE DECLARATIONS | --
local _StaticBackground = display.newImageRect('images/Background_02_sky.png', 960, 640)
_StaticBackground.x = display.contentWidth/2
_StaticBackground.y = display.contentHeight/2

local _ForeGroundImage = display.newImageRect( 'images/Ground_01.png', 1920, 69 )
_ForeGroundImage.x = display.contentWidth
_ForeGroundImage.y = display.contentHeight - 35

local _Gamestate = require "gamestate"

local _Physics = require "gamephysics"				-- This is the object that handles the world's physics
local _Plane = require "plane"
local _Monsters = require "monster"

local _scenes = {}
local Scene = require('scene')  -- Scene is a library, not a variable

-- | SYSTEM SETTINGS | --
system.setIdleTimer(false)	-- Don't let the screen fall asleep

-- | PHYSICS PRIMER | --
_Physics.start()	-- Engage Physics
_Plane.init()		-- Engage Plane
_Monsters.init()	-- Engage Monsters

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
    local offset = math.floor( (display.contentWidth/2) + _scenes[1].ground.x )
    
    if(offset <= _Physics.sceneSpeed) then
        -- remove scene
        local scene = table.remove(_scenes, 1)
        scene:removeSelf()
        
        -- add new scene off screen to right
        table.insert(_scenes, Scene:createScene(display.contentWidth + offset ))
        
        -- move foreground
        _ForeGroundImage.x = display.contentWidth - offset
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
    
    -- move foreground
    _ForeGroundImage:translate(-_Physics.sceneSpeed, 0)
    
	_Monsters.scroll()
end

timer.performWithDelay(1, drawScene, -1)