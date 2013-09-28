local hero = display.newImage( "ika.png" )
hero.x = display.contentWidth / 2
hero.y = 50
hero.myName = 'hero'
--ika.rotation = 35

local monster = display.newImage( "ika.png" )
monster.x = display.contentWidth - 100
monster.y = display.contentHeight - 100
monster.myName = 'monster'

local topWall = display.newRect(50, 0, display.contentWidth - 50, 20)
topWall.myName = 'topWall'

local function onCollision( event )
        if ( event.phase == "began" ) then
 
                print( "began: " .. event.object1.myName .. " & " .. event.object2.myName )
				--event.object2:setLinearVelocity( 0, -100)
        elseif ( event.phase == "ended" ) then
 
                print( "ended: " .. event.object1.myName .. " & " .. event.object2.myName )
 
        end
end

local function handleScreenTap( event )
	local function forth()
		transition.to( hero, { time=400, x=(hero.x-50), transition = easing.outQuad, onComplete = back} )
	end
	local function back()
		transition.to( hero, { time=400, x=(hero.x+50), transition = easing.inQuad, onComplete = forth} )
	end
	back()
	
end

Runtime:addEventListener( "collision", onCollision )

Runtime:addEventListener( "tap", handleScreenTap )

local SCENE_BUFFER_SIZE = 3
local sceneSpeed = -20
local scenes = {}

local function createScene(initX)
    local scene = display.newGroup()
    local ground = display.newRect(initX, 640-50, 960, 50)
    ground:setFillColor(math.random(100,255), math.random(100,255), math.random(100,255))
    scene:insert(ground)
    return scene
end

local function destroySceneHandler()
    --ground:removeSelf()
end

local function testFunc()
    print('test')
end

-- create initial scenes
table.insert(scenes, 1, createScene(0))
table.insert(scenes, 1, createScene(960))

local function drawScene()
    if(scenes[1].x <= -960) then
        local scene = table.remove(scenes)
        scene:removeSelf()
        table.insert(scenes, 1, createScene(960))
    end
    for k,scene in pairs(scenes) do
        if scene then
            scene:translate(sceneSpeed, 0)
        end
    end
end

timer.performWithDelay(1, drawScene, -1)