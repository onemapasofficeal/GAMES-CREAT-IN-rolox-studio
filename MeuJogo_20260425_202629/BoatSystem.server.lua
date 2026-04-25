local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buyBoatEvent  = Instance.new("RemoteEvent")    buyBoatEvent.Name  = "BuyBoat"     buyBoatEvent.Parent  = remotes
local enterBoatEvent= Instance.new("RemoteEvent")    enterBoatEvent.Name= "EnterBoat"   enterBoatEvent.Parent= remotes
local boatListFn    = Instance.new("RemoteFunction") boatListFn.Name    = "GetBoatList" boatListFn.Parent    = remotes

local Boats = {
	{ id=1, name="Canoa",     price=1000,  speed=20, color=Color3.fromRGB(150,100,50)  },
	{ id=2, name="Lancha",    price=8000,  speed=60, color=Color3.fromRGB(255,255,255) },
	{ id=3, name="Iate",      price=50000, speed=80, color=Color3.fromRGB(200,200,255) },
	{ id=4, name="Navio",     price=200000,speed=40, color=Color3.fromRGB(80,80,80)    },
}

local playerBoats = {}
local spawnedBoats = {}

boatListFn.OnServerInvoke = function() return Boats end

Players.PlayerAdded:Connect(function(p) playerBoats[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p)
	if spawnedBoats[p.UserId] then spawnedBoats[p.UserId]:Destroy() end
	playerBoats[p.UserId]=nil spawnedBoats[p.UserId]=nil
end)

buyBoatEvent.OnServerEvent:Connect(function(player, boatId)
	local boat = nil
	for _, b in ipairs(Boats) do if b.id==boatId then boat=b break end end
	if not boat then return end
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, boat.price) end
	table.insert(playerBoats[player.UserId], boatId)
	print(("[Barco] %s comprou %s"):format(player.Name, boat.name))
end)

enterBoatEvent.OnServerEvent:Connect(function(player, boatId)
	local boat = nil
	for _, b in ipairs(Boats) do if b.id==boatId then boat=b break end end
	if not boat then return end
	if spawnedBoats[player.UserId] then spawnedBoats[player.UserId]:Destroy() end

	local char = player.Character
	if not char then return end
	local pos = char.HumanoidRootPart.Position + Vector3.new(0,0,20)

	local model = Instance.new("Model") model.Name="Boat_"..player.Name
	local hull = Instance.new("Part") hull.Size=Vector3.new(8,2,16) hull.Position=pos hull.Color=boat.color hull.Material=Enum.Material.SmoothPlastic hull.Anchored=false hull.Parent=model
	local seat = Instance.new("VehicleSeat") seat.Size=Vector3.new(2,1,2) seat.Position=pos+Vector3.new(0,1.5,0) seat.MaxSpeed=boat.speed seat.Torque=20 seat.TurnSpeed=0.5 seat.Parent=model
	model.PrimaryPart = hull
	model.Parent = Workspace
	spawnedBoats[player.UserId] = model
end)
