local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local acceptQuestEvent  = Instance.new("RemoteEvent")    acceptQuestEvent.Name  = "AcceptQuest"   acceptQuestEvent.Parent  = remotes
local completeQuestEvent= Instance.new("RemoteEvent")    completeQuestEvent.Name= "CompleteQuest" completeQuestEvent.Parent= remotes
local questListFn       = Instance.new("RemoteFunction") questListFn.Name       = "GetQuestList"  questListFn.Parent       = remotes
local questUpdateEvent  = Instance.new("RemoteEvent")    questUpdateEvent.Name  = "QuestUpdate"   questUpdateEvent.Parent  = remotes

local Quests = {
	{ id=1, name="Primeiro Emprego",   desc="Trabalhe 1 vez",          reward=200,  xp=50,  type="work",   goal=1  },
	{ id=2, name="Pescador Iniciante", desc="Pesque 5 peixes",         reward=300,  xp=80,  type="fish",   goal=5  },
	{ id=3, name="Fazendeiro",         desc="Colha 3 plantações",      reward=400,  xp=100, type="harvest",goal=3  },
	{ id=4, name="Minerador",          desc="Mine 10 minérios",        reward=600,  xp=150, type="mine",   goal=10 },
	{ id=5, name="Rico",               desc="Acumule R$5000",          reward=1000, xp=200, type="money",  goal=5000},
	{ id=6, name="Viajante",           desc="Ande 1000 studs",         reward=250,  xp=60,  type="walk",   goal=1000},
	{ id=7, name="Chef",               desc="Cozinhe 5 receitas",      reward=350,  xp=90,  type="cook",   goal=5  },
	{ id=8, name="Construtor",         desc="Compre uma casa",         reward=500,  xp=120, type="house",  goal=1  },
}

local playerQuests = {}  -- userId → { questId → progress }

Players.PlayerAdded:Connect(function(p)
	playerQuests[p.UserId] = {}
end)
Players.PlayerRemoving:Connect(function(p) playerQuests[p.UserId]=nil end)

questListFn.OnServerInvoke = function(player)
	return Quests, playerQuests[player.UserId] or {}
end

acceptQuestEvent.OnServerEvent:Connect(function(player, questId)
	local pq = playerQuests[player.UserId]
	if pq[questId] then return end
	pq[questId] = 0
	questUpdateEvent:FireClient(player, questId, 0)
	print(("[Quest] %s aceitou quest %d"):format(player.Name, questId))
end)

-- Função global para atualizar progresso de quest
local function updateQuestProgress(player, questType, amount)
	local pq = playerQuests[player.UserId]
	if not pq then return end
	for questId, progress in pairs(pq) do
		local quest = Quests[questId]
		if quest and quest.type == questType and progress < quest.goal then
			pq[questId] = math.min(quest.goal, progress + (amount or 1))
			questUpdateEvent:FireClient(player, questId, pq[questId])
			if pq[questId] >= quest.goal then
				-- Completa automaticamente
				local addMoney = remotes:FindFirstChild("AddMoney")
				local addXP    = remotes:FindFirstChild("AddXP")
				if addMoney then addMoney:FireServer(player, quest.reward) end
				if addXP    then addXP:FireServer(player, quest.xp) end
				pq[questId] = nil
				print(("[Quest] %s completou: %s"):format(player.Name, quest.name))
			end
		end
	end
end

_G.UpdateQuestProgress = updateQuestProgress
