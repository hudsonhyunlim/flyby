local hero = display.newImage( "ika.png" )
hero.x = display.contentWidth / 2
hero.y = 50
hero.myName = 'hero'
--ika.rotation = 35

local monster = display.newImage( "ika.png" )
monster.x = display.contentWidth - 100
monster.y = display.contentHeight - 100
monster.myName = 'monster'

local ground = display.newRect(0,display.contentHeight - 50, display.contentWidth, 50)
local topWall = display.newRect(50, 0, display.contentWidth - 50, 20)
ground.myName = 'ground'
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