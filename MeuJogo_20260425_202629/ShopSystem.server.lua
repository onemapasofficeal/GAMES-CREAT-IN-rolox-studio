-- ShopSystem.server.lua
-- Loja: comprar comida, bebida, itens

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buyEvent   = Instance.new("RemoteEvent")    buyEvent.Name   = "BuyItem"    buyEvent.Parent   = remotes
local shopListFn = Instance.new("RemoteFunction") shopListFn.Name = "GetShopList" shopListFn.Parent = remotes

local Shop = {
	{ id = 1, name = "Pão",          price = 10,  type = "food",  value = 25 },
	{ id = 2, name = "Arroz e Feijão",price = 25, type = "food",  value = 60 },
	{ id = 3, name = "Água",          price = 5,  type = "drink", value = 30 },
	{ id = 4, name = "Suco",          price = 15, type = "drink", value = 50 },
	{ id = 5, name = "Remédio",       price = 50, type = "heal",  value = 50 },
	{ id = 6, name = "Kit Médico",    price = 150,type = "heal",  value = 100 },
	{ id = 7, name = "Fone de Ouvido",price = 200,type = "item",  value = 0  },
	{ id = 8, name = "Mochila",       price = 300,type = "item",  value = 0  },
}

shopListFn.OnServerInvoke = function()
	return Shop
end

buyEvent.OnServerEvent:Connect(function(player, itemId)
	local item = nil
	for _, v in ipairs(Shop) do
		if v.id == itemId then item = v break end
	end
	if not item then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, item.price) end

	if item.type == "food" then
		local eat = remotes:FindFirstChild("Eat")
		if eat then eat:FireServer(player, item.value) end
	elseif item.type == "drink" then
		local drink = remotes:FindFirstChild("Drink")
		if drink then drink:FireServer(player, item.value) end
	elseif item.type == "heal" then
		local char = player.Character
		if char then
			local hum = char:FindFirstChild("Humanoid")
			if hum then hum.Health = math.min(hum.MaxHealth, hum.Health + item.value) end
		end
	end

	print(("[Loja] %s comprou %s por R$%d"):format(player.Name, item.name, item.price))
end)
