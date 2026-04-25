local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local enterClubEvent = Instance.new("RemoteEvent")    enterClubEvent.Name = "EnterClub"    enterClubEvent.Parent = remotes
local buyDrinkEvent  = Instance.new("RemoteEvent")    buyDrinkEvent.Name  = "BuyClubDrink" buyDrinkEvent.Parent  = remotes
local clubMenuFn     = Instance.new("RemoteFunction") clubMenuFn.Name     = "GetClubMenu"  clubMenuFn.Parent     = remotes

local Drinks = {
	{ name="Cerveja",    price=15, thirst=40 },
	{ name="Caipirinha", price=25, thirst=50 },
	{ name="Vodka",      price=30, thirst=45 },
	{ name="Energético", price=20, thirst=35 },
	{ name="Água",       price=5,  thirst=60 },
}

local ENTRY_FEE = 50
local inClub = {}

Players.PlayerAdded:Connect(function(p) inClub[p.UserId]=false end)
Players.PlayerRemoving:Connect(function(p) inClub[p.UserId]=nil end)

clubMenuFn.OnServerInvoke = function() return Drinks end

enterClubEvent.OnServerEvent:Connect(function(player)
	if inClub[player.UserId] then return end
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, ENTRY_FEE) end
	inClub[player.UserId] = true

	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(80, 5, -80)
	end
	print(("[Balada] %s entrou na balada"):format(player.Name))
end)

buyDrinkEvent.OnServerEvent:Connect(function(player, drinkIndex)
	if not inClub[player.UserId] then return end
	local drink = Drinks[drinkIndex]
	if not drink then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	local drinkEvent  = remotes:FindFirstChild("Drink")
	if removeMoney then removeMoney:FireServer(player, drink.price) end
	if drinkEvent  then drinkEvent:FireServer(player, drink.thirst) end
	print(("[Balada] %s comprou %s"):format(player.Name, drink.name))
end)
