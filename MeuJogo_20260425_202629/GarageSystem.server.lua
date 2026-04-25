local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local repairEvent  = Instance.new("RemoteEvent")    repairEvent.Name  = "RepairCar"    repairEvent.Parent  = remotes
local upgradeEvent = Instance.new("RemoteEvent")    upgradeEvent.Name = "UpgradeCar"   upgradeEvent.Parent = remotes
local garageListFn = Instance.new("RemoteFunction") garageListFn.Name = "GetGarageList" garageListFn.Parent = remotes

local Upgrades = {
	{ id=1, name="Motor Turbo",    price=2000, speedBonus=20 },
	{ id=2, name="Suspensão Sport",price=1500, speedBonus=10 },
	{ id=3, name="Pneus Slick",    price=1000, speedBonus=8  },
	{ id=4, name="Nitro",          price=3000, speedBonus=30 },
	{ id=5, name="Blindagem",      price=5000, speedBonus=0  },
}

local playerUpgrades = {}

Players.PlayerAdded:Connect(function(p) playerUpgrades[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p) playerUpgrades[p.UserId]=nil end)

garageListFn.OnServerInvoke = function(player)
	return Upgrades, playerUpgrades[player.UserId] or {}
end

repairEvent.OnServerEvent:Connect(function(player)
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, 500) end
	print(("[Garagem] %s consertou o carro"):format(player.Name))
end)

upgradeEvent.OnServerEvent:Connect(function(player, upgradeId)
	local upg = nil
	for _, u in ipairs(Upgrades) do if u.id==upgradeId then upg=u break end end
	if not upg then return end
	if playerUpgrades[player.UserId][upgradeId] then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, upg.price) end
	playerUpgrades[player.UserId][upgradeId] = true
	print(("[Garagem] %s instalou %s"):format(player.Name, upg.name))
end)
