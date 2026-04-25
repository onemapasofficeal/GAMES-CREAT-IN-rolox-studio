-- FarmSystem.server.lua
-- Agricultura: plantar, regar, colher

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local plantEvent   = Instance.new("RemoteEvent")    plantEvent.Name   = "Plant"       plantEvent.Parent   = remotes
local waterEvent   = Instance.new("RemoteEvent")    waterEvent.Name   = "Water"       waterEvent.Parent   = remotes
local harvestEvent = Instance.new("RemoteEvent")    harvestEvent.Name = "Harvest"     harvestEvent.Parent = remotes
local farmListFn   = Instance.new("RemoteFunction") farmListFn.Name   = "GetFarmList" farmListFn.Parent   = remotes

local Crops = {
	{ id = 1, name = "Tomate",    growTime = 60,  sellPrice = 30,  seedCost = 5  },
	{ id = 2, name = "Milho",     growTime = 120, sellPrice = 60,  seedCost = 10 },
	{ id = 3, name = "Trigo",     growTime = 90,  sellPrice = 45,  seedCost = 8  },
	{ id = 4, name = "Morango",   growTime = 180, sellPrice = 100, seedCost = 20 },
}

local plots = {}  -- userId → lista de { cropId, planted, watered, readyAt, part }

farmListFn.OnServerInvoke = function() return Crops end

Players.PlayerAdded:Connect(function(p) plots[p.UserId] = {} end)
Players.PlayerRemoving:Connect(function(p)
	if plots[p.UserId] then
		for _, plot in ipairs(plots[p.UserId]) do
			if plot.part then plot.part:Destroy() end
		end
	end
	plots[p.UserId] = nil
end)

plantEvent.OnServerEvent:Connect(function(player, cropId)
	local crop = nil
	for _, v in ipairs(Crops) do if v.id == cropId then crop = v break end end
	if not crop then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, crop.seedCost) end

	local char = player.Character
	local pos = char and char.HumanoidRootPart.Position + Vector3.new(math.random(-5,5), 0, math.random(5,10)) or Vector3.new(0,0,0)

	local part = Instance.new("Part")
	part.Size = Vector3.new(2, 0.5, 2)
	part.Position = pos
	part.Anchored = true
	part.Color = Color3.fromRGB(80, 50, 20)
	part.Material = Enum.Material.Grass
	part.Parent = Workspace

	local label = Instance.new("BillboardGui", part)
	label.Size = UDim2.new(0, 100, 0, 40)
	label.StudsOffset = Vector3.new(0, 2, 0)
	local txt = Instance.new("TextLabel", label)
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 1
	txt.TextColor3 = Color3.new(1,1,1)
	txt.Text = crop.name .. " 🌱"
	txt.TextScaled = true

	local plotData = {
		cropId  = cropId,
		planted = tick(),
		watered = false,
		readyAt = tick() + crop.growTime,
		part    = part,
		label   = txt,
		crop    = crop,
	}
	table.insert(plots[player.UserId], plotData)

	-- Atualiza visual quando pronto
	task.delay(crop.growTime, function()
		if plotData.part and plotData.part.Parent then
			plotData.part.Color = Color3.fromRGB(50, 150, 50)
			plotData.label.Text = crop.name .. " ✅"
		end
	end)

	print(("[Fazenda] %s plantou %s"):format(player.Name, crop.name))
end)

waterEvent.OnServerEvent:Connect(function(player, index)
	local p = plots[player.UserId]
	if not p or not p[index] then return end
	p[index].watered = true
	p[index].readyAt = p[index].readyAt - 20  -- acelera 20s
	print(("[Fazenda] %s regou plantação %d"):format(player.Name, index))
end)

harvestEvent.OnServerEvent:Connect(function(player, index)
	local p = plots[player.UserId]
	if not p or not p[index] then return end
	local plot = p[index]
	if tick() < plot.readyAt then
		warn("[Fazenda] Ainda não está pronto!")
		return
	end
	local addMoney = remotes:FindFirstChild("AddMoney")
	if addMoney then addMoney:FireServer(player, plot.crop.sellPrice) end
	if plot.part then plot.part:Destroy() end
	table.remove(p, index)
	print(("[Fazenda] %s colheu %s e ganhou R$%d"):format(player.Name, plot.crop.name, plot.crop.sellPrice))
end)
