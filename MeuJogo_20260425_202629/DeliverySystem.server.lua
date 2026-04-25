local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local startDeliveryEvent  = Instance.new("RemoteEvent")    startDeliveryEvent.Name  = "StartDelivery"   startDeliveryEvent.Parent  = remotes
local completeDeliveryEvent=Instance.new("RemoteEvent")    completeDeliveryEvent.Name="CompleteDelivery" completeDeliveryEvent.Parent=remotes
local deliveryInfoFn      = Instance.new("RemoteFunction") deliveryInfoFn.Name      = "GetDeliveryInfo" deliveryInfoFn.Parent      = remotes
local deliveryUpdate      = Instance.new("RemoteEvent")    deliveryUpdate.Name      = "DeliveryUpdate"  deliveryUpdate.Parent      = remotes

local DeliveryPoints = {
	{ name="Pizzaria",    pos=Vector3.new(50,5,50)   },
	{ name="Farmácia",    pos=Vector3.new(-50,5,80)  },
	{ name="Supermercado",pos=Vector3.new(80,5,-50)  },
	{ name="Escola",      pos=Vector3.new(-80,5,-60) },
	{ name="Hospital",    pos=Vector3.new(100,5,100) },
}

local activeDeliveries = {}  -- userId → { from, to, reward, startTime }

deliveryInfoFn.OnServerInvoke = function(player)
	return activeDeliveries[player.UserId], DeliveryPoints
end

startDeliveryEvent.OnServerEvent:Connect(function(player)
	if activeDeliveries[player.UserId] then return end
	local from = DeliveryPoints[math.random(1,#DeliveryPoints)]
	local to   = DeliveryPoints[math.random(1,#DeliveryPoints)]
	while to.name == from.name do to = DeliveryPoints[math.random(1,#DeliveryPoints)] end

	local reward = math.random(80, 250)
	activeDeliveries[player.UserId] = { from=from, to=to, reward=reward, startTime=tick() }
	deliveryUpdate:FireClient(player, activeDeliveries[player.UserId])
	print(("[Entrega] %s: %s → %s (R$%d)"):format(player.Name, from.name, to.name, reward))
end)

completeDeliveryEvent.OnServerEvent:Connect(function(player)
	local delivery = activeDeliveries[player.UserId]
	if not delivery then return end

	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	if (root.Position - delivery.to.pos).Magnitude > 20 then
		warn("[Entrega] Muito longe do destino")
		return
	end

	local timeTaken = tick() - delivery.startTime
	local bonus = timeTaken < 60 and 50 or 0
	local total = delivery.reward + bonus

	local addMoney = remotes:FindFirstChild("AddMoney")
	local addXP    = remotes:FindFirstChild("AddXP")
	if addMoney then addMoney:FireServer(player, total) end
	if addXP    then addXP:FireServer(player, 20) end

	activeDeliveries[player.UserId] = nil
	deliveryUpdate:FireClient(player, nil)
	print(("[Entrega] %s completou entrega! R$%d"):format(player.Name, total))
end)

Players.PlayerAdded:Connect(function(p) activeDeliveries[p.UserId]=nil end)
Players.PlayerRemoving:Connect(function(p) activeDeliveries[p.UserId]=nil end)
