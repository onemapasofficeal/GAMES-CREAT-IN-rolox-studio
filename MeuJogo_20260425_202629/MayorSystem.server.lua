local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local runForMayorEvent = Instance.new("RemoteEvent")    runForMayorEvent.Name = "RunForMayor"  runForMayorEvent.Parent = remotes
local mayorVoteEvent   = Instance.new("RemoteEvent")    mayorVoteEvent.Name   = "MayorVote"    mayorVoteEvent.Parent   = remotes
local mayorActionEvent = Instance.new("RemoteEvent")    mayorActionEvent.Name = "MayorAction"  mayorActionEvent.Parent = remotes
local mayorInfoFn      = Instance.new("RemoteFunction") mayorInfoFn.Name      = "GetMayorInfo" mayorInfoFn.Parent      = remotes
local mayorUpdate      = Instance.new("RemoteEvent")    mayorUpdate.Name      = "MayorUpdate"  mayorUpdate.Parent      = remotes

local currentMayor = nil
local candidates = {}
local votes = {}
local electionActive = false

mayorInfoFn.OnServerInvoke = function()
	return { mayor=currentMayor, candidates=candidates, electionActive=electionActive }
end

runForMayorEvent.OnServerEvent:Connect(function(player)
	if electionActive then return end
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, 5000) end
	table.insert(candidates, player.Name)
	votes[player.Name] = 0
	print(("[Prefeito] %s se candidatou"):format(player.Name))
end)

-- Eleição a cada 10 minutos
task.spawn(function()
	while true do
		task.wait(600)
		if #candidates > 0 then
			electionActive = true
			for _, p in ipairs(Players:GetPlayers()) do
				mayorUpdate:FireClient(p, { mayor=currentMayor, candidates=candidates, electionActive=true })
			end

			task.wait(60)  -- 1 minuto de votação

			-- Conta votos
			local winner = nil
			local maxVotes = -1
			for name, v in pairs(votes) do
				if v > maxVotes then maxVotes=v winner=name end
			end

			currentMayor = winner
			candidates = {}
			votes = {}
			electionActive = false

			for _, p in ipairs(Players:GetPlayers()) do
				mayorUpdate:FireClient(p, { mayor=currentMayor, candidates={}, electionActive=false })
			end
			if winner then print(("[Prefeito] Novo prefeito: "..winner)) end
		end
	end
end)

mayorVoteEvent.OnServerEvent:Connect(function(player, candidateName)
	if not electionActive then return end
	if votes[candidateName] ~= nil then
		votes[candidateName] += 1
	end
end)

mayorActionEvent.OnServerEvent:Connect(function(player, action, value)
	if currentMayor ~= player.Name then return end
	if action == "tax_cut" then
		print(("[Prefeito] %s reduziu impostos"):format(player.Name))
	elseif action == "city_event" then
		print(("[Prefeito] %s organizou evento na cidade"):format(player.Name))
	end
end)
