-- HungerThirst.server.lua
-- Sistema de fome e sede

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = ReplicatedStorage:WaitForChild("Remotes")

local updateStats = Instance.new("RemoteEvent")
updateStats.Name = "UpdateStats"
updateStats.Parent = remotes

local eatEvent = Instance.new("RemoteEvent")
eatEvent.Name = "Eat"
eatEvent.Parent = remotes

local drinkEvent = Instance.new("RemoteEvent")
drinkEvent.Name = "Drink"
drinkEvent.Parent = remotes

local playerStats = {}

Players.PlayerAdded:Connect(function(player)
	playerStats[player.UserId] = { hunger = 100, thirst = 100 }

	player.CharacterAdded:Connect(function(char)
		task.wait(1)
		updateStats:FireClient(player, playerStats[player.UserId])

		-- Diminui fome e sede ao longo do tempo
		task.spawn(function()
			while player.Parent and playerStats[player.UserId] do
				task.wait(10)
				local s = playerStats[player.UserId]
				s.hunger = math.max(0, s.hunger - 2)
				s.thirst = math.max(0, s.thirst - 3)
				updateStats:FireClient(player, s)

				-- Dano por fome/sede extrema
				if s.hunger == 0 or s.thirst == 0 then
					local hum = char:FindFirstChild("Humanoid")
					if hum then hum.Health = hum.Health - 5 end
				end
			end
		end)
	end)
end)

Players.PlayerRemoving:Connect(function(p) playerStats[p.UserId] = nil end)

eatEvent.OnServerEvent:Connect(function(player, amount)
	local s = playerStats[player.UserId]
	if not s then return end
	s.hunger = math.min(100, s.hunger + (amount or 30))
	updateStats:FireClient(player, s)
end)

drinkEvent.OnServerEvent:Connect(function(player, amount)
	local s = playerStats[player.UserId]
	if not s then return end
	s.thirst = math.min(100, s.thirst + (amount or 30))
	updateStats:FireClient(player, s)
end)
