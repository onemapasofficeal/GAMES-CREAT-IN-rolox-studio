-- Mercado entre jogadores: listar, comprar, vender itens
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local listItemEvent   = Instance.new("RemoteEvent")    listItemEvent.Name   = "MarketList"    listItemEvent.Parent   = remotes
local buyMarketEvent  = Instance.new("RemoteEvent")    buyMarketEvent.Name  = "MarketBuy"     buyMarketEvent.Parent  = remotes
local getMarketFn     = Instance.new("RemoteFunction") getMarketFn.Name     = "GetMarket"     getMarketFn.Parent     = remotes
local marketUpdate    = Instance.new("RemoteEvent")    marketUpdate.Name    = "MarketUpdate"  marketUpdate.Parent    = remotes

local listings = {}  -- { id, sellerName, sellerUserId, itemName, qty, price }
local nextId = 1

getMarketFn.OnServerInvoke = function() return listings end

listItemEvent.OnServerEvent:Connect(function(player, itemName, qty, price)
	if type(price)~="number" or price<=0 then return end
	local removeItem = remotes:FindFirstChild("RemoveItem")
	if removeItem then removeItem:FireServer(player, itemName, qty) end

	table.insert(listings, {
		id=nextId, sellerName=player.Name, sellerUserId=player.UserId,
		itemName=itemName, qty=qty, price=price
	})
	nextId += 1

	for _, p in ipairs(Players:GetPlayers()) do
		marketUpdate:FireClient(p, listings)
	end
	print(("[Mercado] %s listou %dx%s por R$%d"):format(player.Name,qty,itemName,price))
end)

buyMarketEvent.OnServerEvent:Connect(function(player, listingId)
	local idx = nil
	for i, l in ipairs(listings) do if l.id==listingId then idx=i break end end
	if not idx then return end
	local listing = listings[idx]
	if listing.sellerUserId == player.UserId then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	local addMoney    = remotes:FindFirstChild("AddMoney")
	local addItem     = remotes:FindFirstChild("AddItem")

	if removeMoney then removeMoney:FireServer(player, listing.price) end
	if addItem     then addItem:FireServer(player, listing.itemName, listing.qty) end

	local seller = Players:GetPlayerByUserId(listing.sellerUserId)
	if seller and addMoney then addMoney:FireServer(seller, listing.price) end

	table.remove(listings, idx)
	for _, p in ipairs(Players:GetPlayers()) do marketUpdate:FireClient(p, listings) end
	print(("[Mercado] %s comprou %s de %s"):format(player.Name, listing.itemName, listing.sellerName))
end)
