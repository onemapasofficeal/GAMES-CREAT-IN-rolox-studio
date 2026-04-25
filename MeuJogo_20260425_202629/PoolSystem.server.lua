local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local usePoolEvent = Instance.new("RemoteEvent") usePoolEvent.Name="UsePool" usePoolEvent.Parent=remotes

-- Cria piscina pública
local poolFolder = Instance.new("Folder") poolFolder.Name="Pool" poolFolder.Parent=Workspace

local poolBase = Instance.new("Part") poolBase.Size=Vector3.new(30,0.5,20) poolBase.Position=Vector3.new(60,0,60) poolBase.Anchored=true poolBase.Color=Color3.fromRGB(100,180,220) poolBase.Material=Enum.Material.SmoothPlastic poolBase.Parent=poolFolder
local water = Instance.new("Part") water.Size=Vector3.new(28,1,18) water.Position=Vector3.new(60,1,60) water.Anchored=true water.Color=Color3.fromRGB(50,150,220) water.Material=Enum.Material.Water water.Transparency=0.3 water.Parent=poolFolder

-- Bordas
for _, offset in ipairs({Vector3.new(15,1,0),Vector3.new(-15,1,0),Vector3.new(0,1,10),Vector3.new(0,1,-10)}) do
	local wall = Instance.new("Part") wall.Size=offset.X~=0 and Vector3.new(1,2,20) or Vector3.new(30,2,1) wall.Position=Vector3.new(60,1,60)+offset wall.Anchored=true wall.Color=Color3.fromRGB(220,220,220) wall.Material=Enum.Material.SmoothPlastic wall.Parent=poolFolder
end

usePoolEvent.OnServerEvent:Connect(function(player)
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	if (root.Position - Vector3.new(60,0,60)).Magnitude < 20 then
		local drinkEvent = remotes:FindFirstChild("Drink")
		local addXP = remotes:FindFirstChild("AddXP")
		if drinkEvent then drinkEvent:FireServer(player, 15) end
		if addXP then addXP:FireServer(player, 5) end
		print(("[Piscina] %s nadou na piscina"):format(player.Name))
	end
end)
