local Scene = {}
local _Physics = require('gamephysics')

-- constants
local GROUND_HEIGHT = 50

function Scene:createScene(initX)
    local scene = display.newGroup()
    scene.obstacles = {}
    
    -- add ground
    local ground = display.newRect(initX, display.contentHeight - GROUND_HEIGHT, display.contentWidth, GROUND_HEIGHT)
    ground:setFillColor(math.random(100,255), math.random(100,255), math.random(100,255))   -- TODO: random color for now, kill me at some point
    scene:insert(ground)
    _Physics.addBody(ground, "static", {density = 1.0, friction = 0.3, bounce = 0.01})
    scene.ground = ground
    
    -- add random placeholder box
    local x = display.newRect(initX + 200, display.contentHeight - GROUND_HEIGHT - 100, 300, 100)
    x:setFillColor(0, 255, 0)
    _Physics.addBody(x, "static", {density = 1.0, friction = 0.3, bounce = 0.01})
    scene:insert(x)
    table.insert(scene.obstacles, x)
    
    -- add random crate
    local crate = display.newImage( "images/crate_plain.png" )
    crate.x = initX + 300
    crate.y = display.contentHeight - GROUND_HEIGHT - 120
    scene:insert(crate)
    table.insert(scene.obstacles, crate)
    
    return scene
end

return Scene