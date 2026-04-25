-- InventorySystem.server.lua
-- Inventário do jogador

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local addItemEvent    = Instance.new("RemoteEvent")    addItemEvent.Name    = "AddItem"       addItemEvent.Parent    = remotes
local removeItemEvent = Instance.new("RemoteEvent")    removeItemEvent.Name = "RemoveItem"    removeItemEvent.Parent = remotes
local getInvFn        = Instance.new("RemoteFunction") getInvFn.Name        = "GetInventory"  getInvFn.Parent        = remotes
local invUpdate       = Instance.new("RemoteEvent")    invUpdate.Name       = "InventoryUpdate" invUpdate.Parent     = remotes

local MAX_SLOTS = 20
local inventories = {}  -- userId → { {name, qty} }

Players.PlayerAdded:Connect(function(p)
	inventories[p.UserId] = {}
end)
Players.PlayerRemoving:Connect(function(p) inventories[p.UserId] = nil end)

getInvFn.OnServerInvoke = function(player)
	return inventories[player.UserId] or {}
end

local function findItem(inv, name)
	for i, slot in ipairs(inv) do
		if slot.name == name then return i, slot end
	end
	return nil
end

addItemEvent.OnServerEvent:Connect(function(player, itemName, qty)
	qty = qty or 1
	local inv = inventories[player.UserId]
	if #inv >= MAX_SLOTS then
		warn("[Inventário] " .. player.Name .. " sem espaço!")
		return
	end
	local i, slot = findItem(inv, itemName)
	if slot then
		slot.qty += qty
	else
		table.insert(inv, { name = itemName, qty = qty })
	end
	invUpdate:FireClient(player, inv)
end)

removeItemEvent.OnServerEvent:Connect(function(player, itemName, qty)
	qty = qty or 1
	local inv = inventories[player.UserId]
	local i, slot = findItem(inv, itemName)
	if not slot then return end
	slot.qty -= qty
	if slot.qty <= 0 then table.remove(inv, i) end
	invUpdate:FireClient(player, inv)
end)
