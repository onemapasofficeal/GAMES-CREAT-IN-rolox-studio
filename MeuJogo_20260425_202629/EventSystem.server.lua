-- Eventos especiais do servidor (corrida, batalha, etc.)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local joinEventEvent   = Instance.new("RemoteEvent")    joinEventEvent.Name   = "JoinEvent"    joinEventEvent.Parent   = remotes
local eventUpdateEvent = Instance.new("RemoteEvent")    eventUpdateEvent.Name = "EventUpdate"  eventUpdateEvent.Parent = remotes
local currentEventFn   = Instance.new("RemoteFunction") currentEventFn.Name   = "GetCurrentEvent" currentEventFn.Parent = remotes

local Events = {
	{ name="Corrida de Carros",  duration=120, reward=1000, minPlayers=2 },
	{ name="Batalha Campal",     duration=180, reward=2000, minPlayers=4 },
	{ name="Caça ao Tesouro",    duration=300, reward=3000, minPlayers=1 },
	{ name="Torneio de Pesca",   duration=240, reward=1500, minPlayers=2 },
	{ name="Festival da Cidade", duration=600, reward=500,  minPlayers=1 },
}

local currentEvent = nil
local participants = {}

currentEventFn.OnServerInvoke = function()
	return currentEvent, participants
end

joinEventEvent.OnServerEvent:Connect(function(player)
	if not currentEvent then return end
	for _, p in ipairs(participants) do if p==player.Name then return end end
	table.insert(participants, player.Name)
	for _, p in ipairs(Players:GetPlayers()) do
		eventUpdateEvent:FireClient(p, currentEvent, participants)
	end
end)

-- Inicia eventos aleatórios
task.spawn(function()
	while true do
		task.wait(math.random(300, 600))
		currentEvent = Events[math.random(1,#Events)]
		participants = {}

		for _, p in ipairs(Players:GetPlayers()) do
			eventUpdateEvent:FireClient(p, currentEvent, participants)
		end
		print(("[Evento] Iniciou: "..currentEvent.name))

		task.wait(currentEvent.duration)

		-- Premia participantes
		for _, name in ipairs(participants) do
			local p = Players:FindFirstChild(name)
			if p then
				local addMoney = remotes:FindFirstChild("AddMoney")
				if addMoney then addMoney:FireServer(p, currentEvent.reward) end
			end
		end

		currentEvent = nil
		participants = {}
		for _, p in ipairs(Players:GetPlayers()) do
			eventUpdateEvent:FireClient(p, nil, {})
		end
	end
end)
