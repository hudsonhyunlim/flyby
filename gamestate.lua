local gamestate = {}
local Scene = require "scene"
local MAX_FUEL = 1000
local FUEL_RATE = 1
local monsters = require "monster"

gamestate.points = 0
gamestate.fuel = 500
gamestate.isAlive = true

function gamestate:addScore()
    gamestate.points = gamestate.points + 1
    gamestate:setScore(gamestate.points)
end

function gamestate:setScore(score)
    gamestate.pointsDisplay.text = "" .. score
end

function gamestate:addFuel()
    local addedFuel = 100
    if(gamestate.fuel > 900) then
        addedFuel = MAX_FUEL - gamestate.fuel
    end
    gamestate.fuel = gamestate.fuel + addedFuel
    gamestate.fuelMeterGroup.needle:rotate(-(addedFuel/10))
end

function gamestate:consumeFuel()
    if(gamestate.isAlive and gamestate:hasFuel()) then
        gamestate.fuel = gamestate.fuel - FUEL_RATE
        gamestate.fuelMeterGroup.needle:rotate(FUEL_RATE/10)
    end
end

function gamestate:hasFuel()
    return gamestate.fuel > 0
end

function gamestate:initNeedle()
    gamestate.fuelMeterGroup.needle:rotate(-(MAX_FUEL - gamestate.fuel)/10)
end

-- create initial scenes
function gamestate:initScene()
    gamestate.points = 0
    gamestate:setScore(0)
    
    gamestate.fuelMeterGroup.x = 0
    gamestate.fuelMeterGroup.y = display.contentHeight - (gamestate.fuelMeterGroup.fuelMeter.height)
    gamestate.fuelMeterGroup.needle.y = 80
    gamestate.fuelMeterGroup.needle.xReference = -20
    gamestate:initNeedle()
    
    gamestate.fuel = MAX_FUEL
    
    gamestate._StaticBackground.x = display.contentWidth/2
    gamestate._StaticBackground.y = display.contentHeight/2
    
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