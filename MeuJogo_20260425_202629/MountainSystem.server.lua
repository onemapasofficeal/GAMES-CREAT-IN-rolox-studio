local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local climbEvent = Instance.new("RemoteEvent") climbEvent.Name="Climb" climbEvent.Parent=remotes

-- Cria montanha
local mountainFolder = Instance.new("Folder") mountainFolder.Name="Mountain" mountainFolder.Parent=Workspace

local function addRock(pos, size)
	local r = Instance.new("Part") r.Size=size r.Position=pos r.Anchored=true r.Color=Color3.fromRGB(120,110,100) r.Material=Enum.Material.Rock r.Parent=mountainFolder
end

-- Montanha em camadas
for layer = 0, 8 do
	local scale = 1 - layer*0.1
	local height = layer * 8
	addRock(Vector3.new(150, height, 150), Vector3.new(80*scale, 8, 80*scale))
end

-- Neve no topo
local snow = Instance.new("Part") snow.Size=Vector3.new(20,4,20) snow.Position=Vector3.new(150,72,150) snow.Anchored=true snow.Color=Color3.fromRGB(240,240,255) snow.Material=Enum.Material.SmoothPlastic snow.Parent=mountainFolder

climbEvent.OnServerEvent:Connect(function(player)
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	-- Verifica se está perto da montanha
	if (root.Position - Vector3.new(150,0,150)).Magnitude < 50 then
		local addXP = remotes:FindFirstChild("AddXP")
		if addXP then addXP:FireServer(player, 15) end
		print(("[Montanha] %s escalou"):format(player.Name))
	end
end)
