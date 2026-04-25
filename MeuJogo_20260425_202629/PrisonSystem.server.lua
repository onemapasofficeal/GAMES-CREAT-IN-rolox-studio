local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local escapeEvent   = Instance.new("RemoteEvent")    escapeEvent.Name   = "EscapePrison"  escapeEvent.Parent   = remotes
local prisonInfoFn  = Instance.new("RemoteFunction") prisonInfoFn.Name  = "GetPrisonInfo" prisonInfoFn.Parent  = remotes
local prisonUpdate  = Instance.new("RemoteEvent")    prisonUpdate.Name  = "PrisonUpdate"  prisonUpdate.Parent  = remotes

-- Cria prisão
local prisonFolder = Instance.new("Folder") prisonFolder.Name="Prison" prisonFolder.Parent=Workspace

local prisonBase = Instance.new("Part") prisonBase.Size=Vector3.new(40,0.5,40) prisonBase.Position=Vector3.new(200,0,200) prisonBase.Anchored=true prisonBase.Color=Color3.fromRGB(100,100,100) prisonBase.Material=Enum.Material.Concrete prisonBase.Parent=prisonFolder

-- Paredes
for _, offset in ipairs({Vector3.new(20,5,0),Vector3.new(-20,5,0),Vector3.new(0,5,20),Vector3.new(0,5,-20)}) do
	local wall = Instance.new("Part") wall.Size=offset.X~=0 and Vector3.new(1,10,40) or Vector3.new(40,10,1) wall.Position=Vector3.new(200,5,200)+offset wall.Anchored=true wall.Color=Color3.fromRGB(80,80,80) wall.Material=Enum.Material.Concrete wall.Parent=prisonFolder
end

local prisonData = {}  -- userId → { timeLeft, sentence }

Players.PlayerAdded:Connect(function(p) prisonData[p.UserId]=nil end)
Players.PlayerRemoving:Connect(function(p) prisonData[p.UserId]=nil end)

prisonInfoFn.OnServerInvoke = function(player)
	return prisonData[player.UserId]
end

_G.SendToJail = function(player, sentence)
	prisonData[player.UserId] = { timeLeft=sentence, sentence=sentence }
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(200, 5, 200)
	end
	prisonUpdate:FireClient(player, sentence)

	task.spawn(function()
		while prisonData[player.UserId] and prisonData[player.UserId].timeLeft > 0 do
			task.wait(1)
			if prisonData[player.UserId] then
				prisonData[player.UserId].timeLeft -= 1
				prisonUpdate:FireClient(player, prisonData[player.UserId].timeLeft)
			end
		end
		if prisonData[player.UserId] then
			prisonData[player.UserId] = nil
			local c = player.Character
			if c and c:FindFirstChild("HumanoidRootPart") then
				c.HumanoidRootPart.CFrame = CFrame.new(0, 5, 0)
			end
			print(("[Prisão] %s foi solto"):format(player.Name))
		end
	end)
end

escapeEvent.OnServerEvent:Connect(function(player)
	if not prisonData[player.UserId] then return end
	local chance = 0.2
	if math.random() < chance then
		prisonData[player.UserId] = nil
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(0, 5, 0)
		end
		print(("[Prisão] %s escapou da prisão!"):format(player.Name))
	else
		-- Adiciona tempo
		prisonData[player.UserId].timeLeft += 30
		print(("[Prisão] %s tentou escapar e falhou"):format(player.Name))
	end
end)
