local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local getStatsFn = Instance.new("RemoteFunction") getStatsFn.Name="GetPlayerStats" getStatsFn.Parent=remotes

local playerStats = {}

Players.PlayerAdded:Connect(function(p)
	playerStats[p.UserId] = {
		kills = 0, deaths = 0, moneyEarned = 0, moneySpent = 0,
		fishCaught = 0, cropsHarvested = 0, oresMined = 0,
		distanceTraveled = 0, timePlayed = 0, jobsDone = 0,
		crimesCommitted = 0, arrestsMade = 0, itemsCrafted = 0,
	}

	-- Conta tempo jogado
	task.spawn(function()
		while playerStats[p.UserId] do
			task.wait(60)
			if playerStats[p.UserId] then
				playerStats[p.UserId].timePlayed += 1
			end
		end
	end)
end)
Players.PlayerRemoving:Connect(function(p) playerStats[p.UserId]=nil end)

getStatsFn.OnServerInvoke = function(player)
	return playerStats[player.UserId] or {}
end

_G.AddStat = function(player, stat, amount)
	if playerStats[player.UserId] and playerStats[player.UserId][stat] ~= nil then
		playerStats[player.UserId][stat] += (amount or 1)
	end
end
