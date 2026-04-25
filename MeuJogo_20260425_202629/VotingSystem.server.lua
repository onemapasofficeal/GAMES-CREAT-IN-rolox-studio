local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local voteEvent    = Instance.new("RemoteEvent")    voteEvent.Name    = "Vote"          voteEvent.Parent    = remotes
local createPollEvent=Instance.new("RemoteEvent")   createPollEvent.Name="CreatePoll"   createPollEvent.Parent=remotes
local pollListFn   = Instance.new("RemoteFunction") pollListFn.Name   = "GetPolls"      pollListFn.Parent   = remotes
local pollUpdate   = Instance.new("RemoteEvent")    pollUpdate.Name   = "PollUpdate"    pollUpdate.Parent   = remotes

local polls = {}
local nextPollId = 1

pollListFn.OnServerInvoke = function() return polls end

createPollEvent.OnServerEvent:Connect(function(player, question, options)
	if type(question)~="string" or type(options)~="table" then return end
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, 100) end

	local poll = {
		id = nextPollId,
		question = question,
		options = options,
		votes = {},
		creator = player.Name,
		active = true
	}
	for i = 1, #options do poll.votes[i] = 0 end
	table.insert(polls, poll)
	nextPollId += 1

	for _, p in ipairs(Players:GetPlayers()) do pollUpdate:FireClient(p, polls) end
	print(("[Votação] %s criou enquete: %s"):format(player.Name, question))
end)

voteEvent.OnServerEvent:Connect(function(player, pollId, optionIndex)
	for _, poll in ipairs(polls) do
		if poll.id == pollId and poll.active then
			if poll.votes[optionIndex] then
				poll.votes[optionIndex] += 1
				for _, p in ipairs(Players:GetPlayers()) do pollUpdate:FireClient(p, polls) end
				print(("[Votação] %s votou na opção %d"):format(player.Name, optionIndex))
				return
			end
		end
	end
end)
