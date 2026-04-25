local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local claimDailyEvent = Instance.new("RemoteEvent")    claimDailyEvent.Name = "ClaimDaily"    claimDailyEvent.Parent = remotes
local dailyInfoFn     = Instance.new("RemoteFunction") dailyInfoFn.Name     = "GetDailyInfo"  dailyInfoFn.Parent     = remotes

local DailyRewards = {
	{ day=1,  money=100,  xp=50  },
	{ day=2,  money=150,  xp=75  },
	{ day=3,  money=200,  xp=100 },
	{ day=4,  money=300,  xp=150 },
	{ day=5,  money=500,  xp=200 },
	{ day=6,  money=750,  xp=300 },
	{ day=7,  money=1500, xp=500 },
}

local playerDaily = {}  -- userId → { streak, lastClaim }

Players.PlayerAdded:Connect(function(p)
	playerDaily[p.UserId] = { streak=0, lastClaim=0 }
end)
Players.PlayerRemoving:Connect(function(p) playerDaily[p.UserId]=nil end)

dailyInfoFn.OnServerInvoke = function(player)
	local d = playerDaily[player.UserId]
	local canClaim = (os.time() - d.lastClaim) >= 86400
	local dayIndex = (d.streak % 7) + 1
	return { canClaim=canClaim, streak=d.streak, reward=DailyRewards[dayIndex] }
end

claimDailyEvent.OnServerEvent:Connect(function(player)
	local d = playerDaily[player.UserId]
	if (os.time() - d.lastClaim) < 86400 then
		warn("[Daily] Já coletou hoje")
		return
	end

	-- Verifica se perdeu streak (mais de 48h)
	if (os.time() - d.lastClaim) > 172800 then d.streak = 0 end

	d.streak += 1
	d.lastClaim = os.time()

	local dayIndex = ((d.streak-1) % 7) + 1
	local reward = DailyRewards[dayIndex]

	local addMoney = remotes:FindFirstChild("AddMoney")
	local addXP    = remotes:FindFirstChild("AddXP")
	if addMoney then addMoney:FireServer(player, reward.money) end
	if addXP    then addXP:FireServer(player, reward.xp) end

	print(("[Daily] %s coletou dia %d: R$%d + %dXP"):format(player.Name, d.streak, reward.money, reward.xp))
end)
