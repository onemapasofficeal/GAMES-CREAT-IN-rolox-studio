local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buyGroceryEvent = Instance.new("RemoteEvent")    buyGroceryEvent.Name = "BuyGrocery"    buyGroceryEvent.Parent = remotes
local groceryListFn   = Instance.new("RemoteFunction") groceryListFn.Name   = "GetGroceryList" groceryListFn.Parent   = remotes

local Groceries = {
	{ id=1,  name="Arroz 1kg",    price=8,   type="item" },
	{ id=2,  name="Feijão 1kg",   price=7,   type="item" },
	{ id=3,  name="Carne 500g",   price=25,  type="item" },
	{ id=4,  name="Leite 1L",     price=5,   type="item" },
	{ id=5,  name="Ovo (dúzia)",  price=12,  type="item" },
	{ id=6,  name="Pão de Forma", price=6,   type="food", hunger=15 },
	{ id=7,  name="Queijo",       price=15,  type="item" },
	{ id=8,  name="Frango 1kg",   price=20,  type="item" },
	{ id=9,  name="Macarrão",     price=4,   type="item" },
	{ id=10, name="Suco de Caixa",price=6,   type="drink",thirst=30 },
	{ id=11, name="Refrigerante", price=5,   type="drink",thirst=25 },
	{ id=12, name="Água Mineral", price=2,   type="drink",thirst=40 },
}

groceryListFn.OnServerInvoke = function() return Groceries end

buyGroceryEvent.OnServerEvent:Connect(function(player, itemId, qty)
	qty = qty or 1
	local item = nil
	for _, g in ipairs(Groceries) do if g.id==itemId then item=g break end end
	if not item then return end

	local total = item.price * qty
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, total) end

	if item.type == "food" then
		local eatEvent = remotes:FindFirstChild("Eat")
		if eatEvent then eatEvent:FireServer(player, (item.hunger or 10)*qty) end
	elseif item.type == "drink" then
		local drinkEvent = remotes:FindFirstChild("Drink")
		if drinkEvent then drinkEvent:FireServer(player, (item.thirst or 10)*qty) end
	else
		local addItem = remotes:FindFirstChild("AddItem")
		if addItem then addItem:FireServer(player, item.name, qty) end
	end

	print(("[Supermercado] %s comprou %dx%s"):format(player.Name, qty, item.name))
end)
