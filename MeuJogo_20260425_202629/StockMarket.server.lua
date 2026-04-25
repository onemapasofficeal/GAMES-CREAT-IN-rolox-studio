local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buyStockEvent  = Instance.new("RemoteEvent")    buyStockEvent.Name  = "BuyStock"     buyStockEvent.Parent  = remotes
local sellStockEvent = Instance.new("RemoteEvent")    sellStockEvent.Name = "SellStock"    sellStockEvent.Parent = remotes
local stockListFn    = Instance.new("RemoteFunction") stockListFn.Name    = "GetStocks"    stockListFn.Parent    = remotes
local stockUpdate    = Instance.new("RemoteEvent")    stockUpdate.Name    = "StockUpdate"  stockUpdate.Parent    = remotes

local Stocks = {
	{ id=1, name="TechCorp",   price=100, change=0 },
	{ id=2, name="OilCo",      price=80,  change=0 },
	{ id=3, name="FoodInc",    price=50,  change=0 },
	{ id=4, name="AutoMakers", price=200, change=0 },
	{ id=5, name="GameStudio", price=150, change=0 },
}

local playerStocks = {}  -- userId → { stockId → qty }

Players.PlayerAdded:Connect(function(p) playerStocks[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p) playerStocks[p.UserId]=nil end)

-- Flutuação de preços
task.spawn(function()
	while true do
		task.wait(30)
		for _, s in ipairs(Stocks) do
			local change = math.random(-15, 15)
			s.price = math.max(5, s.price + change)
			s.change = change
		end
		for _, p in ipairs(Players:GetPlayers()) do
			stockUpdate:FireClient(p, Stocks)
		end
	end
end)

stockListFn.OnServerInvoke = function(player)
	return Stocks, playerStocks[player.UserId] or {}
end

buyStockEvent.OnServerEvent:Connect(function(player, stockId, qty)
	local stock = nil
	for _, s in ipairs(Stocks) do if s.id==stockId then stock=s break end end
	if not stock or qty<=0 then return end
	local total = stock.price * qty
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, total) end
	playerStocks[player.UserId][stockId] = (playerStocks[player.UserId][stockId] or 0) + qty
	print(("[Bolsa] %s comprou %dx %s por R$%d"):format(player.Name,qty,stock.name,total))
end)

sellStockEvent.OnServerEvent:Connect(function(player, stockId, qty)
	local stock = nil
	for _, s in ipairs(Stocks) do if s.id==stockId then stock=s break end end
	if not stock then return end
	local owned = playerStocks[player.UserId][stockId] or 0
	qty = math.min(qty, owned)
	if qty<=0 then return end
	local total = stock.price * qty
	playerStocks[player.UserId][stockId] = owned - qty
	local addMoney = remotes:FindFirstChild("AddMoney")
	if addMoney then addMoney:FireServer(player, total) end
	print(("[Bolsa] %s vendeu %dx %s por R$%d"):format(player.Name,qty,stock.name,total))
end)
