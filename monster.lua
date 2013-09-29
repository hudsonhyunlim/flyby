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
							["zepp_fall"] = 0,
							["zepp_fall_recent"] = 0,
							["total"] = 0
						}
local _Monsters = {}

local function onCollision(self, event) -- Explode the enemies
	-- print ("Not Explode")
	if(event.phase == "began") then
		-- print ("Explode Begin")
		if(event.other.id and event.other.collisionType == "killer") then
            -- dead
            -- print ("Explode")
            event.target.alpha = 0.0  -- hide plane
            event.target.isAlive = false
            local Explosion = require "explosion"
            Explosion:createExplosion(event.target.x, event.target.y)
			timer.performWithDelay(1,function() event.target.x = -100 end)
			
            -- TODO: remove plane physics body as well?
			if (event.other.id == "crate") then
				event.other.alpha = 0.0
				local ExplosionOther = require "explosion"
				ExplosionOther:createExplosion(event.other.x, event.other.y)
			end
        end
    end
end



local function addMonster(monsterType, vMagnitude) -- Monster type is the monster name, vMagnitude is the height
	if (monsterType == "zepp") then
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
	elseif (monsterType == "zepp_fall") then
		local t_monster = display.newImage("images/zepp.png")
		local physicsData = (require "physicseditor.zepp").physicsData(1.0)
		_Physics.addBody( t_monster, physicsData:get("zepp") )
		t_monster.x = (display.contentWidth + (t_monster.width / 2))
		t_monster.y = 50 + (100 * vMagnitude)
		t_monster.id = "zepp_fall"
		t_monster.collisionType = "killer"
		_MonsterCount[t_monster.id] = _MonsterCount[t_monster.id] + 1
		_MonsterCount["total"] = _MonsterCount["total"]  + 1
		table.insert(_Monsters, t_monster)
		t_monster.collision = onCollision
		t_monster:addEventListener("collision", t_monster)
	end	
end

local function spawnMonster()
	local monsterRandom = math.random(0, 1)
	if (monsterRandom == 0) then
		if _MonsterCount["zepp_recent"] == 0 then
			if (_MonsterCount["zepp"] == 0) then
				-- if (math.random(0, 1))
				addMonster("zepp", math.random(0,2))
				_MonsterCount["zepp_recent"] = _MonsterCount["zepp_recent"] + 1
				-- print("Monster Count".._MonsterCount["zepp_recent"])
				timer.performWithDelay((1000*math.random(1, 10)), function()
												_MonsterCount["zepp_recent"] = _MonsterCount["zepp_recent"] - 1
												-- print("Monster count: ".._MonsterCount["zepp_recent"])
												end)
			end
		end
	elseif (monsterRandom == 1) then
		if _MonsterCount["zepp_fall_recent"] == 0 then
			if (_MonsterCount["zepp_fall"] == 0) then
				-- if (math.random(0, 1))
				addMonster("zepp_fall", math.random(0,2))
				_MonsterCount["zepp_fall_recent"] = _MonsterCount["zepp_fall_recent"] + 1
				-- print("ZeppFall Count".._MonsterCount["zepp_fall_recent"])
				timer.performWithDelay((1000*math.random(1, 10)), function()
												_MonsterCount["zepp_fall_recent"] = _MonsterCount["zepp_fall_recent"] - 1
												-- print("ZeppFall count: ".._MonsterCount["zepp_fall_recent"])
												end)
			end
		end
	end
end


function monster.init()
	for i=1, #_Monsters do
		_Monsters[i]:removeSelf()
		_Monsters[i] = nil
	end
	for key,value in pairs(_MonsterCount) do
		_MonsterCount[key] = 0
	end
end


function monster.scroll()
	for i=1, #_Monsters do
		_Monsters[i]:translate(-_Physics.sceneSpeed, 0)
		if (_Monsters[i].x + (_Monsters[i].width / 2)) < 0 then
			-- print(_MonsterCount[_Monsters[i].id])
			_MonsterCount[_Monsters[i].id] = _MonsterCount[_Monsters[i].id] - 1
			-- print(_MonsterCount[_Monsters[i].id])
			_MonsterCount["total"] = _MonsterCount["total"] - 1
			_Monsters[i]:removeSelf()
			_Monsters[i] = nil
		end
	end	
	-- print(_MonsterCount["total"])
	if _MonsterCount["total"] < 1 then
		spawnMonster()
	end
end




return monster