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
local _MonsterCount =	{							-- Count of monsters on screen
							["zepp"] = 0,
							["total"] = 0
						}
local _Monsters = {}

function monster.init()
	local t_monster = display.newImage("images/zepp.png")
	t_monster.x = display.contentWidth 
	t_monster.y = 50
	t_monster.id = "zepp"
	_MonsterCount[t_monster.id] = _MonsterCount[t_monster.id] + 1
	_MonsterCount["total"] = _MonsterCount["total"]  + 1
	table.insert(_Monsters, t_monster)
end

function monster.scroll()
	for i=1, #_Monsters do
		_Monsters[i]:translate(-_Physics.sceneSpeed, 0)
		if (_Monsters[i].x + (_Monsters[i].width / 2)) < 0 then
			print(_MonsterCount[_Monsters[i].id])
			_MonsterCount[_Monsters[i].id] = _MonsterCount[_Monsters[i].id] - 1
			print(_MonsterCount[_Monsters[i].id])
			_MonsterCount["totals"] = _MonsterCount["total"] - 1
			_Monsters[i]:removeSelf()
			_Monsters[i] = nil
		end
	end
	
	
end


return monster