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
							["zepp_recent"] = 0,
							["total"] = 0
						}
local _Monsters = {}

local function addMonster(monsterType, vMagnitude) -- Monster type is the monster name, vMagnitude is the height
	local t_monster = display.newImage("images/zepp.png")
	local physicsData = (require "physicseditor.zepp").physicsData(1.0)
	_Physics.addBody( t_monster,"static", physicsData:get("zepp") )
	t_monster.x = (display.contentWidth + (t_monster.width / 2))
	t_monster.y = 50 + (100 * vMagnitude)
	t_monster.id = "zepp"
	t_monster.collisionType = "killer"
	_MonsterCount[t_monster.id] = _MonsterCount[t_monster.id] + 1
	_MonsterCount["total"] = _MonsterCount["total"]  + 1
	table.insert(_Monsters, t_monster)
end

local function spawnMonster()
	if _MonsterCount["zepp_recent"] == 0 then
		if (_MonsterCount["zepp"] == 0) then
			-- if (math.random(0, 1))
			addMonster("zepp", math.random(0,2))
			_MonsterCount["zepp_recent"] = _MonsterCount["zepp_recent"] + 1
			print("Monster Count".._MonsterCount["zepp_recent"])
			timer.performWithDelay((1000*math.random(1, 10)), function()
											_MonsterCount["zepp_recent"] = _MonsterCount["zepp_recent"] - 1
											print("Monster count: ".._MonsterCount["zepp_recent"])
											end)
		end
	end
end


function monster.init()
	--[[local t_monster = display.newImage("images/zepp.png")
	local physicsData = (require "physicseditor.zepp").physicsData(1.0)
	_Physics.addBody( t_monster,"static", physicsData:get("zepp") )
	t_monster.x = (display.contentWidth + (t_monster.width / 2))
	t_monster.y = 50
	t_monster.id = "zepp"
	_MonsterCount[t_monster.id] = _MonsterCount[t_monster.id] + 1
	_MonsterCount["total"] = _MonsterCount["total"]  + 1
	table.insert(_Monsters, t_monster)
	--]]
end


function monster.scroll()
	for i=1, #_Monsters do
		_Monsters[i]:translate(-_Physics.sceneSpeed, 0)
		if (_Monsters[i].x + (_Monsters[i].width / 2)) < 0 then
			print(_MonsterCount[_Monsters[i].id])
			_MonsterCount[_Monsters[i].id] = _MonsterCount[_Monsters[i].id] - 1
			print(_MonsterCount[_Monsters[i].id])
			_MonsterCount["total"] = _MonsterCount["total"] - 1
			_Monsters[i]:removeSelf()
			_Monsters[i] = nil
		end
	end	
	if _MonsterCount["total"] < 1 then
		spawnMonster()
	end
end




return monster