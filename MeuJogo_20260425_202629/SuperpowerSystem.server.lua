local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local activatePowerEvent = Instance.new("RemoteEvent")    activatePowerEvent.Name = "ActivatePower"  activatePowerEvent.Parent = remotes
local buyPowerEvent      = Instance.new("RemoteEvent")    buyPowerEvent.Name      = "BuyPower"       buyPowerEvent.Parent      = remotes
local powerListFn        = Instance.new("RemoteFunction") powerListFn.Name        = "GetPowerList"   powerListFn.Parent        = remotes

local Powers = {
	{ id=1, name="Super Velocidade", price=5000,  effect="speed",    value=100, duration=10 },
	{ id=2, name="Super Força",      price=8000,  effect="strength", value=200, duration=15 },
	{ id=3, name="Invisibilidade",   price=10000, effect="invisible",value=0,   duration=20 },
	{ id=4, name="Voo",              price=15000, effect="fly",      value=50,  duration=30 },
	{ id=5, name="Imortalidade",     price=50000, effect="immortal", value=0,   duration=10 },
}

local playerPowers = {}
local activeCooldowns = {}

Players.PlayerAdded:Connect(function(p) playerPowers[p.UserId]={} activeCooldowns[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p) playerPowers[p.UserId]=nil activeCooldowns[p.UserId]=nil end)

powerListFn.OnServerInvoke = function(player)
	return Powers, playerPowers[player.UserId] or {}
end

buyPowerEvent.OnServerEvent:Connect(function(player, powerId)
	local power = nil
	for _, p in ipairs(Powers) do if p.id==powerId then power=p break end end
	if not power then return end
	if playerPowers[player.UserId][powerId] then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, power.price) end
	playerPowers[player.UserId][powerId] = true
	print(("[Superpoder] %s comprou %s"):format(player.Name, power.name))
end)

activatePowerEvent.OnServerEvent:Connect(function(player, powerId)
	local power = nil
	for _, p in ipairs(Powers) do if p.id==powerId then power=p break end end
	if not power then return end
	if not playerPowers[player.UserId][powerId] then return end
	if activeCooldowns[player.UserId][powerId] then return end

	activeCooldowns[player.UserId][powerId] = true
	local char = player.Character
	if not char then return end
	local hum = char:FindFirstChild("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")

	if power.effect == "speed" and hum then
		local orig = hum.WalkSpeed
		hum.WalkSpeed = power.value
		task.delay(power.duration, function() if hum then hum.WalkSpeed = orig end end)
	elseif power.effect == "fly" and root then
		local bg = Instance.new("BodyGyro") bg.MaxTorque=Vector3.new(1e5,1e5,1e5) bg.Parent=root
		local bv = Instance.new("BodyVelocity") bv.Velocity=Vector3.new(0,power.value,0) bv.MaxForce=Vector3.new(0,1e5,0) bv.Parent=root
		task.delay(power.duration, function() if bg.Parent then bg:Destroy() end if bv.Parent then bv:Destroy() end end)
	elseif power.effect == "immortal" and hum then
		hum.MaxHealth = 1e6 hum.Health = 1e6
		task.delay(power.duration, function() if hum then hum.MaxHealth=100 hum.Health=100 end end)
	end

	task.delay(power.duration + 30, function()
		activeCooldowns[player.UserId][powerId] = nil
	end)
	print(("[Superpoder] %s ativou %s"):format(player.Name, power.name))
end)
