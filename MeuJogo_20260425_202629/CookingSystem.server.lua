local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local cookEvent  = Instance.new("RemoteEvent")    cookEvent.Name  = "Cook"          cookEvent.Parent  = remotes
local cookListFn = Instance.new("RemoteFunction") cookListFn.Name = "GetCookList"   cookListFn.Parent = remotes

local Recipes = {
	{ name="Sopa",         ingredients={{"Tomate",2},{"Água",1}},   hunger=50, thirst=20, xp=10 },
	{ name="Churrasco",    ingredients={{"Carne",2}},               hunger=80, thirst=0,  xp=20 },
	{ name="Bolo",         ingredients={{"Trigo",3},{"Ovo",2}},     hunger=60, thirst=10, xp=25 },
	{ name="Suco Natural", ingredients={{"Morango",3},{"Água",1}},  hunger=10, thirst=60, xp=15 },
	{ name="Omelete",      ingredients={{"Ovo",2},{"Queijo",1}},    hunger=45, thirst=0,  xp=12 },
	{ name="Pizza",        ingredients={{"Trigo",2},{"Queijo",2},{"Tomate",2}}, hunger=90, thirst=0, xp=35 },
	{ name="Vitamina",     ingredients={{"Morango",2},{"Leite",1}}, hunger=20, thirst=50, xp=18 },
}

cookListFn.OnServerInvoke = function() return Recipes end

cookEvent.OnServerEvent:Connect(function(player, recipeIndex)
	local recipe = Recipes[recipeIndex]
	if not recipe then return end

	local removeItem = remotes:FindFirstChild("RemoveItem")
	local eatEvent   = remotes:FindFirstChild("Eat")
	local drinkEvent = remotes:FindFirstChild("Drink")
	local addXP      = remotes:FindFirstChild("AddXP")

	for _, ing in ipairs(recipe.ingredients) do
		if removeItem then removeItem:FireServer(player, ing[1], ing[2]) end
	end

	if recipe.hunger > 0 and eatEvent   then eatEvent:FireServer(player, recipe.hunger)   end
	if recipe.thirst > 0 and drinkEvent then drinkEvent:FireServer(player, recipe.thirst) end
	if addXP then addXP:FireServer(player, recipe.xp) end

	print(("[Cozinha] %s cozinhou %s"):format(player.Name, recipe.name))
end)
