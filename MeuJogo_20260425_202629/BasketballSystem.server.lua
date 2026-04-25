local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local shootBasketEvent = Instance.new("RemoteEvent") shootBasketEvent.Name="ShootBasket" shootBasketEvent.Parent=remotes

-- Cria quadra
local courtFolder = Instance.new("Folder") courtFolder.Name="Basketball" courtFolder.Parent=Workspace

local court = Instance.new("Part") court.Size=Vector3.new(30,0.5,15) court.Position=Vector3.new(-100,0,100) court.Anchored=true court.Color=Color3.fromRGB(200,150,80) court.Material=Enum.Material.Wood court.Parent=courtFolder

-- Cestas
for _, side in ipairs({-14,14}) do
	local pole = Instance.new("Part") pole.Size=Vector3.new(0.3,5,0.3) pole.Position=Vector3.new(-100,2.5,100+side) pole.Anchored=true pole.Color=Color3.fromRGB(200,200,200) pole.Parent=courtFolder
	local hoop = Instance.new("Part") hoop.Shape=Enum.PartType.Cylinder hoop.Size=Vector3.new(0.2,2,2) hoop.Position=Vector3.new(-100,5,100+side) hoop.Anchored=true hoop.Color=Color3.fromRGB(255,100,0) hoop.Parent=courtFolder
end

-- Bola
local ball = Instance.new("Part") ball.Shape=Enum.PartType.Ball ball.Size=Vector3.new(1.5,1.5,1.5) ball.Position=Vector3.new(-100,2,100) ball.Color=Color3.fromRGB(255,100,0) ball.Parent=courtFolder

local basketScores = {}

shootBasketEvent.OnServerEvent:Connect(function(player)
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	-- Chance de acertar baseada na distância
	local dist = (ball.Position - root.Position).Magnitude
	local chance = math.max(0.1, 1 - dist/20)
	local scored = math.random() < chance

	if scored then
		basketScores[player.UserId] = (basketScores[player.UserId] or 0) + 2
		local addXP = remotes:FindFirstChild("AddXP")
		if addXP then addXP:FireServer(player, 10) end
		print(("[Basquete] %s marcou! Total: %d"):format(player.Name, basketScores[player.UserId]))
	else
		print(("[Basquete] %s errou a cesta"):format(player.Name))
	end
end)
