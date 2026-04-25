local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local craftEvent  = Instance.new("RemoteEvent")    craftEvent.Name  = "Craft"         craftEvent.Parent  = remotes
local craftListFn = Instance.new("RemoteFunction") craftListFn.Name = "GetCraftList"  craftListFn.Parent = remotes

local Recipes = {
	{ result="Fogueira",    ingredients={{"Madeira",3},{"Pedra",2}},    xp=20 },
	{ result="Espada",      ingredients={{"Ferro",4},{"Madeira",1}},    xp=50 },
	{ result="Armadura",    ingredients={{"Ferro",6},{"Couro",2}},      xp=80 },
	{ result="Poção",       ingredients={{"Erva",2},{"Água",1}},        xp=15 },
	{ result="Corda",       ingredients={{"Fibra",4}},                  xp=10 },
	{ result="Tenda",       ingredients={{"Madeira",4},{"Corda",2}},    xp=30 },
	{ result="Arco",        ingredients={{"Madeira",2},{"Corda",1}},    xp=35 },
	{ result="Flecha",      ingredients={{"Madeira",1},{"Pedra",1}},    xp=5  },
	{ result="Lanterna",    ingredients={{"Ferro",1},{"Óleo",1}},       xp=25 },
	{ result="Mochila+",    ingredients={{"Couro",4},{"Corda",2}},      xp=60 },
}

craftListFn.OnServerInvoke = function() return Recipes end

craftEvent.OnServerEvent:Connect(function(player, recipeIndex)
	local recipe = Recipes[recipeIndex]
	if not recipe then return end

	local removeItem = remotes:FindFirstChild("RemoveItem")
	local addItem    = remotes:FindFirstChild("AddItem")
	local addXP      = remotes:FindFirstChild("AddXP")

	-- Verifica e remove ingredientes
	for _, ing in ipairs(recipe.ingredients) do
		if removeItem then removeItem:FireServer(player, ing[1], ing[2]) end
	end

	if addItem then addItem:FireServer(player, recipe.result, 1) end
	if addXP   then addXP:FireServer(player, recipe.xp) end

	print(("[Craft] %s criou %s"):format(player.Name, recipe.result))
end)
