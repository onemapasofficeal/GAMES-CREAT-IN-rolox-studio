local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local joinFireEvent    = Instance.new("RemoteEvent") joinFireEvent.Name    = "JoinFireDept"   joinFireEvent.Parent    = remotes
local extinguishEvent  = Instance.new("RemoteEvent") extinguishEvent.Name  = "Extinguish"     extinguishEvent.Parent  = remotes
local fireAlertEvent   = Instance.new("RemoteEvent") fireAlertEvent.Name   = "FireAlert"      fireAlertEvent.Parent   = remotes

local fireMembers = {}
local activeFires = {}

Players.PlayerAdded:Connect(function(p) fireMembers[p.UserId]=false end)
Players.PlayerRemoving:Connect(function(p) fireMembers[p.UserId]=nil end)

joinFireEvent.OnServerEvent:Connect(function(player)
	fireMembers[player.UserId] = true
	print(("[Bombeiros] %s entrou para os bombeiros"):format(player.Name))
end)

-- Spawna incêndios aleatórios
task.spawn(function()
	while true do
		task.wait(math.random(120, 300))
		local pos = Vector3.new(math.random(-150,150), 1, math.random(-150,150))
		local fire = Instance.new("Part")
		fire.Size = Vector3.new(3,3,3)
		fire.Position = pos
		fire.Anchored = true
		fire.Transparency = 1
		fire.Name = "FireZone"
		fire.Parent = Workspace

		local flame = Instance.new("Fire", fire)
		flame.Size = 8
		flame.Heat = 10

		table.insert(activeFires, fire)

		-- Alerta bombeiros
		for _, p in ipairs(Players:GetPlayers()) do
			if fireMembers[p.UserId] then
				fireAlertEvent:FireClient(p, pos)
			end
		end

		-- Auto-apaga após 5 min
		task.delay(300, function()
			if fire.Parent then fire:Destroy() end
			for i, f in ipairs(activeFires) do
				if f == fire then table.remove(activeFires, i) break end
			end
		end)
	end
end)

extinguishEvent.OnServerEvent:Connect(function(player)
	if not fireMembers[player.UserId] then return end
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	for i, fire in ipairs(activeFires) do
		if fire.Parent and (fire.Position - root.Position).Magnitude < 15 then
			fire:Destroy()
			table.remove(activeFires, i)
			local addMoney = remotes:FindFirstChild("AddMoney")
			local addXP    = remotes:FindFirstChild("AddXP")
			if addMoney then addMoney:FireServer(player, 300) end
			if addXP    then addXP:FireServer(player, 50) end
			print(("[Bombeiros] %s apagou incêndio"):format(player.Name))
			return
		end
	end
end)
