local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local setBountyEvent  = Instance.new("RemoteEvent")    setBountyEvent.Name  = "SetBounty"    setBountyEvent.Parent  = remotes
local claimBountyEvent= Instance.new("RemoteEvent")    claimBountyEvent.Name= "ClaimBounty"  claimBountyEvent.Parent= remotes
local bountyListFn    = Instance.new("RemoteFunction") bountyListFn.Name    = "GetBountyList" bountyListFn.Parent   = remotes
local bountyUpdate    = Instance.new("RemoteEvent")    bountyUpdate.Name    = "BountyUpdate"  bountyUpdate.Parent   = remotes

local bounties = {}  -- { targetName, targetUserId, amount, setBy }

bountyListFn.OnServerInvoke = function() return bounties end

setBountyEvent.OnServerEvent:Connect(function(player, targetName, amount)
	if type(amount)~="number" or amount<100 then return end
	local target = Players:FindFirstChild(targetName)
	if not target then return end
	if target == player then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, amount) end

	-- Adiciona à recompensa existente
	for _, b in ipairs(bounties) do
		if b.targetUserId == target.UserId then
			b.amount += amount
			for _, p in ipairs(Players:GetPlayers()) do bountyUpdate:FireClient(p, bounties) end
			return
		end
	end

	table.insert(bounties, { targetName=target.Name, targetUserId=target.UserId, amount=amount, setBy=player.Name })
	for _, p in ipairs(Players:GetPlayers()) do bountyUpdate:FireClient(p, bounties) end
	print(("[Recompensa] %s colocou R$%d na cabeça de %s"):format(player.Name, amount, target.Name))
end)

claimBountyEvent.OnServerEvent:Connect(function(player, targetName)
	local target = Players:FindFirstChild(targetName)
	if not target then return end

	local targetChar = target.Character
	if not targetChar then return end
	local hum = targetChar:FindFirstChild("Humanoid")
	if not hum or hum.Health > 0 then return end

	for i, b in ipairs(bounties) do
		if b.targetUserId == target.UserId then
			local addMoney = remotes:FindFirstChild("AddMoney")
			if addMoney then addMoney:FireServer(player, b.amount) end
			table.remove(bounties, i)
			for _, p in ipairs(Players:GetPlayers()) do bountyUpdate:FireClient(p, bounties) end
			print(("[Recompensa] %s coletou R$%d por %s"):format(player.Name, b.amount, target.Name))
			return
		end
	end
end)
