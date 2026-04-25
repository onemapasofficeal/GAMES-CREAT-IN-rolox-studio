local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local moodUpdate = Instance.new("RemoteEvent") moodUpdate.Name="MoodUpdate" moodUpdate.Parent=remotes
local getMoodFn  = Instance.new("RemoteFunction") getMoodFn.Name="GetMood" getMoodFn.Parent=remotes

local Moods = {
	{ name="Feliz",      icon="😊", walkSpeedBonus=2,  xpBonus=0.1  },
	{ name="Normal",     icon="😐", walkSpeedBonus=0,  xpBonus=0    },
	{ name="Triste",     icon="😢", walkSpeedBonus=-2, xpBonus=-0.1 },
	{ name="Animado",    icon="🤩", walkSpeedBonus=4,  xpBonus=0.2  },
	{ name="Cansado",    icon="😴", walkSpeedBonus=-4, xpBonus=-0.2 },
	{ name="Irritado",   icon="😠", walkSpeedBonus=0,  xpBonus=0    },
}

local playerMood = {}

Players.PlayerAdded:Connect(function(p)
	playerMood[p.UserId] = 2  -- Normal
	task.spawn(function()
		while playerMood[p.UserId] do
			task.wait(60)
			-- Humor muda aleatoriamente
			local newMood = math.random(1, #Moods)
			playerMood[p.UserId] = newMood
			moodUpdate:FireClient(p, Moods[newMood])

			-- Aplica efeito
			local char = p.Character
			if char then
				local hum = char:FindFirstChild("Humanoid")
				if hum then
					hum.WalkSpeed = math.max(8, 16 + Moods[newMood].walkSpeedBonus)
				end
			end
		end
	end)
end)
Players.PlayerRemoving:Connect(function(p) playerMood[p.UserId]=nil end)

getMoodFn.OnServerInvoke = function(player)
	local moodIdx = playerMood[player.UserId] or 2
	return Moods[moodIdx]
end
