local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local watchMovieEvent = Instance.new("RemoteEvent")    watchMovieEvent.Name = "WatchMovie"   watchMovieEvent.Parent = remotes
local movieListFn     = Instance.new("RemoteFunction") movieListFn.Name     = "GetMovieList" movieListFn.Parent     = remotes
local movieStartEvent = Instance.new("RemoteEvent")    movieStartEvent.Name = "MovieStart"   movieStartEvent.Parent = remotes

local Movies = {
	{ id=1, name="Ação Total",      price=30, duration=120, xp=20 },
	{ id=2, name="Comédia Louca",   price=25, duration=90,  xp=15 },
	{ id=3, name="Terror Noturno",  price=35, duration=100, xp=25 },
	{ id=4, name="Romance Eterno",  price=28, duration=110, xp=18 },
	{ id=5, name="Ficção Científica",price=40,duration=130, xp=30 },
}

movieListFn.OnServerInvoke = function() return Movies end

watchMovieEvent.OnServerEvent:Connect(function(player, movieId)
	local movie = nil
	for _, m in ipairs(Movies) do if m.id==movieId then movie=m break end end
	if not movie then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, movie.price) end

	movieStartEvent:FireClient(player, movie.name, movie.duration)

	task.delay(movie.duration, function()
		local addXP = remotes:FindFirstChild("AddXP")
		if addXP then addXP:FireServer(player, movie.xp) end
		print(("[Cinema] %s assistiu %s"):format(player.Name, movie.name))
	end)
end)
