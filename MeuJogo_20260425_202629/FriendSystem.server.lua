local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local addFriendEvent    = Instance.new("RemoteEvent")    addFriendEvent.Name    = "AddFriend"     addFriendEvent.Parent    = remotes
local removeFriendEvent = Instance.new("RemoteEvent")    removeFriendEvent.Name = "RemoveFriend"  removeFriendEvent.Parent = remotes
local friendListFn      = Instance.new("RemoteFunction") friendListFn.Name      = "GetFriendList" friendListFn.Parent      = remotes
local friendRequest     = Instance.new("RemoteEvent")    friendRequest.Name     = "FriendRequest" friendRequest.Parent     = remotes
local friendUpdate      = Instance.new("RemoteEvent")    friendUpdate.Name      = "FriendUpdate"  friendUpdate.Parent      = remotes

local friendLists = {}  -- userId → set of friend userIds
local pendingRequests = {}  -- userId → list of requester userIds

Players.PlayerAdded:Connect(function(p)
	friendLists[p.UserId] = {}
	pendingRequests[p.UserId] = {}
end)
Players.PlayerRemoving:Connect(function(p)
	friendLists[p.UserId] = nil
	pendingRequests[p.UserId] = nil
end)

friendListFn.OnServerInvoke = function(player)
	local friends = {}
	for userId, _ in pairs(friendLists[player.UserId] or {}) do
		local p = Players:GetPlayerByUserId(userId)
		if p then table.insert(friends, { name=p.Name, userId=userId, online=true }) end
	end
	return friends, pendingRequests[player.UserId] or {}
end

addFriendEvent.OnServerEvent:Connect(function(player, targetName)
	local target = Players:FindFirstChild(targetName)
	if not target then return end
	if target == player then return end

	-- Envia pedido
	table.insert(pendingRequests[target.UserId], { name=player.Name, userId=player.UserId })
	friendRequest:FireClient(target, player.Name)
	print(("[Amigos] %s enviou pedido para %s"):format(player.Name, target.Name))
end)

removeFriendEvent.OnServerEvent:Connect(function(player, targetUserId)
	friendLists[player.UserId][targetUserId] = nil
	if friendLists[targetUserId] then
		friendLists[targetUserId][player.UserId] = nil
	end
	friendUpdate:FireClient(player, friendLists[player.UserId])
end)

-- Aceitar pedido (via evento de amizade)
local acceptFriendEvent = Instance.new("RemoteEvent") acceptFriendEvent.Name="AcceptFriend" acceptFriendEvent.Parent=remotes
acceptFriendEvent.OnServerEvent:Connect(function(player, requesterUserId)
	friendLists[player.UserId][requesterUserId] = true
	if friendLists[requesterUserId] then
		friendLists[requesterUserId][player.UserId] = true
	end
	-- Remove da lista de pendentes
	for i, req in ipairs(pendingRequests[player.UserId]) do
		if req.userId == requesterUserId then table.remove(pendingRequests[player.UserId], i) break end
	end
	friendUpdate:FireClient(player, friendLists[player.UserId])
	local requester = Players:GetPlayerByUserId(requesterUserId)
	if requester then friendUpdate:FireClient(requester, friendLists[requesterUserId]) end
	print(("[Amigos] %s aceitou pedido"):format(player.Name))
end)
