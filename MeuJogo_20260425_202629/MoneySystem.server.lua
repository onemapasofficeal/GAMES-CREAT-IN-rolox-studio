-- MoneySystem.server.lua
-- Sistema de dinheiro dos jogadores

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(ReplicatedStorage:WaitForChild("GameConfig"))

-- RemoteEvents
local remotes = Instance.new("Folder")
remotes.Name = "Remotes"
remotes.Parent = ReplicatedStorage

local getMoney   = Instance.new("RemoteFunction")
getMoney.Name    = "GetMoney"
getMoney.Parent  = remotes

local addMoney   = Instance.new("RemoteEvent")
addMoney.Name    = "AddMoney"
addMoney.Parent  = remotes

local removeMoney = Instance.new("RemoteEvent")
removeMoney.Name  = "RemoveMoney"
removeMoney.Parent = remotes

local updateMoneyUI = Instance.new("RemoteEvent")
updateMoneyUI.Name  = "UpdateMoneyUI"
updateMoneyUI.Parent = remotes

-- Tabela local de dinheiro (substitua por DataStore em produção)
local playerMoney = {}

local function getMoneySafe(player)
	return playerMoney[player.UserId] or 0
end

-- Jogador entra
Players.PlayerAdded:Connect(function(player)
	playerMoney[player.UserId] = GameConfig.StartingMoney
	print(("[MoneySystem] %s entrou com %s%d"):format(
		player.Name, GameConfig.MoneyName, GameConfig.StartingMoney))

	-- Aguarda o personagem e envia o saldo inicial para a UI
	player.CharacterAdded:Connect(function()
		task.wait(1)
		updateMoneyUI:FireClient(player, getMoneySafe(player))
	end)
end)

-- Jogador sai
Players.PlayerRemoving:Connect(function(player)
	playerMoney[player.UserId] = nil
end)

-- RemoteFunction: cliente pede o saldo
getMoney.OnServerInvoke = function(player)
	return getMoneySafe(player)
end

-- RemoteEvent: adicionar dinheiro (servidor → servidor ou admin)
addMoney.OnServerEvent:Connect(function(player, amount)
	if type(amount) ~= "number" or amount <= 0 then return end
	playerMoney[player.UserId] = getMoneySafe(player) + amount
	updateMoneyUI:FireClient(player, getMoneySafe(player))
	print(("[MoneySystem] +%d para %s | Total: %d"):format(amount, player.Name, getMoneySafe(player)))
end)

-- RemoteEvent: remover dinheiro
removeMoney.OnServerEvent:Connect(function(player, amount)
	if type(amount) ~= "number" or amount <= 0 then return end
	local atual = getMoneySafe(player)
	if atual < amount then
		warn(("[MoneySystem] %s não tem dinheiro suficiente!"):format(player.Name))
		return
	end
	playerMoney[player.UserId] = atual - amount
	updateMoneyUI:FireClient(player, getMoneySafe(player))
	print(("[MoneySystem] -%d de %s | Total: %d"):format(amount, player.Name, getMoneySafe(player)))
end)

print("[TheGameRealist] Sistema de dinheiro iniciado!")
