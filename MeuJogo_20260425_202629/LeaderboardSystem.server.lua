local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local getLeaderboardFn = Instance.new("RemoteFunction") getLeaderboardFn.Name="GetLeaderboard" getLeaderboardFn.Parent=remotes
local leaderboardUpdate= Instance.new("RemoteEvent")    leaderboardUpdate.Name="LeaderboardUpdate" leaderboardUpdate.Parent=remotes

-- Roblox leaderboard stats
Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local money = Instance.new("IntValue")
	money.Name = "Dinheiro"
	money.Value = 500
	money.Parent = leaderstats

	local level = Instance.new("IntValue")
	level.Name = "Nível"
	level.Value = 1
	level.Parent = leaderstats

	local playtime = Instance.new("IntValue")
	playtime.Name = "Tempo"
	playtime.Value = 0
	playtime.Parent = leaderstats

	-- Conta tempo de jogo
	task.spawn(function()
		while player.Parent do
			task.wait(60)
			playtime.Value += 1
		end
	end)
end)

getLeaderboardFn.OnServerInvoke = function()
	local data = {}
	for _, p in ipairs(Players:GetPlayers()) do
		local ls = p:FindFirstChild("leaderstats")
		if ls then
			table.insert(data, {
				name   = p.Name,
				money  = ls:FindFirstChild("Dinheiro") and ls.Dinheiro.Value or 0,
				level  = ls:FindFirstChild("Nível")    and ls["Nível"].Value or 1,
			})
		end
	end
	table.sort(data, function(a,b) return a.money > b.money end)
	return data
end

-- Atualiza leaderboard a cada 30s
task.spawn(function()
	while true do
		task.wait(30)
		local data = {}
		for _, p in ipairs(Players:GetPlayers()) do
			local ls = p:FindFirstChild("leaderstats")
			if ls then
				table.insert(data, { name=p.Name, money=ls.Dinheiro and ls.Dinheiro.Value or 0 })
			end
		end
		for _, p in ipairs(Players:GetPlayers()) do
			leaderboardUpdate:FireClient(p, data)
		end
	end
end)
