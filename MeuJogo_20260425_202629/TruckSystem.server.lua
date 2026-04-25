local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buyTruckEvent  = Instance.new("RemoteEvent")    buyTruckEvent.Name  = "BuyTruck"    buyTruckEvent.Parent  = remotes
local driveTruckEvent= Instance.new("RemoteEvent")    driveTruckEvent.Name= "DriveTruck"  driveTruckEvent.Parent= remotes
local truckListFn    = Instance.new("RemoteFunction") truckListFn.Name    = "GetTruckList" truckListFn.Parent   = remotes

local Trucks = {
	{ id=1, name="Caminhonete",  price=12000, speed=80,  color=Color3.fromRGB(180,100,50) },
	{ id=2, name="Caminhão",     price=40000, speed=60,  color=Color3.fromRGB(50,80,50)   },
	{ id=3, name="Carreta",      price=100000,speed=50,  color=Color3.fromRGB(80,80,80)   },
}

local playerTrucks = {}
local spawnedTrucks = {}

truckListFn.OnServerInvoke = function() return Trucks end

Players.PlayerAdded:Connect(function(p) playerTrucks[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p)
	if spawnedTrucks[p.UserId] then spawnedTrucks[p.UserId]:Destroy() end
	playerTrucks[p.UserId]=nil spawnedTrucks[p.UserId]=nil
end)

buyTruckEvent.OnServerEvent:Connect(function(player, truckId)
	local truck = nil
	for _, t in ipairs(Trucks) do if t.id==truckId then truck=t break end end
	if not truck then return end
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, truck.price) end
	table.insert(playerTrucks[player.UserId], truckId)
	print(("[Caminhão] %s comprou %s"):format(player.Name, truck.name))
end)

driveTruckEvent.OnServerEvent:Connect(function(player, truckId)
	local truck = nil
	for _, t in ipairs(Trucks) do if t.id==truckId then truck=t break end end
	if not truck then return end
	if spawnedTrucks[player.UserId] then spawnedTrucks[player.UserId]:Destroy() end

	local char = player.Character
	if not char then return end
	local pos = char.HumanoidRootPart.Position + Vector3.new(15,0,0)

	local model = Instance.new("Model") model.Name="Truck_"..player.Name
	local body = Instance.new("Part") body.Size=Vector3.new(8,4,18) body.Position=pos body.Color=truck.color body.Material=Enum.Material.SmoothPlastic body.Anchored=false body.Parent=model
	local seat = Instance.new("VehicleSeat") seat.Size=Vector3.new(2,1,2) seat.Position=pos+Vector3.new(0,2.5,5) seat.MaxSpeed=truck.speed seat.Torque=40 seat.TurnSpeed=0.8 seat.Parent=model
	model.PrimaryPart = body
	model.Parent = Workspace
	spawnedTrucks[player.UserId] = model
end)
