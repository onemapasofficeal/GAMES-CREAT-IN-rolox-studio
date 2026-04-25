local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buyPlaneEvent  = Instance.new("RemoteEvent")    buyPlaneEvent.Name  = "BuyPlane"    buyPlaneEvent.Parent  = remotes
local enterPlaneEvent= Instance.new("RemoteEvent")    enterPlaneEvent.Name= "EnterPlane"  enterPlaneEvent.Parent= remotes
local planeListFn    = Instance.new("RemoteFunction") planeListFn.Name    = "GetPlaneList" planeListFn.Parent   = remotes

local Planes = {
	{ id=1, name="Avião Leve",    price=30000,  speed=150, color=Color3.fromRGB(255,255,255) },
	{ id=2, name="Helicóptero",   price=80000,  speed=100, color=Color3.fromRGB(50,50,50)   },
	{ id=3, name="Jato Privado",  price=500000, speed=300, color=Color3.fromRGB(200,200,255) },
}

local playerPlanes = {}
local spawnedPlanes = {}

planeListFn.OnServerInvoke = function() return Planes end

Players.PlayerAdded:Connect(function(p) playerPlanes[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p)
	if spawnedPlanes[p.UserId] then spawnedPlanes[p.UserId]:Destroy() end
	playerPlanes[p.UserId]=nil spawnedPlanes[p.UserId]=nil
end)

buyPlaneEvent.OnServerEvent:Connect(function(player, planeId)
	local plane = nil
	for _, pl in ipairs(Planes) do if pl.id==planeId then plane=pl break end end
	if not plane then return end
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, plane.price) end
	table.insert(playerPlanes[player.UserId], planeId)
	print(("[Avião] %s comprou %s"):format(player.Name, plane.name))
end)

enterPlaneEvent.OnServerEvent:Connect(function(player, planeId)
	local plane = nil
	for _, pl in ipairs(Planes) do if pl.id==planeId then plane=pl break end end
	if not plane then return end
	if spawnedPlanes[player.UserId] then spawnedPlanes[player.UserId]:Destroy() end

	local char = player.Character
	if not char then return end
	local pos = char.HumanoidRootPart.Position + Vector3.new(0,20,0)

	local model = Instance.new("Model") model.Name="Plane_"..player.Name
	local body = Instance.new("Part") body.Size=Vector3.new(6,3,20) body.Position=pos body.Color=plane.color body.Material=Enum.Material.SmoothPlastic body.Anchored=false body.Parent=model
	local seat = Instance.new("VehicleSeat") seat.Size=Vector3.new(2,1,2) seat.Position=pos+Vector3.new(0,2,0) seat.MaxSpeed=plane.speed seat.Torque=50 seat.TurnSpeed=1 seat.Parent=model
	model.PrimaryPart = body
	model.Parent = Workspace
	spawnedPlanes[player.UserId] = model
end)
