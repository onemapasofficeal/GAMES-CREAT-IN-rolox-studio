-- FishingSystem.server.lua
-- Pesca: pescar e vender peixes

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local fishEvent    = Instance.new("RemoteEvent")    fishEvent.Name    = "Fish"         fishEvent.Parent    = remotes
local fishResult   = Instance.new("RemoteEvent")    fishResult.Name   = "FishResult"   fishResult.Parent   = remotes
local sellFishEvent= Instance.new("RemoteEvent")    sellFishEvent.Name= "SellFish"     sellFishEvent.Parent= remotes

local Fishes = {
	{ name = "Tilápia",   price = 20,  chance = 40 },
	{ name = "Salmão",    price = 60,  chance = 25 },
	{ name = "Atum",      price = 100, chance = 15 },
	{ name = "Peixe-Espada", price = 200, chance = 10 },
	{ name = "Lendário",  price = 500, chance = 5  },
	{ name = "Nada",      price = 0,   chance = 5  },
}

local fishInventory = {}  -- userId → { fishName → qty }
local fishing = {}        -- userId → bool (anti-spam)

Players.PlayerAdded:Connect(function(p) fishInventory[p.UserId] = {} fishing[p.UserId] = false end)
Players.PlayerRemoving:Connect(function(p) fishInventory[p.UserId] = nil fishing[p.UserId] = nil end)

fishEvent.OnServerEvent:Connect(function(player)
	if fishing[player.UserId] then return end
	fishing[player.UserId] = true

	task.delay(math.random(3, 8), function()
		fishing[player.UserId] = false
		local roll = math.random(1, 100)
		local acc = 0
		local caught = nil
		for _, f in ipairs(Fishes) do
			acc += f.chance
			if roll <= acc then caught = f break end
		end
		caught = caught or Fishes[1]

		if caught.price > 0 then
			fishInventory[player.UserId][caught.name] = (fishInventory[player.UserId][caught.name] or 0) + 1
		end

		fishResult:FireClient(player, caught.name, caught.price > 0)
		print(("[Pesca] %s pescou: %s"):format(player.Name, caught.name))
	end)
end)

sellFishEvent.OnServerEvent:Connect(function(player)
	local inv = fishInventory[player.UserId]
	local total = 0
	for fishName, qty in pairs(inv) do
		for _, f in ipairs(Fishes) do
			if f.name == fishName then
				total += f.price * qty
				break
			end
		end
	end
	if total == 0 then return end
	fishInventory[player.UserId] = {}
	local addMoney = remotes:FindFirstChild("AddMoney")
	if addMoney then addMoney:FireServer(player, total) end
	print(("[Pesca] %s vendeu peixes por R$%d"):format(player.Name, total))
end)
