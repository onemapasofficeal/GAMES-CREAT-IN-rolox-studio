local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local serverInfoFn = Instance.new("RemoteFunction") serverInfoFn.Name="GetServerInfo" serverInfoFn.Parent=remotes

local serverStartTime = tick()
local totalMoneyCirculating = 0

serverInfoFn.OnServerInvoke = function()
	local uptime = tick() - serverStartTime
	local hours = math.floor(uptime/3600)
	local mins  = math.floor((uptime%3600)/60)
	local secs  = math.floor(uptime%60)

	local playerCount = #Players:GetPlayers()
	local playerNames = {}
	for _, p in ipairs(Players:GetPlayers()) do
		table.insert(playerNames, p.Name)
	end

	return {
		uptime = ("%02d:%02d:%02d"):format(hours, mins, secs),
		playerCount = playerCount,
		playerNames = playerNames,
		maxPlayers = Players.MaxPlayers,
		serverTime = os.date("%H:%M:%S"),
		version = "1.0.0",
		gameName = "The Game Realist"
	}
end
