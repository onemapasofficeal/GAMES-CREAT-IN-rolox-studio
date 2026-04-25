local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local radioEvent    = Instance.new("RemoteEvent")    radioEvent.Name    = "RadioBroadcast" radioEvent.Parent    = remotes
local radioReceive  = Instance.new("RemoteEvent")    radioReceive.Name  = "RadioReceive"   radioReceive.Parent  = remotes
local radioListFn   = Instance.new("RemoteFunction") radioListFn.Name   = "GetRadioList"   radioListFn.Parent   = remotes

local Stations = {
	{ id=1, name="Rádio Cidade",    freq="98.5 FM", genre="Pop"      },
	{ id=2, name="Rádio Sertanejo", freq="100.3 FM",genre="Sertanejo"},
	{ id=3, name="Rádio Rock",      freq="102.7 FM",genre="Rock"     },
	{ id=4, name="Rádio Funk",      freq="104.1 FM",genre="Funk"     },
	{ id=5, name="Rádio Notícias",  freq="106.5 FM",genre="Notícias" },
}

local playerStation = {}

Players.PlayerAdded:Connect(function(p) playerStation[p.UserId]=1 end)
Players.PlayerRemoving:Connect(function(p) playerStation[p.UserId]=nil end)

radioListFn.OnServerInvoke = function() return Stations end

radioEvent.OnServerEvent:Connect(function(player, stationId)
	local station = nil
	for _, s in ipairs(Stations) do if s.id==stationId then station=s break end end
	if not station then return end

	playerStation[player.UserId] = stationId
	radioReceive:FireClient(player, station)
	print(("[Rádio] %s sintonizou %s"):format(player.Name, station.name))
end)
