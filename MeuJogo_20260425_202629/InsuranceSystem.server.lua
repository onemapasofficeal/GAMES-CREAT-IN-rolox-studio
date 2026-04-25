local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buyInsuranceEvent = Instance.new("RemoteEvent")    buyInsuranceEvent.Name = "BuyInsurance"  buyInsuranceEvent.Parent = remotes
local claimEvent        = Instance.new("RemoteEvent")    claimEvent.Name        = "ClaimInsurance" claimEvent.Parent       = remotes
local insuranceListFn   = Instance.new("RemoteFunction") insuranceListFn.Name   = "GetInsuranceList" insuranceListFn.Parent = remotes

local Plans = {
	{ id=1, name="Seguro Básico",    price=300,  coverage=1000, type="basic"  },
	{ id=2, name="Seguro Carro",     price=800,  coverage=5000, type="car"    },
	{ id=3, name="Seguro Casa",      price=1500, coverage=15000,type="house"  },
	{ id=4, name="Seguro Vida",      price=500,  coverage=3000, type="life"   },
	{ id=5, name="Seguro Total",     price=3000, coverage=30000,type="total"  },
}

local playerInsurance = {}  -- userId → { planId → active }

Players.PlayerAdded:Connect(function(p) playerInsurance[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p) playerInsurance[p.UserId]=nil end)

insuranceListFn.OnServerInvoke = function(player)
	return Plans, playerInsurance[player.UserId] or {}
end

buyInsuranceEvent.OnServerEvent:Connect(function(player, planId)
	local plan = Plans[planId]
	if not plan then return end
	if playerInsurance[player.UserId][planId] then return end
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, plan.price) end
	playerInsurance[player.UserId][planId] = true
	print(("[Seguro] %s comprou %s"):format(player.Name, plan.name))
end)

claimEvent.OnServerEvent:Connect(function(player, planId)
	local plan = Plans[planId]
	if not plan then return end
	if not playerInsurance[player.UserId][planId] then return end
	local addMoney = remotes:FindFirstChild("AddMoney")
	if addMoney then addMoney:FireServer(player, plan.coverage) end
	playerInsurance[player.UserId][planId] = nil  -- usa o seguro
	print(("[Seguro] %s acionou %s e recebeu R$%d"):format(player.Name, plan.name, plan.coverage))
end)
