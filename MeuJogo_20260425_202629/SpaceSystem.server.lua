local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local launchEvent  = Instance.new("RemoteEvent")    launchEvent.Name  = "LaunchRocket"  launchEvent.Parent  = remotes
local returnEvent  = Instance.new("RemoteEvent")    returnEvent.Name  = "ReturnEarth"   returnEvent.Parent  = remotes
local spaceListFn  = Instance.new("RemoteFunction") spaceListFn.Name  = "GetSpaceList"  spaceListFn.Parent  = remotes

local Rockets = {
	{ id=1, name="Foguete Básico",  price=50000,  destination="Órbita"  },
	{ id=2, name="Nave Lunar",      price=200000, destination="Lua"     },
	{ id=3, name="Nave Marciana",   price=500000, destination="Marte"   },
}

local inSpace = {}

Players.PlayerAdded:Connect(function(p) inSpace[p.UserId]=false end)
Players.PlayerRemoving:Connect(function(p) inSpace[p.UserId]=nil end)

spaceListFn.OnServerInvoke = function() return Rockets end

launchEvent.OnServerEvent:Connect(function(player, rocketId)
	local rocket = nil
	for _, r in ipairs(Rockets) do if r.id==rocketId then rocket=r break end end
	if not rocket then return end
	if inSpace[player.UserId] then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, rocket.price) end

	inSpace[player.UserId] = true

	-- Teleporta para o espaço (altitude alta)
	task.wait(3)
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(0, 5000, 0)
	end

	-- Recompensa por exploração espacial
	local addMoney = remotes:FindFirstChild("AddMoney")
	local addXP    = remotes:FindFirstChild("AddXP")
	if addMoney then addMoney:FireServer(player, rocket.price * 0.5) end
	if addXP    then addXP:FireServer(player, 500) end

	print(("[Espaço] %s foi para %s"):format(player.Name, rocket.destination))
end)

returnEvent.OnServerEvent:Connect(function(player)
	inSpace[player.UserId] = false
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(0, 5, 0)
	end
	print(("[Espaço] %s voltou para a Terra"):format(player.Name))
end)
