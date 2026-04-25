local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local scratchEvent  = Instance.new("RemoteEvent")    scratchEvent.Name  = "ScratchCard"   scratchEvent.Parent  = remotes
local scratchResult = Instance.new("RemoteEvent")    scratchResult.Name = "ScratchResult" scratchResult.Parent = remotes

local Cards = {
	{ name="Raspadinha R$5",   price=5,   prizes={0,0,0,5,10,50,100},    weights={30,25,20,15,7,2,1} },
	{ name="Raspadinha R$10",  price=10,  prizes={0,0,10,20,100,500,1000},weights={25,20,20,15,10,8,2} },
	{ name="Raspadinha R$50",  price=50,  prizes={0,50,100,500,1000,5000,10000},weights={20,20,20,15,12,8,5} },
}

local function weightedRandom(prizes, weights)
	local total = 0
	for _, w in ipairs(weights) do total += w end
	local roll = math.random(1, total)
	local acc = 0
	for i, w in ipairs(weights) do
		acc += w
		if roll <= acc then return prizes[i] end
	end
	return prizes[1]
end

scratchEvent.OnServerEvent:Connect(function(player, cardIndex)
	local card = Cards[cardIndex]
	if not card then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, card.price) end

	local prize = weightedRandom(card.prizes, card.weights)

	if prize > 0 then
		local addMoney = remotes:FindFirstChild("AddMoney")
		if addMoney then addMoney:FireServer(player, prize) end
	end

	scratchResult:FireClient(player, card.name, prize)
	print(("[Raspadinha] %s ganhou R$%d"):format(player.Name, prize))
end)
