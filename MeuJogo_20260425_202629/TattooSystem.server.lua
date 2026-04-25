local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local tattooEvent  = Instance.new("RemoteEvent")    tattooEvent.Name  = "GetTattoo"    tattooEvent.Parent  = remotes
local tattooListFn = Instance.new("RemoteFunction") tattooListFn.Name = "GetTattooList" tattooListFn.Parent = remotes

local Tattoos = {
	{ id=1, name="Dragão",    price=300 },
	{ id=2, name="Caveira",   price=200 },
	{ id=3, name="Flor",      price=150 },
	{ id=4, name="Tribal",    price=250 },
	{ id=5, name="Âncora",    price=180 },
	{ id=6, name="Leão",      price=400 },
}

local playerTattoos = {}

Players.PlayerAdded:Connect(function(p) playerTattoos[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p) playerTattoos[p.UserId]=nil end)

tattooListFn.OnServerInvoke = function(player)
	return Tattoos, playerTattoos[player.UserId] or {}
end

tattooEvent.OnServerEvent:Connect(function(player, tattooId)
	local tattoo = nil
	for _, t in ipairs(Tattoos) do if t.id==tattooId then tattoo=t break end end
	if not tattoo then return end
	if playerTattoos[player.UserId][tattooId] then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, tattoo.price) end
	playerTattoos[player.UserId][tattooId] = true
	print(("[Tatuagem] %s fez tatuagem %s"):format(player.Name, tattoo.name))
end)
