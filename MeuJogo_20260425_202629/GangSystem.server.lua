local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local createGangEvent = Instance.new("RemoteEvent")    createGangEvent.Name = "CreateGang"   createGangEvent.Parent = remotes
local joinGangEvent   = Instance.new("RemoteEvent")    joinGangEvent.Name   = "JoinGang"     joinGangEvent.Parent   = remotes
local leaveGangEvent  = Instance.new("RemoteEvent")    leaveGangEvent.Name  = "LeaveGang"    leaveGangEvent.Parent  = remotes
local gangListFn      = Instance.new("RemoteFunction") gangListFn.Name      = "GetGangList"  gangListFn.Parent      = remotes
local gangUpdate      = Instance.new("RemoteEvent")    gangUpdate.Name      = "GangUpdate"   gangUpdate.Parent      = remotes

local gangs = {}  -- { name, leader, members, color, bank }
local playerGang = {}  -- userId → gangName

Players.PlayerAdded:Connect(function(p) playerGang[p.UserId]=nil end)
Players.PlayerRemoving:Connect(function(p)
	local gangName = playerGang[p.UserId]
	if gangName then
		for _, g in ipairs(gangs) do
			if g.name == gangName then
				for i, m in ipairs(g.members) do
					if m == p.Name then table.remove(g.members, i) break end
				end
			end
		end
	end
	playerGang[p.UserId] = nil
end)

gangListFn.OnServerInvoke = function() return gangs end

createGangEvent.OnServerEvent:Connect(function(player, gangName, color)
	if playerGang[player.UserId] then warn("[Gang] Já está em uma gang") return end
	if #gangName < 3 or #gangName > 20 then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, 1000) end

	local gang = { name=gangName, leader=player.Name, members={player.Name}, color=color or Color3.fromRGB(200,50,50), bank=0 }
	table.insert(gangs, gang)
	playerGang[player.UserId] = gangName

	for _, p in ipairs(Players:GetPlayers()) do gangUpdate:FireClient(p, gangs) end
	print(("[Gang] %s criou a gang %s"):format(player.Name, gangName))
end)

joinGangEvent.OnServerEvent:Connect(function(player, gangName)
	if playerGang[player.UserId] then return end
	for _, g in ipairs(gangs) do
		if g.name == gangName then
			table.insert(g.members, player.Name)
			playerGang[player.UserId] = gangName
			for _, p in ipairs(Players:GetPlayers()) do gangUpdate:FireClient(p, gangs) end
			print(("[Gang] %s entrou na gang %s"):format(player.Name, gangName))
			return
		end
	end
end)

leaveGangEvent.OnServerEvent:Connect(function(player)
	local gangName = playerGang[player.UserId]
	if not gangName then return end
	for _, g in ipairs(gangs) do
		if g.name == gangName then
			for i, m in ipairs(g.members) do
				if m == player.Name then table.remove(g.members, i) break end
			end
		end
	end
	playerGang[player.UserId] = nil
	for _, p in ipairs(Players:GetPlayers()) do gangUpdate:FireClient(p, gangs) end
end)
