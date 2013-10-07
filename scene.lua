local Scene = {}
local _Physics = require("gamephysics")

-- constants
local GROUND_HEIGHT = 45

-- spawn likelihood
local spawnchance = {
    mountain = 30,
    mountain2 = 70,
    mountain3 = 70,
    trees = 100,
    crate = 0,
    fuel = 80
}

local sceneIndex = 0

function Scene:createScene(initX)
    sceneIndex = sceneIndex + 1

    local scene = display.newGroup()
    scene.obstacles = {}
    
    -- decide spawn
    local spawnMountain = spawnchance.mountain > math.random(0,100)
    local spawnMountain2 = spawnchance.mountain2 > math.random(0,100)
    local spawnMountain3 = spawnchance.mountain3 > math.random(0,100)
    local spawnTrees = spawnchance.trees > math.random(0,100)
    local spawnCrate = spawnchance.crate > math.random(0,100)
    local spawnFuel = spawnchance.fuel > math.random(0,100)
    
    -- add ground
    local ground = display.newRect(initX, display.contentHeight - GROUND_HEIGHT, display.contentWidth, GROUND_HEIGHT)
    ground:setFillColor(255, 0, 0)   -- TODO: random color for now, kill me at some point
    ground.alpha = 0.0
    scene:insert(ground)
    _Physics.addBody(ground, "static", {density = 1.0, friction = 0.3, bounce = 0.01})
    scene.ground = ground
    ground.id = "ground"
    ground.collisionType = "killer"
    
    -- add random crate
    local function createCrate(crateType)
        local crate = display.newImage( "images/"..crateType..".png" )
        crate.x = initX + math.random(25, 960-25)
        crate.y = display.contentHeight - GROUND_HEIGHT - 100
        crate.id = crateType
        _Physics.addBody(crate, "dynamic", {density = 0.01, friction = 1.0, bounce = 0.01})
        scene:insert(crate)
        scene.obstacles[crateType] = crate
        -- reverse pointer back to scene
        crate.scene = scene
        crate.sceneIndex = sceneIndex
    end
    
    if(spawnCrate) then
        createCrate('crate_plain')
    end
    
    if(spawnFuel) then
        createCrate('crate_fuel')
    end
    
    function scene:removeCrate(crate)
        local scene = crate.scene
        if(scene and crate) then
            crate:removeSelf()
            scene.obstacles[crate.id] = nil
        end
        
    end
    
    -- TODO: remove hardcodes here in the future, yuck
    -- add random mountain
    if(spawnMountain) then
        local mountainPhysicsData = (require "physicseditor.mountain").physicsData(1.0)
        local mountainShape = display.newImage("images/Mountain_02.png")
        mountainShape.x = initX + math.random(256, 960-256)
        mountainShape.y = display.contentHeight - GROUND_HEIGHT - 95
        _Physics.addBody( mountainShape, "static", mountainPhysicsData:get("mountain") )
        scene:insert(mountainShape)
        scene.obstacles["mountain"] = mountainShape
        mountainShape.id = "mountain" -- practically the same as ground
        mountainShape.collisionType = "killer"
    end
    
    -- add random mountain
    if(spawnMountain2) then
        local mountainPhysicsData2 = (require "physicseditor.mountain2").physicsData(1.0)
        local mountainShape2 = display.newImage("images/Mountain_01.png")
        mountainShape2.x = initX + math.random(256, 960-256)
        mountainShape2.y = display.contentHeight - GROUND_HEIGHT - 65
        _Physics.addBody( mountainShape2, "static", mountainPhysicsData2:get("Mountain_01") )
        scene:insert(mountainShape2)
        scene.obstacles["mountain2"] = mountainShape2
        mountainShape2.id = "mountain2" -- practically the same as ground
        mountainShape2.collisionType = "killer"
    end
    
    -- add random mountain
    if(spawnMountain3) then
        local mountainPhysicsData3 = (require "physicseditor.mountain3").physicsData(1.0)
        local mountainShape3 = display.newImage("images/Mountain_03.png")
        mountainShape3.x = initX + math.random(256, 960-256)
        mountainShape3.y = display.contentHeight - GROUND_HEIGHT - 37
        _Physics.addBody( mountainShape3, "static", mountainPhysicsData3:get("Mountain_03") )
        scene:insert(mountainShape3)
        scene.obstacles["mountain3"] = mountainShape3
        mountainShape3.id = "mountain3" -- practically the same as ground
        mountainShape3.collisionType = "killer"
    end
    
    if(spawnTrees) then
        local treePhysics = (require "physicseditor.trees").physicsData(1.0)
        for i=1,math.random(1,4),1 do
            local treeShape = display.newImage("images/trees"..i..".png")
            treeShape.x = initX + math.random(128, 960-128)
            treeShape.y = display.contentHeight - GROUND_HEIGHT - 21
            _Physics.addBody( treeShape, "static", treePhysics:get("trees"..i) )
            scene:insert(treeShape)
            scene.obstacles["trees"..i] = treeShape
            treeShape.id = "trees" -- practically the same as ground
            treeShape.collisionType = "killer"
        end
    end
    
    return scene
end

function Scene:removeCrate(crate)
    local scene = crate.scene
    table.remove(scene.obstacles, crate)
    scene:remove(crate)
end

return Scene