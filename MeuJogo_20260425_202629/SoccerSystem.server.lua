local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local joinSoccerEvent = Instance.new("RemoteEvent") joinSoccerEvent.Name="JoinSoccer" joinSoccerEvent.Parent=remotes
local kickBallEvent   = Instance.new("RemoteEvent") kickBallEvent.Name="KickBall"   kickBallEvent.Parent=remotes
local goalEvent       = Instance.new("RemoteEvent") goalEvent.Name="Goal"           goalEvent.Parent=remotes

-- Cria campo de futebol
local soccerFolder = Instance.new("Folder") soccerFolder.Name="Soccer" soccerFolder.Parent=Workspace

local field = Instance.new("Part") field.Size=Vector3.new(80,0.5,50) field.Position=Vector3.new(-100,0,-100) field.Anchored=true field.Color=Color3.fromRGB(50,150,50) field.Material=Enum.Material.Grass field.Parent=soccerFolder

-- Traves
for _, side in ipairs({-40,40}) do
	local post1 = Instance.new("Part") post1.Size=Vector3.new(0.5,4,0.5) post1.Position=Vector3.new(-100+side,2,-108) post1.Anchored=true post1.Color=Color3.fromRGB(255,255,255) post1.Parent=soccerFolder
	local post2 = Instance.new("Part") post2.Size=Vector3.new(0.5,4,0.5) post2.Position=Vector3.new(-100+side,2,-92) post2.Anchored=true post2.Color=Color3.fromRGB(255,255,255) post2.Parent=soccerFolder
	local crossbar = Instance.new("Part") crossbar.Size=Vector3.new(0.5,0.5,16) crossbar.Position=Vector3.new(-100+side,4,-100) crossbar.Anchored=true crossbar.Color=Color3.fromRGB(255,255,255) crossbar.Parent=soccerFolder
end

-- Bola
local ball = Instance.new("Part") ball.Shape=Enum.PartType.Ball ball.Size=Vector3.new(2,2,2) ball.Position=Vector3.new(-100,2,-100) ball.Color=Color3.fromRGB(255,255,255) ball.Material=Enum.Material.SmoothPlastic ball.Parent=soccerFolder

local soccerPlayers = {}
local scores = {team1=0, team2=0}

joinSoccerEvent.OnServerEvent:Connect(function(player, team)
	soccerPlayers[player.UserId] = team
	print(("[Futebol] %s entrou no time %d"):format(player.Name, team))
end)

kickBallEvent.OnServerEvent:Connect(function(player, direction)
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	if (ball.Position - root.Position).Magnitude < 5 then
		ball.Velocity = direction * 50
	end
end)

goalEvent.OnServerEvent:Connect(function(player, team)
	scores["team"..team] = (scores["team"..team] or 0) + 1
	local addXP = remotes:FindFirstChild("AddXP")
	if addXP then addXP:FireServer(player, 30) end
	print(("[Futebol] GOL! Time %d marcou! Placar: %d x %d"):format(team, scores.team1, scores.team2))
end)
