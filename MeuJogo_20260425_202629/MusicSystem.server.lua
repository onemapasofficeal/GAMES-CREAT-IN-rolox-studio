local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local playMusicEvent  = Instance.new("RemoteEvent")    playMusicEvent.Name  = "PlayMusic"    playMusicEvent.Parent  = remotes
local stopMusicEvent  = Instance.new("RemoteEvent")    stopMusicEvent.Name  = "StopMusic"    stopMusicEvent.Parent  = remotes
local musicListFn     = Instance.new("RemoteFunction") musicListFn.Name     = "GetMusicList" musicListFn.Parent     = remotes
local musicBroadcast  = Instance.new("RemoteEvent")    musicBroadcast.Name  = "MusicBroadcast" musicBroadcast.Parent = remotes

-- IDs de sons do Roblox (sons gratuitos)
local Tracks = {
	{ id=1, name="Cidade Animada",  soundId="rbxassetid://1837849285" },
	{ id=2, name="Noite Tranquila", soundId="rbxassetid://1843671350" },
	{ id=3, name="Ação",            soundId="rbxassetid://1843671350" },
	{ id=4, name="Relaxante",       soundId="rbxassetid://1843671350" },
	{ id=5, name="Suspense",        soundId="rbxassetid://1843671350" },
}

musicListFn.OnServerInvoke = function() return Tracks end

playMusicEvent.OnServerEvent:Connect(function(player, trackId)
	local track = nil
	for _, t in ipairs(Tracks) do if t.id==trackId then track=t break end end
	if not track then return end
	-- Toca para todos
	for _, p in ipairs(Players:GetPlayers()) do
		musicBroadcast:FireClient(p, track.soundId, track.name)
	end
	print(("[Música] %s tocou: %s"):format(player.Name, track.name))
end)

stopMusicEvent.OnServerEvent:Connect(function(player)
	for _, p in ipairs(Players:GetPlayers()) do
		musicBroadcast:FireClient(p, nil, nil)
	end
end)
