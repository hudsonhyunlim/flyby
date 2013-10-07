local gamestate = {}
local Scene = require "scene"
local MAX_FUEL = 1000
local FUEL_RATE = 1.4
local SCORE_RATE = 0.01
local FUEL_FLASH_TIME = 600
local LOW_FUEL_LIMIT = 350
local monsters = require "monster"
local _Audio = require "gameaudio"

gamestate.SPEED_RANGE_FACTOR = 20
gamestate.SPEED_BASE_FACTOR = 5
gamestate.TOP_TURN_FORCE = 750

gamestate.points = 0
gamestate.fuel = 500
gamestate.isAlive = true

function gamestate:addScore(sceneSpeed)
    gamestate.points = gamestate.points + (SCORE_RATE * sceneSpeed)
    gamestate:setScore(math.floor(gamestate.points))
end

function gamestate:setScore(score)
    for k,text in pairs(gamestate.pointsDisplay) do
        text.text = "" .. score % 10
        score = math.floor(score / 10)
    end
end

function gamestate:addFuel()
    _Audio:playOnce('fuel')
    local addedFuel = 400
    if(gamestate.fuel > 600) then
        addedFuel = MAX_FUEL - gamestate.fuel
    end
    gamestate.fuel = gamestate.fuel + addedFuel
end

function gamestate:consumeFuel()
    if(gamestate.isAlive and gamestate:hasFuel()) then
        gamestate.fuel = gamestate.fuel - FUEL_RATE
        local newWidth = gamestate.fuelMeterGroup.fuelBar.originalWidth * (gamestate.fuel / MAX_FUEL)
        gamestate.fuelMeterGroup.fuelBar.width = newWidth
        gamestate.fuelMeterGroup.fuelBar.x = newWidth / 2 + gamestate.fuelMeterGroup.fuelBar.originalX
        if(gamestate.fuel < LOW_FUEL_LIMIT and not gamestate.isLowFuel) then
            gamestate:lowFuelOn()
        elseif(gamestate.fuel >= LOW_FUEL_LIMIT and gamestate.isLowFuel) then
            gamestate:lowFuelOff()
        end
    end
end

function gamestate:hasFuel()
    return gamestate.fuel > 0
end

function gamestate:fuelAlphaOff()
    transition.to(gamestate.lowFuelIndicator, {time=FUEL_FLASH_TIME, alpha=0.0, onComplete=gamestate.fuelAlphaOn})
end

function gamestate:fuelAlphaOn()
    if(gamestate.isLowFuel) then
        transition.to(gamestate.lowFuelIndicator, {time=FUEL_FLASH_TIME, alpha=0.8, onComplete=gamestate.fuelAlphaOff})
    end
end

function gamestate:lowFuelOn()
    gamestate.lowFuelIndicator.alpha = 0.0
    gamestate.isLowFuel = true
    gamestate:fuelAlphaOn()
end

function gamestate:lowFuelOff()
    gamestate.isLowFuel = false
    gamestate.lowFuelIndicator.alpha = 0.0
end
-- create initial scenes
function gamestate:initScene()
    gamestate:lowFuelOff()
    _Audio:setVolume('gameplay', 0.5)
    gamestate.points = 0
    gamestate:setScore(0)
    
    gamestate.fuelMeterGroup.x = display.contentWidth / 2 - gamestate.fuelMeterGroup.fuelBarBack.width / 2
    gamestate.fuelMeterGroup.y = display.contentHeight - gamestate.fuelMeterGroup.fuelBarBack.height - 3
    
    gamestate.fuel = MAX_FUEL
    
    gamestate._StaticBackground.x = display.contentWidth/2
    gamestate._StaticBackground.y = display.contentHeight/2
    
    gamestate._BackGroundImage.x = display.contentWidth
    gamestate._BackGroundImage.y = display.contentHeight - 95
    
    gamestate._ForeGroundImage.x = display.contentWidth
    gamestate._ForeGroundImage.y = display.contentHeight - 35

    for k in pairs (gamestate.scenes) do
        gamestate.scenes[k]:removeSelf()
        gamestate.scenes[k] = nil
    end
    gamestate.scenes = {}
    table.insert(gamestate.scenes, Scene:createScene(0))
    table.insert(gamestate.scenes, Scene:createScene(display.contentWidth))
end

function gamestate:gameOver()
    gamestate:lowFuelOff()
    _Audio:setVolume('gameplay', 0.2)
    timer.performWithDelay(2000, function()
        --plane.init()
        local gameover = display.newImage("images/game_over.png")
        gameover.x = display.contentWidth / 2
        gameover.y = display.contentHeight / 2
        gameover:addEventListener('touch', function(event)
            if(not gameover.restarting) then
                gameover.restarting = true
                gamestate.plane:init()
                local monsters = require "monster"
                monsters.init()
                gamestate:initScene()
                timer.performWithDelay(1, function()
                    gameover:removeSelf()
                end, 1)
            end
        end)
    end, 1)
end

gamestate.scenes = {}

return gamestate