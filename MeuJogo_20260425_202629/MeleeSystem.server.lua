local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local meleeEvent = Instance.new("RemoteEvent") meleeEvent.Name="MeleeAttack" meleeEvent.Parent=remotes
local hitEvent   = Instance.new("RemoteEvent") hitEvent.Name="MeleeHit"     hitEvent.Parent=remotes

local playerMelee = {}  -- userId → { weaponName, damage, lastAttack }

local MeleeDamage = {
	Faca=15, Bastão=20, Espada=40, Machado=35
}

Players.PlayerAdded:Connect(function(p)
	playerMelee[p.UserId] = { weaponName="Faca", damage=15, lastAttack=0 }
end)
Players.PlayerRemoving:Connect(function(p) playerMelee[p.UserId]=nil end)

meleeEvent.OnServerEvent:Connect(function(player, targetName)
	local data = playerMelee[player.UserId]
	if not data then return end

	local now = tick()
	if now - data.lastAttack < 0.5 then return end
	data.lastAttack = now

	local target = Players:FindFirstChild(targetName)
	if not target then return end

	local char = player.Character
	local targetChar = target.Character
	if not char or not targetChar then return end

	local root = char:FindFirstChild("HumanoidRootPart")
	local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
	if not root or not targetRoot then return end

	if (root.Position - targetRoot.Position).Magnitude > 6 then return end

	local hum = targetChar:FindFirstChild("Humanoid")
	if hum then
		hum.Health = math.max(0, hum.Health - data.damage)
		hitEvent:FireClient(target, player.Name, data.damage)
	end

	print(("[Melee] %s atacou %s por %d"):format(player.Name, targetName, data.damage))
end)
