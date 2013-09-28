-----------------------------------------------------------------------------------------
-- 
-- monster.lua
--
-----------------------------------------------------------------------------------------
-- Fly By
-- Fox Dark
-- 2013-09-27

local monster = {}

-- | VARIABLE DECLARATIONS | --
local _Physics = require "gamephysics"				-- This is the object that handles the world's physics
local _MonsterCount = 0								-- Count of monsters on screen
local _Monsters = {}

function monster.init()
	local t_monster = display.newImage("ika.png")
	t_monster.x = display.contentWidth / 2
	t_monster.y = 50
	table.insert(_Monsters, t_monster)
end

function monster.scroll()
	for m in _Monsters do
		m:translate(-Physics.sceneSpeed, 0)
		if m.x < 0 then
			m:removeSelf()
			m = nil
		end
	end
	
end


return monster