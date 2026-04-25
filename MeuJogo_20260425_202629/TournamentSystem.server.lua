local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local joinTournamentEvent = Instance.new("RemoteEvent")    joinTournamentEvent.Name = "JoinTournament"  joinTournamentEvent.Parent = remotes
local tournamentUpdate    = Instance.new("RemoteEvent")    tournamentUpdate.Name    = "TournamentUpdate" tournamentUpdate.Parent    = remotes
local tournamentInfoFn    = Instance.new("RemoteFunction") tournamentInfoFn.Name    = "GetTournamentInfo" tournamentInfoFn.Parent   = remotes

local Tournaments = {
	{ name="Torneio de Pesca",    entryFee=100,  prize=1000, minPlayers=4, type="fishing"  },
	{ name="Corrida de Carros",   entryFee=500,  prize=5000, minPlayers=4, type="racing"   },
	{ name="Batalha PvP",         entryFee=200,  prize=2000, minPlayers=8, type="pvp"      },
	{ name="Torneio de Culinária",entryFee=150,  prize=1500, minPlayers=4, type="cooking"  },
}

local activeTournament = nil
local participants = {}

tournamentInfoFn.OnServerInvoke = function()
	return activeTournament, participants
end

-- Inicia torneios periodicamente
task.spawn(function()
	while true do
		task.wait(math.random(400, 800))
		activeTournament = Tournaments[math.random(1,#Tournaments)]
		participants = {}

		for _, p in ipairs(Players:GetPlayers()) do
			tournamentUpdate:FireClient(p, activeTournament, participants)
		end
		print(("[Torneio] Iniciou: "..activeTournament.name))

		task.wait(60)  -- 1 min para inscrições

		if #participants >= activeTournament.minPlayers then
			-- Escolhe vencedor aleatório
			local winner = participants[math.random(1,#participants)]
			local winnerPlayer = Players:FindFirstChild(winner)
			if winnerPlayer then
				local addMoney = remotes:FindFirstChild("AddMoney")
				if addMoney then addMoney:FireServer(winnerPlayer, activeTournament.prize) end
			end
			print(("[Torneio] Vencedor: "..(winner or "Ninguém")))
		end

		activeTournament = nil
		participants = {}
		for _, p in ipairs(Players:GetPlayers()) do
			tournamentUpdate:FireClient(p, nil, {})
		end
	end
end)

joinTournamentEvent.OnServerEvent:Connect(function(player)
	if not activeTournament then return end
	for _, p in ipairs(participants) do if p==player.Name then return end end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, activeTournament.entryFee) end

	table.insert(participants, player.Name)
	for _, p in ipairs(Players:GetPlayers()) do
		tournamentUpdate:FireClient(p, activeTournament, participants)
	end
end)
