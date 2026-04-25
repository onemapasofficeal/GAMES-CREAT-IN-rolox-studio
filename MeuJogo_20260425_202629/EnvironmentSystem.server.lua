-- Controla poluição, limpeza e saúde ambiental da cidade
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local cleanEvent   = Instance.new("RemoteEvent")    cleanEvent.Name   = "CleanCity"    cleanEvent.Parent   = remotes
local envInfoFn    = Instance.new("RemoteFunction") envInfoFn.Name    = "GetEnvInfo"   envInfoFn.Parent    = remotes
local envUpdate    = Instance.new("RemoteEvent")    envUpdate.Name    = "EnvUpdate"    envUpdate.Parent    = remotes

local pollution = 0  -- 0-100

local function applyPollution()
	local atm = Lighting:FindFirstChildOfClass("Atmosphere")
	if atm then
		atm.Density = 0.1 + (pollution/100) * 0.8
		atm.Haze = pollution/20
	end
	Lighting.FogEnd = math.max(200, 2000 - pollution*15)
end

-- Poluição aumenta com o tempo
task.spawn(function()
	while true do
		task.wait(30)
		pollution = math.min(100, pollution + 1)
		applyPollution()
		for _, p in ipairs(Players:GetPlayers()) do
			envUpdate:FireClient(p, pollution)
		end
		if pollution >= 80 then
			-- Dano por poluição extrema
			for _, p in ipairs(Players:GetPlayers()) do
				local char = p.Character
				if char then
					local hum = char:FindFirstChild("Humanoid")
					if hum then hum.Health = math.max(1, hum.Health - 1) end
				end
			end
		end
	end
end)

envInfoFn.OnServerInvoke = function() return pollution end

cleanEvent.OnServerEvent:Connect(function(player)
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, 100) end

	pollution = math.max(0, pollution - 10)
	applyPollution()

	local addXP = remotes:FindFirstChild("AddXP")
	if addXP then addXP:FireServer(player, 15) end

	for _, p in ipairs(Players:GetPlayers()) do envUpdate:FireClient(p, pollution) end
	print(("[Ambiente] %s limpou a cidade. Poluição: %d%%"):format(player.Name, pollution))
end)
