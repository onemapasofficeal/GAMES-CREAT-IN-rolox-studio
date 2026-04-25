local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sendFlirtEvent  = Instance.new("RemoteEvent")    sendFlirtEvent.Name  = "SendFlirt"    sendFlirtEvent.Parent  = remotes
local receiveFlirt    = Instance.new("RemoteEvent")    receiveFlirt.Name    = "ReceiveFlirt" receiveFlirt.Parent    = remotes
local acceptDateEvent = Instance.new("RemoteEvent")    acceptDateEvent.Name = "AcceptDate"   acceptDateEvent.Parent = remotes
local dateUpdate      = Instance.new("RemoteEvent")    dateUpdate.Name      = "DateUpdate"   dateUpdate.Parent      = remotes

local relationships = {}  -- userId → partnerId

Players.PlayerAdded:Connect(function(p) relationships[p.UserId]=nil end)
Players.PlayerRemoving:Connect(function(p)
	local partner = relationships[p.UserId]
	if partner then relationships[partner]=nil end
	relationships[p.UserId]=nil
end)

sendFlirtEvent.OnServerEvent:Connect(function(player, targetName)
	local target = Players:FindFirstChild(targetName)
	if not target then return end
	if target == player then return end
	receiveFlirt:FireClient(target, player.Name)
	print(("[Namoro] %s mandou flerte para %s"):format(player.Name, target.Name))
end)

acceptDateEvent.OnServerEvent:Connect(function(player, targetName)
	local target = Players:FindFirstChild(targetName)
	if not target then return end

	relationships[player.UserId] = target.UserId
	relationships[target.UserId] = player.UserId

	dateUpdate:FireClient(player, target.Name)
	dateUpdate:FireClient(target, player.Name)

	-- Bônus de felicidade
	local addXP = remotes:FindFirstChild("AddXP")
	if addXP then
		addXP:FireServer(player, 20)
		addXP:FireServer(target, 20)
	end
	print(("[Namoro] %s e %s estão namorando!"):format(player.Name, target.Name))
end)
