local Scene = {}
local _Physics = require("gamephysics")

-- constants
local GROUND_HEIGHT = 40

-- spawn likelihood
local spawnchance = {
    mountain = 80,
    crate = 50
}


function Scene:createScene(initX)
    local scene = display.newGroup()
    scene.obstacles = {}
    
    -- decide spawn
    local spawnMountain = spawnchance.mountain > math.random(0,100)
    local spawnCrate = spawnchance.crate > math.random(0,100)
    
    -- add ground
    local ground = display.newRect(initX, display.contentHeight - GROUND_HEIGHT, display.contentWidth, GROUND_HEIGHT)
    ground:setFillColor(255, 0, 0)   -- TODO: random color for now, kill me at some point
    ground.alpha = 0.0
    scene:insert(ground)
    _Physics.addBody(ground, "static", {density = 1.0, friction = 0.3, bounce = 0.01})
    scene.ground = ground
    ground.id = "killer"
    
    -- add random placeholder box
    --[[
    local x = display.newRect(initX + 200, display.contentHeight - GROUND_HEIGHT - 100, 300, 100)
    x:setFillColor(0, 255, 0)
    _Physics.addBody(x, "static", {density = 1.0, friction = 0.3, bounce = 0.01})
    scene:insert(x)
    table.insert(scene.obstacles, x)
    --]]
    
    -- add random crate
    if(spawnCrate) then
        local crate = display.newImage( "images/crate_plain.png" )
        crate.x = initX + math.random(25, 960-25)
        crate.y = display.contentHeight - GROUND_HEIGHT - 100
        crate.id = "crate"
        _Physics.addBody(crate, "dynamic", {density = 0.01, friction = 0.01, bounce = 0.01})
        scene:insert(crate)
        scene.obstacles["crate"] = crate
        -- reverse pointer back to scene
        crate.scene = scene
    end
    
    function scene:removeCrate(crate)
        local scene = crate.scene
        if(crate and scene) then
            crate:removeSelf()
        end
        scene.obstacles["crate"] = nil
        
    end
    
    -- add random mountain
    if(spawnMountain) then
        local mountainPhysicsData = (require "physicseditor.mountain").physicsData(1.0)
        local mountainShape = display.newImage("images/Mountain_02.png")
        mountainShape.x = initX + math.random(256, 960-256)
        mountainShape.y = display.contentHeight - GROUND_HEIGHT - 100
        _Physics.addBody( mountainShape, "static", mountainPhysicsData:get("mountain") )
        scene:insert(mountainShape)
        scene.obstacles["mountain"] = mountainShape
        mountainShape.id = "killer" -- practically the same as ground
    end
    
    return scene
end

function Scene:removeCrate(crate)
    local scene = crate.scene
    table.remove(scene.obstacles, crate)
    scene:remove(crate)
end

return Scene