local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local seasonUpdate = Instance.new("RemoteEvent") seasonUpdate.Name="SeasonUpdate" seasonUpdate.Parent=remotes

local Seasons = {
	{
		name = "Primavera",
		groundColor = Color3.fromRGB(100,160,60),
		ambient = Color3.fromRGB(180,200,160),
		fogEnd = 2000,
		duration = 300
	},
	{
		name = "Verão",
		groundColor = Color3.fromRGB(80,140,40),
		ambient = Color3.fromRGB(200,190,150),
		fogEnd = 3000,
		duration = 300
	},
	{
		name = "Outono",
		groundColor = Color3.fromRGB(150,100,40),
		ambient = Color3.fromRGB(180,150,100),
		fogEnd = 1500,
		duration = 300
	},
	{
		name = "Inverno",
		groundColor = Color3.fromRGB(220,230,240),
		ambient = Color3.fromRGB(150,160,180),
		fogEnd = 800,
		duration = 300
	},
}

local currentSeasonIndex = 1

local function applySeason(season)
	Lighting.Ambient = season.ambient
	Lighting.FogEnd = season.fogEnd

	local ground = Workspace:FindFirstChild("Ground")
	if ground then ground.Color = season.groundColor end

	for _, p in ipairs(Players:GetPlayers()) do
		seasonUpdate:FireClient(p, season.name)
	end
	print(("[Estação] Agora é: "..season.name))
end

task.spawn(function()
	while true do
		local season = Seasons[currentSeasonIndex]
		applySeason(season)
		task.wait(season.duration)
		currentSeasonIndex = (currentSeasonIndex % #Seasons) + 1
	end
end)
