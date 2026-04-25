local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local fileChargeEvent = Instance.new("RemoteEvent")    fileChargeEvent.Name = "FileCharge"   fileChargeEvent.Parent = remotes
local verdictEvent    = Instance.new("RemoteEvent")    verdictEvent.Name    = "Verdict"      verdictEvent.Parent    = remotes
local caseListFn      = Instance.new("RemoteFunction") caseListFn.Name      = "GetCaseList"  caseListFn.Parent      = remotes
local caseUpdate      = Instance.new("RemoteEvent")    caseUpdate.Name      = "CaseUpdate"   caseUpdate.Parent      = remotes

local cases = {}
local nextCaseId = 1

caseListFn.OnServerInvoke = function() return cases end

fileChargeEvent.OnServerEvent:Connect(function(player, targetName, crime, fine)
	local target = Players:FindFirstChild(targetName)
	if not target then return end
	if type(fine)~="number" or fine<=0 then return end

	local case = {
		id = nextCaseId,
		plaintiff = player.Name,
		defendant = target.Name,
		defendantUserId = target.UserId,
		crime = crime or "Conduta Imprópria",
		fine = fine,
		status = "Pendente",
		time = os.time()
	}
	table.insert(cases, case)
	nextCaseId += 1

	for _, p in ipairs(Players:GetPlayers()) do caseUpdate:FireClient(p, cases) end
	print(("[Tribunal] %s processou %s por %s"):format(player.Name, target.Name, crime))
end)

verdictEvent.OnServerEvent:Connect(function(player, caseId, guilty)
	local caseIdx = nil
	for i, c in ipairs(cases) do if c.id==caseId then caseIdx=i break end end
	if not caseIdx then return end

	local c = cases[caseIdx]
	c.status = guilty and "Culpado" or "Inocente"

	if guilty then
		local defendant = Players:GetPlayerByUserId(c.defendantUserId)
		if defendant then
			local removeMoney = remotes:FindFirstChild("RemoveMoney")
			if removeMoney then removeMoney:FireServer(defendant, c.fine) end
			if _G.SendToJail then _G.SendToJail(defendant, 60) end
		end
	end

	for _, p in ipairs(Players:GetPlayers()) do caseUpdate:FireClient(p, cases) end
	print(("[Tribunal] Caso %d: %s"):format(caseId, c.status))
end)
