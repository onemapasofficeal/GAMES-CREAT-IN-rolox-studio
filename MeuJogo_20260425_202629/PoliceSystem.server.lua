local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local joinPoliceEvent  = Instance.new("RemoteEvent")    joinPoliceEvent.Name  = "JoinPolice"    joinPoliceEvent.Parent  = remotes
local leavePoliceEvent = Instance.new("RemoteEvent")    leavePoliceEvent.Name = "LeavePolice"   leavePoliceEvent.Parent = remotes
local callCopsEvent    = Instance.new("RemoteEvent")    callCopsEvent.Name    = "CallCops"      callCopsEvent.Parent    = remotes
local copAlertEvent    = Instance.new("RemoteEvent")    copAlertEvent.Name    = "CopAlert"      copAlertEvent.Parent    = remotes
local isPoliceF        = Instance.new("RemoteFunction") isPoliceF.Name        = "IsPolice"      isPoliceF.Parent        = remotes

local policePlayers = {}  -- userId → bool

Players.PlayerAdded:Connect(function(p) policePlayers[p.UserId]=false end)
Players.PlayerRemoving:Connect(function(p) policePlayers[p.UserId]=nil end)

isPoliceF.OnServerInvoke = function(player)
	return policePlayers[player.UserId] or false
end

joinPoliceEvent.OnServerEvent:Connect(function(player)
	policePlayers[player.UserId] = true
	-- Equipa com pistola
	local buyGun = remotes:FindFirstChild("BuyGun")
	print(("[Polícia] %s entrou para a polícia"):format(player.Name))
end)

leavePoliceEvent.OnServerEvent:Connect(function(player)
	policePlayers[player.UserId] = false
end)

callCopsEvent.OnServerEvent:Connect(function(player, criminalName, location)
	-- Alerta todos os policiais
	for _, p in ipairs(Players:GetPlayers()) do
		if policePlayers[p.UserId] then
			copAlertEvent:FireClient(p, criminalName, location or "Desconhecido", player.Name)
		end
	end
	print(("[Polícia] %s chamou a polícia para %s"):format(player.Name, criminalName))
end)
