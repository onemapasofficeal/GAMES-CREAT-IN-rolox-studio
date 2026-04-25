local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buyHealthEvent  = Instance.new("RemoteEvent")    buyHealthEvent.Name  = "BuyHealthInsurance" buyHealthEvent.Parent  = remotes
local claimHealthEvent= Instance.new("RemoteEvent")    claimHealthEvent.Name= "ClaimHealthInsurance" claimHealthEvent.Parent= remotes
local healthPlanFn    = Instance.new("RemoteFunction") healthPlanFn.Name    = "GetHealthPlans"    healthPlanFn.Parent    = remotes

local Plans = {
	{ id=1, name="Básico",    price=200,  coverage=500,  deductible=100 },
	{ id=2, name="Padrão",    price=500,  coverage=2000, deductible=50  },
	{ id=3, name="Premium",   price=1200, coverage=8000, deductible=0   },
	{ id=4, name="Executivo", price=3000, coverage=20000,deductible=0   },
}

local playerPlans = {}

Players.PlayerAdded:Connect(function(p) playerPlans[p.UserId]=nil end)
Players.PlayerRemoving:Connect(function(p) playerPlans[p.UserId]=nil end)

healthPlanFn.OnServerInvoke = function(player)
	return Plans, playerPlans[player.UserId]
end

buyHealthEvent.OnServerEvent:Connect(function(player, planId)
	local plan = nil
	for _, p in ipairs(Plans) do if p.id==planId then plan=p break end end
	if not plan then return end
	if playerPlans[player.UserId] then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, plan.price) end
	playerPlans[player.UserId] = planId
	print(("[Plano de Saúde] %s contratou %s"):format(player.Name, plan.name))
end)

claimHealthEvent.OnServerEvent:Connect(function(player)
	local planId = playerPlans[player.UserId]
	if not planId then warn("[Plano] Sem plano de saúde") return end
	local plan = nil
	for _, p in ipairs(Plans) do if p.id==planId then plan=p break end end
	if not plan then return end

	local payout = plan.coverage - plan.deductible
	local addMoney = remotes:FindFirstChild("AddMoney")
	if addMoney then addMoney:FireServer(player, payout) end

	local char = player.Character
	if char then
		local hum = char:FindFirstChild("Humanoid")
		if hum then hum.Health = hum.MaxHealth end
	end

	playerPlans[player.UserId] = nil  -- plano usado
	print(("[Plano de Saúde] %s acionou plano, recebeu R$%d"):format(player.Name, payout))
end)
