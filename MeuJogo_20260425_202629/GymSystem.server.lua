local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local workoutEvent = Instance.new("RemoteEvent")    workoutEvent.Name = "Workout"       workoutEvent.Parent = remotes
local gymListFn    = Instance.new("RemoteFunction") gymListFn.Name    = "GetGymList"    gymListFn.Parent    = remotes

local Exercises = {
	{ name="Flexão",      cooldown=30,  hpBonus=10, xp=8  },
	{ name="Corrida",     cooldown=45,  hpBonus=15, xp=12 },
	{ name="Musculação",  cooldown=60,  hpBonus=20, xp=18 },
	{ name="Natação",     cooldown=50,  hpBonus=18, xp=15 },
	{ name="Yoga",        cooldown=40,  hpBonus=12, xp=10 },
	{ name="Boxe",        cooldown=55,  hpBonus=25, xp=22 },
}

local playerWorkouts = {}  -- userId → { exerciseIndex → lastTime }

Players.PlayerAdded:Connect(function(p) playerWorkouts[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p) playerWorkouts[p.UserId]=nil end)

gymListFn.OnServerInvoke = function() return Exercises end

workoutEvent.OnServerEvent:Connect(function(player, exerciseIndex)
	local ex = Exercises[exerciseIndex]
	if not ex then return end

	local pw = playerWorkouts[player.UserId]
	local now = tick()
	if pw[exerciseIndex] and now - pw[exerciseIndex] < ex.cooldown then
		warn(("[Gym] %s precisa esperar"):format(player.Name))
		return
	end
	pw[exerciseIndex] = now

	local char = player.Character
	if char then
		local hum = char:FindFirstChild("Humanoid")
		if hum then
			hum.MaxHealth = math.min(200, hum.MaxHealth + ex.hpBonus)
			hum.Health = hum.MaxHealth
		end
	end

	local addXP = remotes:FindFirstChild("AddXP")
	if addXP then addXP:FireServer(player, ex.xp) end
	print(("[Gym] %s fez %s (+%d HP)"):format(player.Name, ex.name, ex.hpBonus))
end)
