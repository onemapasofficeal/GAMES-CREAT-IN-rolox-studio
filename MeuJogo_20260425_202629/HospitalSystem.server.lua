-- HospitalSystem.server.lua
-- Hospital: curar, ressuscitar, plano de saúde

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local healEvent      = Instance.new("RemoteEvent")    healEvent.Name      = "HospitalHeal"  healEvent.Parent      = remotes
local buyPlanEvent   = Instance.new("RemoteEvent")    buyPlanEvent.Name   = "BuyHealthPlan" buyPlanEvent.Parent   = remotes
local hasPlanFn      = Instance.new("RemoteFunction") hasPlanFn.Name      = "HasHealthPlan" hasPlanFn.Parent      = remotes

local healthPlans = {}  -- userId → bool

Players.PlayerAdded:Connect(function(p)
	healthPlans[p.UserId] = false

	p.CharacterAdded:Connect(function(char)
		local hum = char:WaitForChild("Humanoid")
		hum.Died:Connect(function()
			task.wait(5)
			-- Ressuscita no hospital
			if p.Character then
				local root = p.Character:FindFirstChild("HumanoidRootPart")
				if root then root.CFrame = CFrame.new(100, 5, 100) end
			end
			-- Cobra taxa se não tiver plano
			if not healthPlans[p.UserId] then
				local removeMoney = remotes:FindFirstChild("RemoveMoney")
				if removeMoney then removeMoney:FireServer(p, 500) end
				print(("[Hospital] %s pagou R$500 de internação"):format(p.Name))
			else
				print(("[Hospital] %s curado pelo plano de saúde"):format(p.Name))
			end
		end)
	end)
end)

Players.PlayerRemoving:Connect(function(p) healthPlans[p.UserId] = nil end)

hasPlanFn.OnServerInvoke = function(player)
	return healthPlans[player.UserId] or false
end

healEvent.OnServerEvent:Connect(function(player)
	local custo = healthPlans[player.UserId] and 0 or 200
	if custo > 0 then
		local removeMoney = remotes:FindFirstChild("RemoveMoney")
		if removeMoney then removeMoney:FireServer(player, custo) end
	end
	local char = player.Character
	if char then
		local hum = char:FindFirstChild("Humanoid")
		if hum then hum.Health = hum.MaxHealth end
	end
	print(("[Hospital] %s curado por R$%d"):format(player.Name, custo))
end)

buyPlanEvent.OnServerEvent:Connect(function(player)
	if healthPlans[player.UserId] then return end
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, 1000) end
	healthPlans[player.UserId] = true
	print(("[Hospital] %s comprou plano de saúde"):format(player.Name))
end)
