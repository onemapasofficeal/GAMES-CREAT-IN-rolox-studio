local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local haveBabyEvent = Instance.new("RemoteEvent")    haveBabyEvent.Name = "HaveBaby"    haveBabyEvent.Parent = remotes
local feedBabyEvent = Instance.new("RemoteEvent")    feedBabyEvent.Name = "FeedBaby"    feedBabyEvent.Parent = remotes
local babyInfoFn    = Instance.new("RemoteFunction") babyInfoFn.Name    = "GetBabyInfo" babyInfoFn.Parent    = remotes
local babyUpdate    = Instance.new("RemoteEvent")    babyUpdate.Name    = "BabyUpdate"  babyUpdate.Parent    = remotes

local playerBabies = {}  -- userId → { name, hunger, age }

Players.PlayerAdded:Connect(function(p) playerBabies[p.UserId]=nil end)
Players.PlayerRemoving:Connect(function(p) playerBabies[p.UserId]=nil end)

babyInfoFn.OnServerInvoke = function(player)
	return playerBabies[player.UserId]
end

haveBabyEvent.OnServerEvent:Connect(function(player, babyName)
	if playerBabies[player.UserId] then warn("[Bebê] Já tem bebê") return end
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, 2000) end

	playerBabies[player.UserId] = { name=babyName or "Bebê", hunger=100, age=0 }
	babyUpdate:FireClient(player, playerBabies[player.UserId])

	-- Bebê cresce com o tempo
	task.spawn(function()
		while playerBabies[player.UserId] do
			task.wait(60)
			local baby = playerBabies[player.UserId]
			if not baby then break end
			baby.age += 1
			baby.hunger = math.max(0, baby.hunger - 10)
			babyUpdate:FireClient(player, baby)
			if baby.hunger == 0 then
				print(("[Bebê] %s do %s está com fome!"):format(baby.name, player.Name))
			end
		end
	end)
	print(("[Bebê] %s teve um bebê: %s"):format(player.Name, babyName))
end)

feedBabyEvent.OnServerEvent:Connect(function(player)
	local baby = playerBabies[player.UserId]
	if not baby then return end
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, 20) end
	baby.hunger = math.min(100, baby.hunger + 40)
	babyUpdate:FireClient(player, baby)
end)
