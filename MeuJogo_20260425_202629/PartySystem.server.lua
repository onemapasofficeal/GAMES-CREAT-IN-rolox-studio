local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local createPartyEvent = Instance.new("RemoteEvent")    createPartyEvent.Name = "CreateParty"   createPartyEvent.Parent = remotes
local invitePartyEvent = Instance.new("RemoteEvent")    invitePartyEvent.Name = "InviteParty"   invitePartyEvent.Parent = remotes
local joinPartyEvent   = Instance.new("RemoteEvent")    joinPartyEvent.Name   = "JoinParty"     joinPartyEvent.Parent   = remotes
local leavePartyEvent  = Instance.new("RemoteEvent")    leavePartyEvent.Name  = "LeaveParty"    leavePartyEvent.Parent  = remotes
local partyListFn      = Instance.new("RemoteFunction") partyListFn.Name      = "GetPartyInfo"  partyListFn.Parent      = remotes
local partyUpdate      = Instance.new("RemoteEvent")    partyUpdate.Name      = "PartyUpdate"   partyUpdate.Parent      = remotes
local partyInvite      = Instance.new("RemoteEvent")    partyInvite.Name      = "PartyInvite"   partyInvite.Parent      = remotes

local parties = {}  -- partyId → { leader, members, maxSize }
local playerParty = {}  -- userId → partyId
local nextPartyId = 1

Players.PlayerAdded:Connect(function(p) playerParty[p.UserId]=nil end)
Players.PlayerRemoving:Connect(function(p)
	local partyId = playerParty[p.UserId]
	if partyId and parties[partyId] then
		for i, m in ipairs(parties[partyId].members) do
			if m == p.Name then table.remove(parties[partyId].members, i) break end
		end
		if #parties[partyId].members == 0 then parties[partyId]=nil end
	end
	playerParty[p.UserId]=nil
end)

partyListFn.OnServerInvoke = function(player)
	local partyId = playerParty[player.UserId]
	return partyId and parties[partyId] or nil
end

createPartyEvent.OnServerEvent:Connect(function(player)
	if playerParty[player.UserId] then return end
	local id = nextPartyId
	nextPartyId += 1
	parties[id] = { id=id, leader=player.Name, members={player.Name}, maxSize=6 }
	playerParty[player.UserId] = id
	partyUpdate:FireClient(player, parties[id])
	print(("[Party] %s criou party %d"):format(player.Name, id))
end)

invitePartyEvent.OnServerEvent:Connect(function(player, targetName)
	local partyId = playerParty[player.UserId]
	if not partyId then return end
	local target = Players:FindFirstChild(targetName)
	if not target then return end
	partyInvite:FireClient(target, player.Name, partyId)
end)

joinPartyEvent.OnServerEvent:Connect(function(player, partyId)
	local party = parties[partyId]
	if not party then return end
	if #party.members >= party.maxSize then return end
	if playerParty[player.UserId] then return end

	table.insert(party.members, player.Name)
	playerParty[player.UserId] = partyId

	for _, memberName in ipairs(party.members) do
		local p = Players:FindFirstChild(memberName)
		if p then partyUpdate:FireClient(p, party) end
	end
end)

leavePartyEvent.OnServerEvent:Connect(function(player)
	local partyId = playerParty[player.UserId]
	if not partyId then return end
	local party = parties[partyId]
	if party then
		for i, m in ipairs(party.members) do
			if m == player.Name then table.remove(party.members, i) break end
		end
	end
	playerParty[player.UserId] = nil
end)
