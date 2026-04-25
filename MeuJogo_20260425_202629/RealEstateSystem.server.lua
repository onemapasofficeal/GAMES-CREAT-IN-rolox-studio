-- Imóveis para alugar e gerar renda passiva
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buyPropertyEvent = Instance.new("RemoteEvent")    buyPropertyEvent.Name = "BuyProperty"   buyPropertyEvent.Parent = remotes
local rentOutEvent     = Instance.new("RemoteEvent")    rentOutEvent.Name     = "RentOut"        rentOutEvent.Parent     = remotes
local propertyListFn   = Instance.new("RemoteFunction") propertyListFn.Name   = "GetProperties"  propertyListFn.Parent   = remotes

local Properties = {
	{ id=1, name="Apartamento 101", price=20000,  rent=500,  rentInterval=120 },
	{ id=2, name="Loja Comercial",  price=50000,  rent=1500, rentInterval=180 },
	{ id=3, name="Galpão",          price=80000,  rent=2500, rentInterval=240 },
	{ id=4, name="Hotel",           price=200000, rent=8000, rentInterval=300 },
	{ id=5, name="Shopping",        price=500000, rent=20000,rentInterval=600 },
}

local playerProperties = {}  -- userId → { propId → { owned, renting } }

Players.PlayerAdded:Connect(function(p) playerProperties[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p) playerProperties[p.UserId]=nil end)

propertyListFn.OnServerInvoke = function(player)
	return Properties, playerProperties[player.UserId] or {}
end

buyPropertyEvent.OnServerEvent:Connect(function(player, propId)
	local prop = nil
	for _, p in ipairs(Properties) do if p.id==propId then prop=p break end end
	if not prop then return end
	if playerProperties[player.UserId][propId] then return end
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, prop.price) end
	playerProperties[player.UserId][propId] = { owned=true, renting=false }
	print(("[Imóvel] %s comprou %s"):format(player.Name, prop.name))
end)

rentOutEvent.OnServerEvent:Connect(function(player, propId)
	local data = playerProperties[player.UserId][propId]
	if not data or not data.owned or data.renting then return end
	data.renting = true
	local prop = nil
	for _, p in ipairs(Properties) do if p.id==propId then prop=p break end end
	if not prop then return end

	task.spawn(function()
		while data.renting and playerProperties[player.UserId] do
			task.wait(prop.rentInterval)
			if not data.renting then break end
			local addMoney = remotes:FindFirstChild("AddMoney")
			if addMoney then addMoney:FireServer(player, prop.rent) end
			print(("[Imóvel] %s recebeu aluguel R$%d de %s"):format(player.Name, prop.rent, prop.name))
		end
	end)
end)
