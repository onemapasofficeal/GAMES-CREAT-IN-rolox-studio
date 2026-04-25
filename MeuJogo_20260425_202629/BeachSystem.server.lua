local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local swimEvent    = Instance.new("RemoteEvent") swimEvent.Name    = "Swim"       swimEvent.Parent    = remotes
local sunbathEvent = Instance.new("RemoteEvent") sunbathEvent.Name = "Sunbathe"   sunbathEvent.Parent = remotes

-- Cria praia
local beachFolder = Instance.new("Folder") beachFolder.Name="Beach" beachFolder.Parent=Workspace

local sand = Instance.new("Part") sand.Size=Vector3.new(200,0.5,60) sand.Position=Vector3.new(-200,0.3,220) sand.Anchored=true sand.Color=Color3.fromRGB(240,220,150) sand.Material=Enum.Material.Sand sand.Parent=beachFolder
local ocean = Instance.new("Part") ocean.Size=Vector3.new(200,2,100) ocean.Position=Vector3.new(-200,0,280) ocean.Anchored=true ocean.Color=Color3.fromRGB(30,100,200) ocean.Material=Enum.Material.Water ocean.Parent=beachFolder

-- Guarda-sóis
for i = 1, 5 do
	local pole = Instance.new("Part") pole.Size=Vector3.new(0.3,4,0.3) pole.Position=Vector3.new(-200+i*30,2,215) pole.Anchored=true pole.Color=Color3.fromRGB(200,50,50) pole.Parent=beachFolder
	local top  = Instance.new("Part") top.Shape=Enum.PartType.Cylinder top.Size=Vector3.new(0.3,6,6) top.Position=Vector3.new(-200+i*30,4.5,215) top.Anchored=true top.Color=Color3.fromRGB(255,200,50) top.Parent=beachFolder
end

swimEvent.OnServerEvent:Connect(function(player)
	local addXP = remotes:FindFirstChild("AddXP")
	local drinkEvent = remotes:FindFirstChild("Drink")
	if addXP then addXP:FireServer(player, 8) end
	if drinkEvent then drinkEvent:FireServer(player, 10) end
	print(("[Praia] %s nadou"):format(player.Name))
end)

sunbathEvent.OnServerEvent:Connect(function(player)
	local addXP = remotes:FindFirstChild("AddXP")
	if addXP then addXP:FireServer(player, 3) end
	print(("[Praia] %s tomou sol"):format(player.Name))
end)
