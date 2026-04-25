local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local useParkEvent = Instance.new("RemoteEvent") useParkEvent.Name="UsePark" useParkEvent.Parent=remotes

-- Cria parque no mapa
local parkFolder = Instance.new("Folder") parkFolder.Name="Park" parkFolder.Parent=Workspace

local function addBench(pos)
	local bench = Instance.new("Part") bench.Size=Vector3.new(4,0.5,1) bench.Position=pos bench.Anchored=true bench.Color=Color3.fromRGB(150,100,50) bench.Material=Enum.Material.Wood bench.Parent=parkFolder
end

local function addTree(pos)
	local trunk = Instance.new("Part") trunk.Size=Vector3.new(1,4,1) trunk.Position=pos+Vector3.new(0,2,0) trunk.Anchored=true trunk.Color=Color3.fromRGB(100,60,20) trunk.Material=Enum.Material.Wood trunk.Parent=parkFolder
	local leaves = Instance.new("Part") leaves.Shape=Enum.PartType.Ball leaves.Size=Vector3.new(5,5,5) leaves.Position=pos+Vector3.new(0,6,0) leaves.Anchored=true leaves.Color=Color3.fromRGB(50,150,50) leaves.Material=Enum.Material.Grass leaves.Parent=parkFolder
end

-- Spawna elementos do parque
for i = 1, 8 do addBench(Vector3.new(-180+i*10, 1, -180)) end
for i = 1, 12 do addTree(Vector3.new(-190+i*8, 1, -190+math.random(-5,5))) end

-- Lago
local lake = Instance.new("Part") lake.Size=Vector3.new(40,0.5,40) lake.Position=Vector3.new(-160,0.5,-160) lake.Anchored=true lake.Color=Color3.fromRGB(50,100,200) lake.Material=Enum.Material.Water lake.Parent=parkFolder

useParkEvent.OnServerEvent:Connect(function(player)
	local addXP = remotes:FindFirstChild("AddXP")
	if addXP then addXP:FireServer(player, 5) end
	-- Restaura um pouco de energia
	local sleepUpdate = remotes:FindFirstChild("SleepUpdate")
	if sleepUpdate then sleepUpdate:FireClient(player, 10, false) end
	print(("[Parque] %s relaxou no parque"):format(player.Name))
end)
