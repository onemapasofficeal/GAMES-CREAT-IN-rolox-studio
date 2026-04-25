local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local payTaxEvent = Instance.new("RemoteEvent")    payTaxEvent.Name = "PayTax"     payTaxEvent.Parent = remotes
local taxInfoFn   = Instance.new("RemoteFunction") taxInfoFn.Name   = "GetTaxInfo" taxInfoFn.Parent   = remotes
local taxUpdate   = Instance.new("RemoteEvent")    taxUpdate.Name   = "TaxUpdate"  taxUpdate.Parent   = remotes

local TAX_RATE = 0.05  -- 5% do saldo
local TAX_INTERVAL = 300  -- a cada 5 minutos

local playerTax = {}  -- userId → { owed, lastPaid }

Players.PlayerAdded:Connect(function(p)
	playerTax[p.UserId] = { owed=0, lastPaid=tick() }

	task.spawn(function()
		while playerTax[p.UserId] do
			task.wait(TAX_INTERVAL)
			if not playerTax[p.UserId] then break end

			local ls = p:FindFirstChild("leaderstats")
			local money = ls and ls:FindFirstChild("Dinheiro") and ls.Dinheiro.Value or 0
			local tax = math.floor(money * TAX_RATE)

			if tax > 0 then
				playerTax[p.UserId].owed += tax
				taxUpdate:FireClient(p, playerTax[p.UserId])
				print(("[Imposto] %s deve R$%d de imposto"):format(p.Name, tax))
			end
		end
	end)
end)
Players.PlayerRemoving:Connect(function(p) playerTax[p.UserId]=nil end)

taxInfoFn.OnServerInvoke = function(player)
	return playerTax[player.UserId]
end

payTaxEvent.OnServerEvent:Connect(function(player)
	local data = playerTax[player.UserId]
	if not data or data.owed <= 0 then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, data.owed) end

	data.lastPaid = tick()
	data.owed = 0
	taxUpdate:FireClient(player, data)
	print(("[Imposto] %s pagou impostos"):format(player.Name))
end)
