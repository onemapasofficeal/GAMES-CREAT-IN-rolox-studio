local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local publishNewsEvent = Instance.new("RemoteEvent")    publishNewsEvent.Name = "PublishNews"  publishNewsEvent.Parent = remotes
local newsUpdate       = Instance.new("RemoteEvent")    newsUpdate.Name       = "NewsUpdate"   newsUpdate.Parent       = remotes
local getNewsFn        = Instance.new("RemoteFunction") getNewsFn.Name        = "GetNews"      getNewsFn.Parent        = remotes

local newsHistory = {}
local MAX_NEWS = 20

-- Notícias automáticas do servidor
local AutoNews = {
	"🌤 O tempo está ensolarado hoje!",
	"💰 O mercado de ações está em alta!",
	"🚨 Atividade criminosa reportada no centro!",
	"🎉 Festival da cidade começa em breve!",
	"⚠ Cuidado com ladrões na área!",
	"🏆 Novo recorde de riqueza foi estabelecido!",
	"🌧 Previsão de chuva para as próximas horas.",
	"🔥 Incêndio reportado! Bombeiros a caminho.",
}

local function addNews(author, message, category)
	local news = {
		author = author,
		message = message,
		category = category or "Geral",
		time = os.time()
	}
	table.insert(newsHistory, 1, news)
	if #newsHistory > MAX_NEWS then table.remove(newsHistory) end
	for _, p in ipairs(Players:GetPlayers()) do
		newsUpdate:FireClient(p, news)
	end
end

-- Auto-notícias
task.spawn(function()
	while true do
		task.wait(math.random(120, 300))
		local msg = AutoNews[math.random(1,#AutoNews)]
		addNews("Jornal da Cidade", msg, "Notícia")
	end
end)

getNewsFn.OnServerInvoke = function() return newsHistory end

publishNewsEvent.OnServerEvent:Connect(function(player, message)
	if type(message)~="string" or #message>200 then return end
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, 50) end
	addNews(player.Name, message, "Jogador")
	print(("[Jornal] %s publicou: %s"):format(player.Name, message))
end)
