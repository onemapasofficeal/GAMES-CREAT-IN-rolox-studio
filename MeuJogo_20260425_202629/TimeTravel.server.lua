local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local travelEvent  = Instance.new("RemoteEvent")    travelEvent.Name  = "TimeTravel"    travelEvent.Parent  = remotes
local eraListFn    = Instance.new("RemoteFunction") eraListFn.Name    = "GetEraList"    eraListFn.Parent    = remotes
local eraUpdate    = Instance.new("RemoteEvent")    eraUpdate.Name    = "EraUpdate"     eraUpdate.Parent    = remotes

local Eras = {
	{ id=1, name="Pré-História",  year=-10000, ambient=Color3.fromRGB(100,80,50),  fog=500  },
	{ id=2, name="Idade Média",   year=1200,   ambient=Color3.fromRGB(120,100,80), fog=800  },
	{ id=3, name="Renascimento",  year=1500,   ambient=Color3.fromRGB(150,130,100),fog=1000 },
	{ id=4, name="Revolução Industrial",year=1850,ambient=Color3.fromRGB(100,100,100),fog=400},
	{ id=5, name="Presente",      year=2024,   ambient=Color3.fromRGB(180,180,180),fog=2000 },
	{ id=6, name="Futuro 2100",   year=2100,   ambient=Color3.fromRGB(100,150,200),fog=3000 },
	{ id=7, name="Futuro 3000",   year=3000,   ambient=Color3.fromRGB(50,100,255), fog=5000 },
}

local currentEra = 5

eraListFn.OnServerInvoke = function() return Eras, currentEra end

travelEvent.OnServerEvent:Connect(function(player, eraId)
	local era = nil
	for _, e in ipairs(Eras) do if e.id==eraId then era=e break end end
	if not era then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, 1000) end

	currentEra = eraId
	Lighting.Ambient = era.ambient
	Lighting.FogEnd = era.fog

	for _, p in ipairs(Players:GetPlayers()) do
		eraUpdate:FireClient(p, era)
	end
	print(("[Tempo] %s viajou para %s (%d)"):format(player.Name, era.name, era.year))
end)
