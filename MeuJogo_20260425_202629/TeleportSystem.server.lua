local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local teleportEvent = Instance.new("RemoteEvent")    teleportEvent.Name = "TeleportTo"    teleportEvent.Parent = remotes
local waypointListFn= Instance.new("RemoteFunction") waypointListFn.Name= "GetWaypoints"  waypointListFn.Parent= remotes

local Waypoints = {
	{ name="Centro",       pos=Vector3.new(0,5,0),       icon="🏙" },
	{ name="Hospital",     pos=Vector3.new(100,5,100),   icon="🏥" },
	{ name="Banco",        pos=Vector3.new(-100,5,50),   icon="🏦" },
	{ name="Delegacia",    pos=Vector3.new(-80,5,-80),   icon="👮" },
	{ name="Aeroporto",    pos=Vector3.new(200,5,-200),  icon="✈" },
	{ name="Praia",        pos=Vector3.new(-200,5,200),  icon="🏖" },
	{ name="Fazenda",      pos=Vector3.new(150,5,150),   icon="🌾" },
	{ name="Mina",         pos=Vector3.new(-150,5,-150), icon="⛏" },
	{ name="Cassino",      pos=Vector3.new(80,5,-80),    icon="🎰" },
	{ name="Escola",       pos=Vector3.new(-60,5,120),   icon="🏫" },
	{ name="Ginásio",      pos=Vector3.new(60,5,-120),   icon="💪" },
	{ name="Restaurante",  pos=Vector3.new(30,5,60),     icon="🍽" },
}

waypointListFn.OnServerInvoke = function() return Waypoints end

teleportEvent.OnServerEvent:Connect(function(player, waypointIndex)
	local wp = Waypoints[waypointIndex]
	if not wp then return end

	-- Cobra taxa de teleporte
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, 25) end

	task.wait(0.5)
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(wp.pos)
	end
	print(("[Teleporte] %s → %s"):format(player.Name, wp.name))
end)
