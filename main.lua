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
_Gamestate._StaticBackground = display.newImageRect('images/Background_02_sky.png', display.contentWidth, display.contentHeight)

-- create some random cloud --
_Gamestate.cloudGroup = display.newGroup()
local function createRandomCloud(initX)
    local cloudId = math.random(1,2)
    local cloud
    if(cloudId == 1) then
        cloud = display.newImageRect(_Gamestate.cloudGroup, 'images/cloud_01.png', 103, 61)
    else
        cloud = display.newImageRect(_Gamestate.cloudGroup, 'images/cloud_02.png', 155, 48)
    end
    cloud.x = math.random(0 + initX, 0 + initX + display.contentWidth)
    cloud.y = math.random(0, display.contentHeight) 
    return cloud
end

for i=1,10,1 do
    createRandomCloud(0)
end

_Gamestate._BackGroundImage = display.newImageRect( 'images/Background_01.png', display.contentWidth * 2, 96 )
_Gamestate._ForeGroundImage = display.newImageRect( 'images/Ground_01.png', display.contentWidth * 2, 69 )

local function createPointText()
    
end

_Gamestate.pointsTallyGroup = display.newGroup()
_Gamestate.pointsBoard = display.newImage("images/scoreboard.png")
_Gamestate.pointsTallyGroup:insert(_Gamestate.pointsBoard)
_Gamestate.pointsDisplay = {}
for i=1,5,1 do
    local text = display.newText( "0", 0, 0, "Helvetica", 36 )
    text:setTextColor(255, 255, 255)
    local factor = 31
    text.x = 148 + factor - (i * factor)
    text.y = 28
    table.insert(_Gamestate.pointsDisplay, text)
    _Gamestate.pointsTallyGroup:insert(text)
end
_Gamestate.pointsTallyGroup.x = 200
_Gamestate.pointsTallyGroup.y = display.contentHeight - (_Gamestate.pointsBoard.height)

local fuelMeter = display.newImage("images/meter_fuel.png")
local fuelMeterNeedle = display.newImage("images/meter_fuel_needle.png")
_Gamestate.fuelMeterGroup = display.newGroup()
_Gamestate.fuelMeterGroup:insert(fuelMeter)
_Gamestate.fuelMeterGroup:insert(fuelMeterNeedle)
_Gamestate.fuelMeterGroup.fuelMeter = fuelMeter
_Gamestate.fuelMeterGroup.needle = fuelMeterNeedle

_Gamestate.lowFuelIndicator = display.newImage("images/lowfuel_text.png")
_Gamestate.lowFuelIndicator.x = display.contentWidth/2
_Gamestate.lowFuelIndicator.y = 50
_Gamestate:lowFuelOff()

local _Audio = require "gameaudio"
local _Physics = require "gamephysics"				-- This is the object that handles the world's physics
local _Plane = require "plane"
local _Monsters = require "monster"

_Audio:init()

_Gamestate.scenes = {}
_Gamestate.plane = _Plane
local Scene = require('scene')  -- Scene is a library, not a variable

-- | SYSTEM SETTINGS | --
system.setIdleTimer(false)	-- Don't let the screen fall asleep


-- ----------------------------

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
    
    if(_Gamestate._BackGroundImage.x < -display.contentWidth) then
        _Gamestate._BackGroundImage.x = display.contentWidth * 2
    end
    
    -- move foreground
    _Gamestate._ForeGroundImage:translate(-_Physics.sceneSpeed, 0)
    _Gamestate._BackGroundImage:translate(-_Physics.sceneSpeed/10, 0)
--    _Gamestate.cloudGroup:translate(-_Physics.sceneSpeed/20, 0)
    for i=1,_Gamestate.cloudGroup.numChildren,1 do
        local c = _Gamestate.cloudGroup[i]
        if(c) then
            if(c.x < -100) then
                _Gamestate.cloudGroup:remove(c)
                createRandomCloud(display.contentWidth)
            else
                c:translate(-_Physics.sceneSpeed/20, 0)
            end
        end
    end
	_Monsters.scroll()
	
	_Gamestate.lowFuelIndicator:toFront()
	_Gamestate.fuelMeterGroup:toFront()
	_Gamestate.pointsTallyGroup:toFront()
	
	_Gamestate:addScore(_Physics.sceneSpeed)
	
	_Gamestate:consumeFuel()
end

local function startGame()
    _Audio:playLoop('gameplay', {loops=-1})
    -- | PHYSICS PRIMER | --
    _Physics.start()	-- Engage Physics
    _Plane.init()		-- Engage Plane
    _Monsters.init()	-- Engage Monsters
    _Gamestate:initScene()
    timer.performWithDelay(1, drawScene, -1)
end

-- start screen
_Audio:playLoop('opening', {loops=-1})
local _TitleCard = display.newImageRect('images/startscreen.png', display.contentWidth, display.contentHeight)
_TitleCard.x = display.contentWidth/2
_TitleCard.y = display.contentHeight/2
_TitleCard:addEventListener('touch', function(event)
    if(not event.target.isTouched) then
        event.target.isTouched = true
        _Audio:stopLoop('opening')
        timer.performWithDelay(1, function()
            _TitleCard:removeSelf()
            startGame()
        end, 1)
    end
end)