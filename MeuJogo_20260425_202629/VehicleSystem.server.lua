-- VehicleSystem.server.lua
-- Sistema de veículos: comprar, entrar, sair

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buyCarEvent   = Instance.new("RemoteEvent")    buyCarEvent.Name   = "BuyCar"      buyCarEvent.Parent   = remotes
local enterCarEvent = Instance.new("RemoteEvent")    enterCarEvent.Name = "EnterCar"    enterCarEvent.Parent = remotes
local exitCarEvent  = Instance.new("RemoteEvent")    exitCarEvent.Name  = "ExitCar"     exitCarEvent.Parent  = remotes
local carListFn     = Instance.new("RemoteFunction") carListFn.Name     = "GetCarList"  carListFn.Parent     = remotes

local Cars = {
	{ id = 1, name = "Fusca",    price = 3000,  speed = 60,  color = Color3.fromRGB(200,200,50)  },
	{ id = 2, name = "Sedan",    price = 8000,  speed = 100, color = Color3.fromRGB(50,100,200)  },
	{ id = 3, name = "SUV",      price = 15000, speed = 120, color = Color3.fromRGB(80,80,80)    },
	{ id = 4, name = "Esportivo",price = 50000, speed = 200, color = Color3.fromRGB(200,30,30)   },
	{ id = 5, name = "Moto",     price = 2000,  speed = 80,  color = Color3.fromRGB(20,20,20)    },
}

local playerCars = {}  -- userId → lista de carIds comprados
local spawnedCars = {} -- userId → Model do carro atual

local function criarCarro(player, carData)
	local char = player.Character
	if not char then return end

	-- Remove carro anterior
	if spawnedCars[player.UserId] then
		spawnedCars[player.UserId]:Destroy()
	end

	local model = Instance.new("Model")
	model.Name = carData.name .. "_" .. player.Name

	local body = Instance.new("Part")
	body.Name = "Body"
	body.Size = Vector3.new(6, 2, 12)
	body.Position = char.HumanoidRootPart.Position + Vector3.new(10, 1, 0)
	body.Color = carData.color
	body.Material = Enum.Material.SmoothPlastic
	body.Parent = model

	-- Rodas
	for _, offset in ipairs({
		Vector3.new(3, -0.8, 4), Vector3.new(-3, -0.8, 4),
		Vector3.new(3, -0.8, -4), Vector3.new(-3, -0.8, -4)
	}) do
		local roda = Instance.new("Part")
		roda.Shape = Enum.PartType.Cylinder
		roda.Size = Vector3.new(0.5, 2, 2)
		roda.Position = body.Position + offset
		roda.Color = Color3.fromRGB(20,20,20)
		roda.Material = Enum.Material.SmoothPlastic
		roda.Parent = model
	end

	-- Assento
	local seat = Instance.new("VehicleSeat")
	seat.Size = Vector3.new(2, 1, 2)
	seat.Position = body.Position + Vector3.new(0, 1.5, 2)
	seat.MaxSpeed = carData.speed
	seat.Torque = 30
	seat.TurnSpeed = 1
	seat.Parent = model

	model.PrimaryPart = body
	model.Parent = Workspace

	spawnedCars[player.UserId] = model
	return model
end

carListFn.OnServerInvoke = function()
	return Cars
end

buyCarEvent.OnServerEvent:Connect(function(player, carId)
	local car = nil
	for _, v in ipairs(Cars) do if v.id == carId then car = v break end end
	if not car then return end

	playerCars[player.UserId] = playerCars[player.UserId] or {}
	for _, id in ipairs(playerCars[player.UserId]) do
		if id == carId then warn("[Veículos] Já possui esse carro") return end
	end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, car.price) end
	table.insert(playerCars[player.UserId], carId)
	print(("[Veículos] %s comprou %s"):format(player.Name, car.name))
end)

enterCarEvent.OnServerEvent:Connect(function(player, carId)
	local car = nil
	for _, v in ipairs(Cars) do if v.id == carId then car = v break end end
	if not car then return end
	criarCarro(player, car)
end)

exitCarEvent.OnServerEvent:Connect(function(player)
	if spawnedCars[player.UserId] then
		spawnedCars[player.UserId]:Destroy()
		spawnedCars[player.UserId] = nil
	end
end)

Players.PlayerRemoving:Connect(function(p)
	if spawnedCars[p.UserId] then spawnedCars[p.UserId]:Destroy() end
	playerCars[p.UserId] = nil
	spawnedCars[p.UserId] = nil
end)
