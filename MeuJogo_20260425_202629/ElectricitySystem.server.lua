-- Sistema de energia elétrica da casa
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local payBillEvent  = Instance.new("RemoteEvent")    payBillEvent.Name  = "PayElectric"  payBillEvent.Parent  = remotes
local billInfoFn    = Instance.new("RemoteFunction") billInfoFn.Name    = "GetElectricBill" billInfoFn.Parent = remotes
local powerUpdate   = Instance.new("RemoteEvent")    powerUpdate.Name   = "PowerUpdate"  powerUpdate.Parent   = remotes

local playerPower = {}  -- userId → { hasPower, bill, dueIn }

Players.PlayerAdded:Connect(function(p)
	playerPower[p.UserId] = { hasPower=true, bill=200, dueIn=300 }
	task.spawn(function()
		while playerPower[p.UserId] do
			task.wait(10)
			local data = playerPower[p.UserId]
			if not data then break end
			data.dueIn = math.max(0, data.dueIn - 10)
			data.bill  = data.bill + 5  -- consumo
			if data.dueIn <= 0 and data.hasPower then
				data.hasPower = false
				powerUpdate:FireClient(p, false, data.bill)
				print(("[Energia] %s ficou sem luz!"):format(p.Name))
			end
		end
	end)
end)
Players.PlayerRemoving:Connect(function(p) playerPower[p.UserId]=nil end)

billInfoFn.OnServerInvoke = function(player)
	return playerPower[player.UserId]
end

payBillEvent.OnServerEvent:Connect(function(player)
	local data = playerPower[player.UserId]
	if not data then return end
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, data.bill) end
	data.bill = 200
	data.dueIn = 300
	data.hasPower = true
	powerUpdate:FireClient(player, true, data.bill)
	print(("[Energia] %s pagou a conta de luz"):format(player.Name))
end)
