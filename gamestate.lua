local gamestate = {}
local Scene = require "scene"

gamestate.points = 0

function gamestate:addScore()
    gamestate.points = gamestate.points + 1
    gamestate.pointsDisplay.text = "" .. gamestate.points
end

-- create initial scenes
function gamestate:initScene()
    gamestate.points = 0
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

gamestate.scenes = {}

return gamestate