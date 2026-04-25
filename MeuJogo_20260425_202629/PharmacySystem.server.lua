local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buyMedEvent = Instance.new("RemoteEvent")    buyMedEvent.Name = "BuyMedicine"   buyMedEvent.Parent = remotes
local medListFn   = Instance.new("RemoteFunction") medListFn.Name   = "GetMedList"    medListFn.Parent   = remotes

local Medicines = {
	{ id=1, name="Paracetamol",   price=10,  hpBonus=20  },
	{ id=2, name="Antibiótico",   price=50,  hpBonus=50  },
	{ id=3, name="Vitamina C",    price=15,  hpBonus=10  },
	{ id=4, name="Analgésico",    price=20,  hpBonus=30  },
	{ id=5, name="Soro",          price=30,  hpBonus=40  },
	{ id=6, name="Kit Primeiros Socorros", price=80, hpBonus=80 },
	{ id=7, name="Morfina",       price=200, hpBonus=100 },
}

medListFn.OnServerInvoke = function() return Medicines end

buyMedEvent.OnServerEvent:Connect(function(player, medId)
	local med = nil
	for _, m in ipairs(Medicines) do if m.id==medId then med=m break end end
	if not med then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, med.price) end

	local char = player.Character
	if char then
		local hum = char:FindFirstChild("Humanoid")
		if hum then hum.Health = math.min(hum.MaxHealth, hum.Health + med.hpBonus) end
	end

	print(("[Farmácia] %s comprou %s"):format(player.Name, med.name))
end)
