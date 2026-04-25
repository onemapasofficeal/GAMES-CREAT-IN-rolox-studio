local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buyBikeEvent  = Instance.new("RemoteEvent")    buyBikeEvent.Name  = "BuyBike"    buyBikeEvent.Parent  = remotes
local rideBikeEvent = Instance.new("RemoteEvent")    rideBikeEvent.Name = "RideBike"   rideBikeEvent.Parent = remotes
local bikeListFn    = Instance.new("RemoteFunction") bikeListFn.Name    = "GetBikeList" bikeListFn.Parent   = remotes

local Bikes = {
	{ id=1, name="Bicicleta",    price=200,  speed=20, color=Color3.fromRGB(200,50,50)  },
	{ id=2, name="Patinete",     price=150,  speed=15, color=Color3.fromRGB(50,50,200)  },
	{ id=3, name="Skate",        price=100,  speed=18, color=Color3.fromRGB(50,200,50)  },
	{ id=4, name="Bicicleta MTB",price=800,  speed=28, color=Color3.fromRGB(80,40,20)   },
}

local playerBikes = {}
local spawnedBikes = {}

bikeListFn.OnServerInvoke = function() return Bikes end

Players.PlayerAdded:Connect(function(p) playerBikes[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p)
	if spawnedBikes[p.UserId] then spawnedBikes[p.UserId]:Destroy() end
	playerBikes[p.UserId]=nil spawnedBikes[p.UserId]=nil
end)

buyBikeEvent.OnServerEvent:Connect(function(player, bikeId)
	local bike = nil
	for _, b in ipairs(Bikes) do if b.id==bikeId then bike=b break end end
	if not bike then return end
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, bike.price) end
	table.insert(playerBikes[player.UserId], bikeId)
	print(("[Bike] %s comprou %s"):format(player.Name, bike.name))
end)

rideBikeEvent.OnServerEvent:Connect(function(player, bikeId)
	local bike = nil
	for _, b in ipairs(Bikes) do if b.id==bikeId then bike=b break end end
	if not bike then return end
	if spawnedBikes[player.UserId] then spawnedBikes[player.UserId]:Destroy() end

	local char = player.Character
	if not char then return end
	local pos = char.HumanoidRootPart.Position + Vector3.new(3,0,0)

	local model = Instance.new("Model") model.Name="Bike_"..player.Name
	local frame = Instance.new("Part") frame.Size=Vector3.new(1,1,3) frame.Position=pos frame.Color=bike.color frame.Material=Enum.Material.SmoothPlastic frame.Anchored=false frame.Parent=model
	local seat = Instance.new("VehicleSeat") seat.Size=Vector3.new(1,0.5,1) seat.Position=pos+Vector3.new(0,1,0) seat.MaxSpeed=bike.speed seat.Torque=10 seat.TurnSpeed=1.5 seat.Parent=model
	model.PrimaryPart = frame
	model.Parent = Workspace
	spawnedBikes[player.UserId] = model
end)
