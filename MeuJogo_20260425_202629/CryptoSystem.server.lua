local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local mineCryptoEvent = Instance.new("RemoteEvent")    mineCryptoEvent.Name = "MineCrypto"   mineCryptoEvent.Parent = remotes
local buyCryptoEvent  = Instance.new("RemoteEvent")    buyCryptoEvent.Name  = "BuyCrypto"    buyCryptoEvent.Parent  = remotes
local sellCryptoEvent = Instance.new("RemoteEvent")    sellCryptoEvent.Name = "SellCrypto"   sellCryptoEvent.Parent = remotes
local cryptoListFn    = Instance.new("RemoteFunction") cryptoListFn.Name    = "GetCryptoList" cryptoListFn.Parent   = remotes
local cryptoUpdate    = Instance.new("RemoteEvent")    cryptoUpdate.Name    = "CryptoUpdate"  cryptoUpdate.Parent   = remotes

local Cryptos = {
	{ id=1, name="RobloxCoin",  price=100,  change=0, mineTime=30  },
	{ id=2, name="GameToken",   price=500,  change=0, mineTime=60  },
	{ id=3, name="MetaCoin",    price=2000, change=0, mineTime=120 },
	{ id=4, name="UltraCoin",   price=10000,change=0, mineTime=300 },
}

local playerCrypto = {}
local miningCooldown = {}

Players.PlayerAdded:Connect(function(p) playerCrypto[p.UserId]={} miningCooldown[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p) playerCrypto[p.UserId]=nil miningCooldown[p.UserId]=nil end)

-- Flutuação de preços
task.spawn(function()
	while true do
		task.wait(45)
		for _, c in ipairs(Cryptos) do
			local change = math.random(-30, 30)
			c.price = math.max(10, c.price + change)
			c.change = change
		end
		for _, p in ipairs(Players:GetPlayers()) do
			cryptoUpdate:FireClient(p, Cryptos)
		end
	end
end)

cryptoListFn.OnServerInvoke = function(player)
	return Cryptos, playerCrypto[player.UserId] or {}
end

mineCryptoEvent.OnServerEvent:Connect(function(player, cryptoId)
	local crypto = nil
	for _, c in ipairs(Cryptos) do if c.id==cryptoId then crypto=c break end end
	if not crypto then return end

	local now = tick()
	if miningCooldown[player.UserId][cryptoId] and now - miningCooldown[player.UserId][cryptoId] < crypto.mineTime then return end
	miningCooldown[player.UserId][cryptoId] = now

	playerCrypto[player.UserId][cryptoId] = (playerCrypto[player.UserId][cryptoId] or 0) + 1
	print(("[Crypto] %s minerou 1x %s"):format(player.Name, crypto.name))
end)

buyCryptoEvent.OnServerEvent:Connect(function(player, cryptoId, qty)
	local crypto = nil
	for _, c in ipairs(Cryptos) do if c.id==cryptoId then crypto=c break end end
	if not crypto then return end
	local total = crypto.price * qty
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, total) end
	playerCrypto[player.UserId][cryptoId] = (playerCrypto[player.UserId][cryptoId] or 0) + qty
end)

sellCryptoEvent.OnServerEvent:Connect(function(player, cryptoId, qty)
	local crypto = nil
	for _, c in ipairs(Cryptos) do if c.id==cryptoId then crypto=c break end end
	if not crypto then return end
	local owned = playerCrypto[player.UserId][cryptoId] or 0
	qty = math.min(qty, owned)
	if qty <= 0 then return end
	playerCrypto[player.UserId][cryptoId] = owned - qty
	local total = crypto.price * qty
	local addMoney = remotes:FindFirstChild("AddMoney")
	if addMoney then addMoney:FireServer(player, total) end
	print(("[Crypto] %s vendeu %dx %s por R$%d"):format(player.Name, qty, crypto.name, total))
end)
