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
local _Gamestate = require "gamestate"
_Gamestate._StaticBackground = display.newImageRect('images/Background_02_sky.png', 960, 640)

_Gamestate._ForeGroundImage = display.newImageRect( 'images/Ground_01.png', 1920, 69 )

_Gamestate.pointsDisplay = display.newText( "0", display.contentWidth - 50, 50, "Helvetica", 32 )
_Gamestate.pointsDisplay:setTextColor(255, 0, 0)

local fuelMeter = display.newImage("images/meter_fuel.png")
local fuelMeterNeedle = display.newImage("images/meter_fuel_needle.png")
_Gamestate.fuelMeterGroup = display.newGroup()
_Gamestate.fuelMeterGroup:insert(fuelMeter)
_Gamestate.fuelMeterGroup:insert(fuelMeterNeedle)
_Gamestate.fuelMeterGroup.fuelMeter = fuelMeter
_Gamestate.fuelMeterGroup.needle = fuelMeterNeedle

local _Physics = require "gamephysics"				-- This is the object that handles the world's physics
local _Plane = require "plane"
local _Monsters = require "monster"

_Gamestate.scenes = {}
_Gamestate.plane = _Plane
local Scene = require('scene')  -- Scene is a library, not a variable

-- | SYSTEM SETTINGS | --
system.setIdleTimer(false)	-- Don't let the screen fall asleep

-- | PHYSICS PRIMER | --
_Physics.start()	-- Engage Physics
_Plane.init()		-- Engage Plane
_Monsters.init()	-- Engage Monsters


-- ----------------------------

_Gamestate:initScene()

local function drawScene()
    if(table.getn(_Gamestate.scenes) < 1) then
        return
    end
    local offset = math.floor( (display.contentWidth/2) + _Gamestate.scenes[1].ground.x )
    
    if(offset <= _Physics.sceneSpeed) then
        -- remove scene
        local scene = table.remove(_Gamestate.scenes, 1)
        scene:removeSelf()
        
        -- add new scene off screen to right
        table.insert(_Gamestate.scenes, Scene:createScene(display.contentWidth + offset ))
        
        _Gamestate._ForeGroundImage.x = display.contentWidth + offset
    end
    for k,scene in pairs(_Gamestate.scenes) do
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
    _Gamestate._ForeGroundImage:translate(-_Physics.sceneSpeed, 0)
    
	_Monsters.scroll()
	
	_Gamestate.fuelMeterGroup:toFront()
	_Gamestate:consumeFuel()
end

timer.performWithDelay(1, drawScene, -1)