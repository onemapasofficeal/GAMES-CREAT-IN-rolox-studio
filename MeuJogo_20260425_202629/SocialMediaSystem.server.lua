local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local postEvent    = Instance.new("RemoteEvent")    postEvent.Name    = "SocialPost"    postEvent.Parent    = remotes
local likeEvent    = Instance.new("RemoteEvent")    likeEvent.Name    = "SocialLike"    likeEvent.Parent    = remotes
local feedFn       = Instance.new("RemoteFunction") feedFn.Name       = "GetSocialFeed" feedFn.Parent       = remotes
local feedUpdate   = Instance.new("RemoteEvent")    feedUpdate.Name   = "FeedUpdate"    feedUpdate.Parent   = remotes

local posts = {}
local nextPostId = 1

feedFn.OnServerInvoke = function() return posts end

postEvent.OnServerEvent:Connect(function(player, content)
	if type(content)~="string" or #content>280 then return end
	content = content:gsub("[<>]","")

	local post = {
		id = nextPostId,
		author = player.Name,
		content = content,
		likes = 0,
		time = os.time()
	}
	table.insert(posts, 1, post)
	nextPostId += 1
	if #posts > 50 then table.remove(posts) end

	for _, p in ipairs(Players:GetPlayers()) do feedUpdate:FireClient(p, post) end

	-- XP por postar
	local addXP = remotes:FindFirstChild("AddXP")
	if addXP then addXP:FireServer(player, 2) end
	print(("[Social] %s postou: %s"):format(player.Name, content))
end)

likeEvent.OnServerEvent:Connect(function(player, postId)
	for _, post in ipairs(posts) do
		if post.id == postId then
			post.likes += 1
			-- Notifica o autor
			local author = Players:FindFirstChild(post.author)
			if author and author ~= player then
				local addMoney = remotes:FindFirstChild("AddMoney")
				if addMoney then addMoney:FireServer(author, 5) end
			end
			for _, p in ipairs(Players:GetPlayers()) do feedUpdate:FireClient(p, post) end
			return
		end
	end
end)
