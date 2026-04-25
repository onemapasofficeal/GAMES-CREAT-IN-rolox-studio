local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local castSpellEvent = Instance.new("RemoteEvent")    castSpellEvent.Name = "CastSpell"    castSpellEvent.Parent = remotes
local learnSpellEvent= Instance.new("RemoteEvent")    learnSpellEvent.Name= "LearnSpell"   learnSpellEvent.Parent= remotes
local spellListFn    = Instance.new("RemoteFunction") spellListFn.Name    = "GetSpellList" spellListFn.Parent    = remotes

local Spells = {
	{ id=1, name="Bola de Fogo",   cost=100, damage=50,  heal=0,   manaCost=20, price=500  },
	{ id=2, name="Cura",           cost=0,   damage=0,   heal=50,  manaCost=15, price=400  },
	{ id=3, name="Raio",           cost=0,   damage=80,  heal=0,   manaCost=30, price=800  },
	{ id=4, name="Escudo Mágico",  cost=0,   damage=0,   heal=0,   manaCost=25, price=600  },
	{ id=5, name="Teletransporte", cost=0,   damage=0,   heal=0,   manaCost=40, price=1000 },
	{ id=6, name="Invocação",      cost=0,   damage=100, heal=0,   manaCost=50, price=2000 },
}

local playerSpells = {}
local playerMana   = {}

Players.PlayerAdded:Connect(function(p)
	playerSpells[p.UserId] = {}
	playerMana[p.UserId] = 100
	task.spawn(function()
		while playerMana[p.UserId] do
			task.wait(5)
			playerMana[p.UserId] = math.min(100, (playerMana[p.UserId] or 0) + 5)
		end
	end)
end)
Players.PlayerRemoving:Connect(function(p) playerSpells[p.UserId]=nil playerMana[p.UserId]=nil end)

spellListFn.OnServerInvoke = function(player)
	return Spells, playerSpells[player.UserId] or {}
end

learnSpellEvent.OnServerEvent:Connect(function(player, spellId)
	local spell = nil
	for _, s in ipairs(Spells) do if s.id==spellId then spell=s break end end
	if not spell then return end
	if playerSpells[player.UserId][spellId] then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, spell.price) end
	playerSpells[player.UserId][spellId] = true
	print(("[Magia] %s aprendeu %s"):format(player.Name, spell.name))
end)

castSpellEvent.OnServerEvent:Connect(function(player, spellId, targetName)
	local spell = nil
	for _, s in ipairs(Spells) do if s.id==spellId then spell=s break end end
	if not spell then return end
	if not playerSpells[player.UserId][spellId] then return end
	if (playerMana[player.UserId] or 0) < spell.manaCost then return end

	playerMana[player.UserId] -= spell.manaCost

	if spell.heal > 0 then
		local char = player.Character
		if char then
			local hum = char:FindFirstChild("Humanoid")
			if hum then hum.Health = math.min(hum.MaxHealth, hum.Health + spell.heal) end
		end
	end

	if spell.damage > 0 and targetName then
		local target = Players:FindFirstChild(targetName)
		if target and target.Character then
			local hum = target.Character:FindFirstChild("Humanoid")
			if hum then hum.Health = math.max(0, hum.Health - spell.damage) end
		end
	end

	print(("[Magia] %s usou %s"):format(player.Name, spell.name))
end)
