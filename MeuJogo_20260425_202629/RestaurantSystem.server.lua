local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local orderEvent   = Instance.new("RemoteEvent")    orderEvent.Name   = "OrderFood"    orderEvent.Parent   = remotes
local menuFn       = Instance.new("RemoteFunction") menuFn.Name       = "GetRestMenu"  menuFn.Parent       = remotes

local Menu = {
	{ name="X-Burguer",    price=35,  hunger=70, thirst=10 },
	{ name="Pizza Fatia",  price=25,  hunger=50, thirst=5  },
	{ name="Salada",       price=20,  hunger=35, thirst=15 },
	{ name="Frango Grelhado",price=45,hunger=80, thirst=0  },
	{ name="Sorvete",      price=15,  hunger=20, thirst=20 },
	{ name="Refrigerante", price=10,  hunger=0,  thirst=50 },
	{ name="Suco",         price=12,  hunger=5,  thirst=55 },
	{ name="Café",         price=8,   hunger=5,  thirst=30 },
	{ name="Combo Completo",price=80, hunger=100,thirst=60 },
}

menuFn.OnServerInvoke = function() return Menu end

orderEvent.OnServerEvent:Connect(function(player, itemIndex)
	local item = Menu[itemIndex]
	if not item then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	local eatEvent    = remotes:FindFirstChild("Eat")
	local drinkEvent  = remotes:FindFirstChild("Drink")

	if removeMoney then removeMoney:FireServer(player, item.price) end
	task.wait(1)
	if item.hunger>0 and eatEvent   then eatEvent:FireServer(player, item.hunger)   end
	if item.thirst>0 and drinkEvent then drinkEvent:FireServer(player, item.thirst) end
	print(("[Restaurante] %s pediu %s"):format(player.Name, item.name))
end)
