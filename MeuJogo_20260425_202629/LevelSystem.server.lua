-- LevelSystem.server.lua
-- XP e níveis do jogador

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local addXPEvent   = Instance.new("RemoteEvent")    addXPEvent.Name   = "AddXP"      addXPEvent.Parent   = remotes
local levelUpdate  = Instance.new("RemoteEvent")    levelUpdate.Name  = "LevelUpdate" levelUpdate.Parent  = remotes
local getLevelFn   = Instance.new("RemoteFunction") getLevelFn.Name   = "GetLevel"   getLevelFn.Parent   = remotes

local playerLevels = {}  -- userId → { level, xp }

local function xpParaProximoNivel(level)
	return level * 100
end

local function checkLevelUp(player)
	local data = playerLevels[player.UserId]
	while data.xp >= xpParaProximoNivel(data.level) do
		data.xp -= xpParaProximoNivel(data.level)
		data.level += 1
		print(("[Level] %s subiu para nível %d!"):format(player.Name, data.level))
	end
	levelUpdate:FireClient(player, data.level, data.xp, xpParaProximoNivel(data.level))
end

Players.PlayerAdded:Connect(function(p)
	playerLevels[p.UserId] = { level = 1, xp = 0 }
	p.CharacterAdded:Connect(function()
		task.wait(1)
		local d = playerLevels[p.UserId]
		levelUpdate:FireClient(p, d.level, d.xp, xpParaProximoNivel(d.level))
	end)
end)

Players.PlayerRemoving:Connect(function(p) playerLevels[p.UserId] = nil end)

getLevelFn.OnServerInvoke = function(player)
	return playerLevels[player.UserId]
end

addXPEvent.OnServerEvent:Connect(function(player, amount)
	if type(amount) ~= "number" or amount <= 0 then return end
	playerLevels[player.UserId].xp += amount
	checkLevelUp(player)
end)
