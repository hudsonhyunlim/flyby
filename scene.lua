local Scene = {}
local _Physics = require('gamephysics')

function Scene:createScene(initX)
    local scene = display.newGroup()
    local ground = display.newRect(initX, display.contentHeight-50, display.contentWidth, 50)
    ground:setFillColor(math.random(100,255), math.random(100,255), math.random(100,255))
    scene:insert(ground)
    scene.ground = ground
    _Physics.addBody(ground, "static", {density = 1.0, friction = 0.3, bounce = 0.01})
    return scene
end

return Scene