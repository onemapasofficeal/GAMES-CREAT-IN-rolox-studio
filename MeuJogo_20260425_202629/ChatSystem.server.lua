local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sendChatEvent   = Instance.new("RemoteEvent") sendChatEvent.Name   = "SendChat"    sendChatEvent.Parent   = remotes
local receiveChatEvent= Instance.new("RemoteEvent") receiveChatEvent.Name= "ReceiveChat" receiveChatEvent.Parent= remotes

local chatHistory = {}
local MAX_HISTORY = 50

local Channels = { "Global", "Local", "Trabalho", "Crime" }

sendChatEvent.OnServerEvent:Connect(function(player, message, channel)
	if type(message)~="string" or #message>200 then return end
	channel = channel or "Global"

	-- Filtro básico
	message = message:gsub("[<>]", "")

	local entry = {
		player = player.Name,
		message = message,
		channel = channel,
		time = os.time()
	}
	table.insert(chatHistory, entry)
	if #chatHistory > MAX_HISTORY then table.remove(chatHistory, 1) end

	if channel == "Global" then
		for _, p in ipairs(Players:GetPlayers()) do
			receiveChatEvent:FireClient(p, player.Name, message, channel)
		end
	elseif channel == "Local" then
		local char = player.Character
		if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then return end
		for _, p in ipairs(Players:GetPlayers()) do
			local c = p.Character
			if c and c:FindFirstChild("HumanoidRootPart") then
				if (c.HumanoidRootPart.Position - root.Position).Magnitude < 50 then
					receiveChatEvent:FireClient(p, player.Name, message, channel)
				end
			end
		end
	else
		for _, p in ipairs(Players:GetPlayers()) do
			receiveChatEvent:FireClient(p, player.Name, message, channel)
		end
	end
end)
