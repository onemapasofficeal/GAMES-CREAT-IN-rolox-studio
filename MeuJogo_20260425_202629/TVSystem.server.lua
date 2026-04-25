local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local watchTVEvent = Instance.new("RemoteEvent")    watchTVEvent.Name = "WatchTV"     watchTVEvent.Parent = remotes
local tvListFn     = Instance.new("RemoteFunction") tvListFn.Name     = "GetTVList"   tvListFn.Parent     = remotes
local tvBroadcast  = Instance.new("RemoteEvent")    tvBroadcast.Name  = "TVBroadcast" tvBroadcast.Parent  = remotes

local Channels = {
	{ id=1, name="Canal Notícias",  content="Últimas notícias da cidade...",  xp=3  },
	{ id=2, name="Canal Esportes",  content="Futebol ao vivo!",               xp=5  },
	{ id=3, name="Canal Filmes",    content="Filme em exibição...",            xp=8  },
	{ id=4, name="Canal Culinária", content="Receitas deliciosas!",            xp=6  },
	{ id=5, name="Canal Educativo", content="Aprenda algo novo hoje!",         xp=10 },
	{ id=6, name="Canal Música",    content="Os melhores hits!",               xp=4  },
}

tvListFn.OnServerInvoke = function() return Channels end

watchTVEvent.OnServerEvent:Connect(function(player, channelId)
	local ch = nil
	for _, c in ipairs(Channels) do if c.id==channelId then ch=c break end end
	if not ch then return end

	tvBroadcast:FireClient(player, ch)

	task.delay(30, function()
		local addXP = remotes:FindFirstChild("AddXP")
		if addXP then addXP:FireServer(player, ch.xp) end
	end)
	print(("[TV] %s assistiu %s"):format(player.Name, ch.name))
end)
