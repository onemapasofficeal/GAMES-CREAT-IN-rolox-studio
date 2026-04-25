local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local achievementUnlocked = Instance.new("RemoteEvent") achievementUnlocked.Name="AchievementUnlocked" achievementUnlocked.Parent=remotes
local getAchievementsFn   = Instance.new("RemoteFunction") getAchievementsFn.Name="GetAchievements" getAchievementsFn.Parent=remotes

local Achievements = {
	{ id=1,  name="Bem-vindo!",       desc="Entre no jogo pela primeira vez",    reward=100  },
	{ id=2,  name="Primeiro Salário", desc="Receba seu primeiro pagamento",       reward=200  },
	{ id=3,  name="Milionário",       desc="Acumule R$1.000.000",                reward=5000 },
	{ id=4,  name="Pescador Mestre",  desc="Pesque 100 peixes",                  reward=500  },
	{ id=5,  name="Construtor",       desc="Compre sua primeira casa",            reward=300  },
	{ id=6,  name="Motorista",        desc="Compre seu primeiro carro",           reward=300  },
	{ id=7,  name="Criminoso",        desc="Alcance nível 5 de procurado",        reward=0    },
	{ id=8,  name="Herói",            desc="Prenda 10 criminosos",               reward=1000 },
	{ id=9,  name="Chef Estrela",     desc="Cozinhe 50 receitas",                reward=800  },
	{ id=10, name="Nível 50",         desc="Alcance o nível 50",                 reward=2000 },
	{ id=11, name="Fazendeiro Mestre",desc="Colha 100 plantações",               reward=600  },
	{ id=12, name="Minerador Mestre", desc="Mine 500 minérios",                  reward=1000 },
}

local playerAchievements = {}  -- userId → set de ids desbloqueados

Players.PlayerAdded:Connect(function(p)
	playerAchievements[p.UserId] = {}
	-- Conquista de boas-vindas
	task.wait(2)
	_G.UnlockAchievement(p, 1)
end)
Players.PlayerRemoving:Connect(function(p) playerAchievements[p.UserId]=nil end)

getAchievementsFn.OnServerInvoke = function(player)
	return Achievements, playerAchievements[player.UserId] or {}
end

_G.UnlockAchievement = function(player, achievementId)
	local pa = playerAchievements[player.UserId]
	if not pa then return end
	if pa[achievementId] then return end
	pa[achievementId] = true

	local ach = Achievements[achievementId]
	if not ach then return end

	if ach.reward > 0 then
		local addMoney = remotes:FindFirstChild("AddMoney")
		if addMoney then addMoney:FireServer(player, ach.reward) end
	end

	achievementUnlocked:FireClient(player, ach)
	print(("[Conquista] %s desbloqueou: %s"):format(player.Name, ach.name))
end
