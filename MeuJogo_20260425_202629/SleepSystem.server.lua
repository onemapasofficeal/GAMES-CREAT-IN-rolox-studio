local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sleepEvent  = Instance.new("RemoteEvent") sleepEvent.Name  = "Sleep"       sleepEvent.Parent  = remotes
local wakeEvent   = Instance.new("RemoteEvent") wakeEvent.Name   = "Wake"        wakeEvent.Parent   = remotes
local sleepUpdate = Instance.new("RemoteEvent") sleepUpdate.Name = "SleepUpdate" sleepUpdate.Parent = remotes

local playerSleep = {}  -- userId → { energy, sleeping }

Players.PlayerAdded:Connect(function(p)
	playerSleep[p.UserId] = { energy=100, sleeping=false }
	task.spawn(function()
		while playerSleep[p.UserId] do
			task.wait(15)
			local d = playerSleep[p.UserId]
			if not d then break end
			if not d.sleeping then
				d.energy = math.max(0, d.energy - 3)
				sleepUpdate:FireClient(p, d.energy, false)
				if d.energy == 0 then
					local char = p.Character
					if char then
						local hum = char:FindFirstChild("Humanoid")
						if hum then hum.WalkSpeed = 8 end
					end
				end
			end
		end
	end)
end)
Players.PlayerRemoving:Connect(function(p) playerSleep[p.UserId]=nil end)

sleepEvent.OnServerEvent:Connect(function(player)
	local d = playerSleep[player.UserId]
	if not d or d.sleeping then return end
	d.sleeping = true
	sleepUpdate:FireClient(player, d.energy, true)

	task.spawn(function()
		local duration = 30
		for i = 1, duration do
			task.wait(1)
			if not d.sleeping then break end
			d.energy = math.min(100, d.energy + (100/duration))
		end
		d.sleeping = false
		d.energy = 100
		sleepUpdate:FireClient(player, 100, false)
		local char = player.Character
		if char then
			local hum = char:FindFirstChild("Humanoid")
			if hum then hum.WalkSpeed = 16 end
		end
		print(("[Sono] %s acordou descansado"):format(player.Name))
	end)
end)

wakeEvent.OnServerEvent:Connect(function(player)
	local d = playerSleep[player.UserId]
	if d then d.sleeping = false end
end)
