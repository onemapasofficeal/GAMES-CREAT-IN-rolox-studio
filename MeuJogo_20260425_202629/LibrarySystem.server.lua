local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local readBookEvent = Instance.new("RemoteEvent")    readBookEvent.Name = "ReadBook"     readBookEvent.Parent = remotes
local bookListFn    = Instance.new("RemoteFunction") bookListFn.Name    = "GetBookList"  bookListFn.Parent    = remotes

local Books = {
	{ id=1, name="Economia Básica",    xp=30,  cooldown=60  },
	{ id=2, name="Arte da Guerra",     xp=40,  cooldown=80  },
	{ id=3, name="Programação",        xp=50,  cooldown=100 },
	{ id=4, name="Medicina Popular",   xp=35,  cooldown=70  },
	{ id=5, name="Culinária Avançada", xp=45,  cooldown=90  },
	{ id=6, name="Filosofia",          xp=25,  cooldown=50  },
	{ id=7, name="História do Mundo",  xp=30,  cooldown=60  },
}

local playerReads = {}

Players.PlayerAdded:Connect(function(p) playerReads[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p) playerReads[p.UserId]=nil end)

bookListFn.OnServerInvoke = function() return Books end

readBookEvent.OnServerEvent:Connect(function(player, bookId)
	local book = nil
	for _, b in ipairs(Books) do if b.id==bookId then book=b break end end
	if not book then return end

	local pr = playerReads[player.UserId]
	local now = tick()
	if pr[bookId] and now - pr[bookId] < book.cooldown then
		warn("[Biblioteca] Já leu recentemente")
		return
	end
	pr[bookId] = now

	local addXP = remotes:FindFirstChild("AddXP")
	if addXP then addXP:FireServer(player, book.xp) end
	print(("[Biblioteca] %s leu %s (+%dXP)"):format(player.Name, book.name, book.xp))
end)
