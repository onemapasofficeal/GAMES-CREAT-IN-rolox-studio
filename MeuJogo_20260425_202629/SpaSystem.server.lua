local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local spaEvent  = Instance.new("RemoteEvent")    spaEvent.Name  = "UseSpa"     spaEvent.Parent  = remotes
local spaListFn = Instance.new("RemoteFunction") spaListFn.Name = "GetSpaList" spaListFn.Parent = remotes

local Services = {
	{ name="Massagem",       price=150, hpBonus=30,  energyBonus=40 },
	{ name="Sauna",          price=100, hpBonus=20,  energyBonus=30 },
	{ name="Banho de Lama",  price=200, hpBonus=40,  energyBonus=50 },
	{ name="Hidratação",     price=80,  hpBonus=15,  energyBonus=20 },
	{ name="Pacote Completo",price=500, hpBonus=100, energyBonus=100},
}

spaListFn.OnServerInvoke = function() return Services end

spaEvent.OnServerEvent:Connect(function(player, serviceIndex)
	local svc = Services[serviceIndex]
	if not svc then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, svc.price) end

	local char = player.Character
	if char then
		local hum = char:FindFirstChild("Humanoid")
		if hum then hum.Health = math.min(hum.MaxHealth, hum.Health + svc.hpBonus) end
	end

	local sleepUpdate = remotes:FindFirstChild("SleepUpdate")
	if sleepUpdate then sleepUpdate:FireClient(player, math.min(100, svc.energyBonus), false) end

	print(("[Spa] %s usou %s"):format(player.Name, svc.name))
end)
