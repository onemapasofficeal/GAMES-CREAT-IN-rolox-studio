local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local serveTennisEvent = Instance.new("RemoteEvent") serveTennisEvent.Name="ServeTennis" serveTennisEvent.Parent=remotes

local tennisFolder = Instance.new("Folder") tennisFolder.Name="Tennis" tennisFolder.Parent=Workspace

local court = Instance.new("Part") court.Size=Vector3.new(24,0.5,11) court.Position=Vector3.new(100,0,-100) court.Anchored=true court.Color=Color3.fromRGB(50,100,50) court.Material=Enum.Material.SmoothPlastic court.Parent=tennisFolder
local net = Instance.new("Part") net.Size=Vector3.new(0.1,1,11) net.Position=Vector3.new(100,1,-100) net.Anchored=true net.Color=Color3.fromRGB(255,255,255) net.Parent=tennisFolder

local ball = Instance.new("Part") ball.Shape=Enum.PartType.Ball ball.Size=Vector3.new(0.8,0.8,0.8) ball.Position=Vector3.new(100,2,-100) ball.Color=Color3.fromRGB(200,220,50) ball.Parent=tennisFolder

local tennisScores = {}

serveTennisEvent.OnServerEvent:Connect(function(player)
	local scored = math.random() > 0.4
	if scored then
		tennisScores[player.UserId] = (tennisScores[player.UserId] or 0) + 1
		local addXP = remotes:FindFirstChild("AddXP")
		if addXP then addXP:FireServer(player, 8) end
		print(("[Tênis] %s marcou ponto!"):format(player.Name))
	end
end)
