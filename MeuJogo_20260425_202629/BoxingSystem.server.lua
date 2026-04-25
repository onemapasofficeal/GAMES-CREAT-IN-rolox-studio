local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local punchEvent    = Instance.new("RemoteEvent")    punchEvent.Name    = "Punch"         punchEvent.Parent    = remotes
local joinBoxEvent  = Instance.new("RemoteEvent")    joinBoxEvent.Name  = "JoinBoxing"    joinBoxEvent.Parent  = remotes
local boxResultEvent= Instance.new("RemoteEvent")    boxResultEvent.Name= "BoxingResult"  boxResultEvent.Parent= remotes

local boxingFolder = Instance.new("Folder") boxingFolder.Name="Boxing" boxingFolder.Parent=Workspace

local ring = Instance.new("Part") ring.Size=Vector3.new(12,0.5,12) ring.Position=Vector3.new(-100,0,0) ring.Anchored=true ring.Color=Color3.fromRGB(200,200,200) ring.Material=Enum.Material.SmoothPlastic ring.Parent=boxingFolder

-- Cordas
for _, offset in ipairs({Vector3.new(6,1,0),Vector3.new(-6,1,0),Vector3.new(0,1,6),Vector3.new(0,1,-6)}) do
	local rope = Instance.new("Part") rope.Size=offset.X~=0 and Vector3.new(0.2,0.2,12) or Vector3.new(12,0.2,0.2) rope.Position=Vector3.new(-100,1,0)+offset rope.Anchored=true rope.Color=Color3.fromRGB(255,50,50) rope.Parent=boxingFolder
end

local boxingMatches = {}  -- matchId → {p1, p2, hp1, hp2}

joinBoxEvent.OnServerEvent:Connect(function(player)
	-- Procura oponente esperando
	for matchId, match in pairs(boxingMatches) do
		if not match.p2 then
			match.p2 = player
			match.hp2 = 100
			print(("[Boxe] Match: %s vs %s"):format(match.p1.Name, player.Name))
			return
		end
	end
	-- Cria novo match
	local id = tostring(tick())
	boxingMatches[id] = { p1=player, p2=nil, hp1=100, hp2=nil }
end)

punchEvent.OnServerEvent:Connect(function(player, targetName)
	local target = Players:FindFirstChild(targetName)
	if not target then return end

	local damage = math.random(10, 25)
	local char = target.Character
	if char then
		local hum = char:FindFirstChild("Humanoid")
		if hum then hum.Health = math.max(0, hum.Health - damage) end
	end

	local addXP = remotes:FindFirstChild("AddXP")
	if addXP then addXP:FireServer(player, 5) end
	print(("[Boxe] %s acertou %s por %d dano"):format(player.Name, targetName, damage))
end)
