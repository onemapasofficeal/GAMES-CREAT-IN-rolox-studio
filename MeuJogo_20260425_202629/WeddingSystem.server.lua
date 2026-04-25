local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local proposeEvent  = Instance.new("RemoteEvent")    proposeEvent.Name  = "Propose"      proposeEvent.Parent  = remotes
local acceptEvent   = Instance.new("RemoteEvent")    acceptEvent.Name   = "AcceptMarriage" acceptEvent.Parent  = remotes
local divorceEvent  = Instance.new("RemoteEvent")    divorceEvent.Name  = "Divorce"       divorceEvent.Parent  = remotes
local receivePropose= Instance.new("RemoteEvent")    receivePropose.Name= "ReceivePropose" receivePropose.Parent= remotes
local marriageUpdate= Instance.new("RemoteEvent")    marriageUpdate.Name= "MarriageUpdate" marriageUpdate.Parent= remotes

local marriages = {}  -- userId → spouseId

-- Cria igreja
local churchFolder = Instance.new("Folder") churchFolder.Name="Church" churchFolder.Parent=Workspace
local church = Instance.new("Part") church.Size=Vector3.new(20,15,30) church.Position=Vector3.new(-50,7.5,50) church.Anchored=true church.Color=Color3.fromRGB(240,230,210) church.Material=Enum.Material.SmoothPlastic church.Parent=churchFolder
local tower = Instance.new("Part") tower.Size=Vector3.new(6,25,6) tower.Position=Vector3.new(-50,12.5,65) tower.Anchored=true tower.Color=Color3.fromRGB(240,230,210) tower.Material=Enum.Material.SmoothPlastic tower.Parent=churchFolder

Players.PlayerAdded:Connect(function(p) marriages[p.UserId]=nil end)
Players.PlayerRemoving:Connect(function(p)
	local spouse = marriages[p.UserId]
	if spouse then marriages[spouse]=nil end
	marriages[p.UserId]=nil
end)

proposeEvent.OnServerEvent:Connect(function(player, targetName)
	local target = Players:FindFirstChild(targetName)
	if not target then return end
	if marriages[player.UserId] then warn("[Casamento] Já casado") return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, 500) end  -- anel

	receivePropose:FireClient(target, player.Name)
	print(("[Casamento] %s pediu %s em casamento"):format(player.Name, target.Name))
end)

acceptEvent.OnServerEvent:Connect(function(player, proposerName)
	local proposer = Players:FindFirstChild(proposerName)
	if not proposer then return end

	marriages[player.UserId] = proposer.UserId
	marriages[proposer.UserId] = player.UserId

	marriageUpdate:FireClient(player, proposer.Name)
	marriageUpdate:FireClient(proposer, player.Name)

	-- Teleporta para a igreja
	for _, p in ipairs({player, proposer}) do
		local char = p.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(-50, 5, 50)
		end
	end

	local addXP = remotes:FindFirstChild("AddXP")
	if addXP then
		addXP:FireServer(player, 100)
		addXP:FireServer(proposer, 100)
	end
	print(("[Casamento] %s e %s se casaram!"):format(player.Name, proposer.Name))
end)

divorceEvent.OnServerEvent:Connect(function(player)
	local spouseId = marriages[player.UserId]
	if not spouseId then return end
	local spouse = Players:GetPlayerByUserId(spouseId)
	if spouse then marriages[spouse.UserId]=nil end
	marriages[player.UserId]=nil
	print(("[Casamento] %s se divorciou"):format(player.Name))
end)
