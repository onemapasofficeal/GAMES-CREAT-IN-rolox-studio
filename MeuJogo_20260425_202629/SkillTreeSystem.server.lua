local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local upgradeSkillEvent = Instance.new("RemoteEvent")    upgradeSkillEvent.Name = "UpgradeSkill"   upgradeSkillEvent.Parent = remotes
local skillTreeFn       = Instance.new("RemoteFunction") skillTreeFn.Name       = "GetSkillTree"   skillTreeFn.Parent       = remotes
local skillUpdate       = Instance.new("RemoteEvent")    skillUpdate.Name       = "SkillUpdate"    skillUpdate.Parent       = remotes

local SkillTree = {
	{ id=1,  name="Força",         maxLevel=5, costPerLevel=100, effect="damage+10%"   },
	{ id=2,  name="Velocidade",    maxLevel=5, costPerLevel=100, effect="speed+5"      },
	{ id=3,  name="Resistência",   maxLevel=5, costPerLevel=150, effect="hp+20"        },
	{ id=4,  name="Sorte",         maxLevel=3, costPerLevel=200, effect="loot+10%"     },
	{ id=5,  name="Carisma",       maxLevel=3, costPerLevel=200, effect="price-5%"     },
	{ id=6,  name="Inteligência",  maxLevel=5, costPerLevel=150, effect="xp+10%"       },
	{ id=7,  name="Furtividade",   maxLevel=3, costPerLevel=250, effect="wanted-1"     },
	{ id=8,  name="Culinária",     maxLevel=5, costPerLevel=100, effect="food+10%"     },
	{ id=9,  name="Pesca",         maxLevel=5, costPerLevel=100, effect="fish+10%"     },
	{ id=10, name="Mineração",     maxLevel=5, costPerLevel=100, effect="mine+10%"     },
}

local playerSkills = {}  -- userId → { skillId → level }
local skillPoints  = {}  -- userId → points

Players.PlayerAdded:Connect(function(p)
	playerSkills[p.UserId] = {}
	skillPoints[p.UserId] = 5
	for _, s in ipairs(SkillTree) do playerSkills[p.UserId][s.id] = 0 end
end)
Players.PlayerRemoving:Connect(function(p) playerSkills[p.UserId]=nil skillPoints[p.UserId]=nil end)

skillTreeFn.OnServerInvoke = function(player)
	return SkillTree, playerSkills[player.UserId] or {}, skillPoints[player.UserId] or 0
end

upgradeSkillEvent.OnServerEvent:Connect(function(player, skillId)
	local skill = nil
	for _, s in ipairs(SkillTree) do if s.id==skillId then skill=s break end end
	if not skill then return end

	local currentLevel = playerSkills[player.UserId][skillId] or 0
	if currentLevel >= skill.maxLevel then return end
	if (skillPoints[player.UserId] or 0) <= 0 then return end

	local cost = skill.costPerLevel * (currentLevel + 1)
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, cost) end

	playerSkills[player.UserId][skillId] = currentLevel + 1
	skillPoints[player.UserId] -= 1

	-- Aplica efeito
	local char = player.Character
	if char then
		local hum = char:FindFirstChild("Humanoid")
		if hum then
			if skill.id == 2 then hum.WalkSpeed = hum.WalkSpeed + 5 end
			if skill.id == 3 then hum.MaxHealth = hum.MaxHealth + 20 end
		end
	end

	skillUpdate:FireClient(player, playerSkills[player.UserId], skillPoints[player.UserId])
	print(("[Skill] %s melhorou %s para nível %d"):format(player.Name, skill.name, currentLevel+1))
end)

-- Ganha pontos de skill ao subir de nível
_G.OnLevelUp = function(player)
	if skillPoints[player.UserId] then
		skillPoints[player.UserId] += 1
		skillUpdate:FireClient(player, playerSkills[player.UserId], skillPoints[player.UserId])
	end
end
