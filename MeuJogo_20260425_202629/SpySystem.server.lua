local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local spyEvent    = Instance.new("RemoteEvent")    spyEvent.Name    = "SpyPlayer"   spyEvent.Parent    = remotes
local spyResult   = Instance.new("RemoteEvent")    spyResult.Name   = "SpyResult"   spyResult.Parent   = remotes
local disguiseEvent=Instance.new("RemoteEvent")    disguiseEvent.Name="Disguise"    disguiseEvent.Parent=remotes

local spyGadgets = {
	{ name="Câmera Oculta",  price=500,  cooldown=30  },
	{ name="Microfone",      price=300,  cooldown=20  },
	{ name="GPS Tracker",    price=800,  cooldown=60  },
	{ name="Disfarce",       price=200,  cooldown=120 },
}

local playerSpy = {}
local disguised = {}

Players.PlayerAdded:Connect(function(p) playerSpy[p.UserId]={} disguised[p.UserId]=false end)
Players.PlayerRemoving:Connect(function(p) playerSpy[p.UserId]=nil disguised[p.UserId]=nil end)

spyEvent.OnServerEvent:Connect(function(player, targetName, gadgetIndex)
	local gadget = spyGadgets[gadgetIndex]
	if not gadget then return end

	local target = Players:FindFirstChild(targetName)
	if not target then return end

	local now = tick()
	if playerSpy[player.UserId][gadgetIndex] and now - playerSpy[player.UserId][gadgetIndex] < gadget.cooldown then return end
	playerSpy[player.UserId][gadgetIndex] = now

	-- Coleta info do alvo
	local ls = target:FindFirstChild("leaderstats")
	local money = ls and ls:FindFirstChild("Dinheiro") and ls.Dinheiro.Value or 0
	local level = ls and ls:FindFirstChild("Nível") and ls["Nível"].Value or 1

	spyResult:FireClient(player, {
		name = target.Name,
		money = money,
		level = level,
		position = target.Character and target.Character:FindFirstChild("HumanoidRootPart") and target.Character.HumanoidRootPart.Position or Vector3.new()
	})
	print(("[Espião] %s espionou %s"):format(player.Name, target.Name))
end)

disguiseEvent.OnServerEvent:Connect(function(player)
	disguised[player.UserId] = not disguised[player.UserId]
	local char = player.Character
	if char then
		local head = char:FindFirstChild("Head")
		if head then
			head.Color = disguised[player.UserId] and Color3.fromRGB(50,50,50) or Color3.fromRGB(255,220,185)
		end
	end
	print(("[Espião] %s %s"):format(player.Name, disguised[player.UserId] and "se disfarçou" or "removeu disfarce"))
end)
