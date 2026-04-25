-- Salva memórias/histórico de ações do jogador
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local getMemoriesFn = Instance.new("RemoteFunction") getMemoriesFn.Name="GetMemories" getMemoriesFn.Parent=remotes

local playerMemories = {}  -- userId → list of { action, time }
local MAX_MEMORIES = 100

Players.PlayerAdded:Connect(function(p) playerMemories[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p) playerMemories[p.UserId]=nil end)

getMemoriesFn.OnServerInvoke = function(player)
	return playerMemories[player.UserId] or {}
end

_G.AddMemory = function(player, action)
	if not playerMemories[player.UserId] then return end
	table.insert(playerMemories[player.UserId], 1, {
		action = action,
		time = os.date("%H:%M:%S")
	})
	if #playerMemories[player.UserId] > MAX_MEMORIES then
		table.remove(playerMemories[player.UserId])
	end
end
