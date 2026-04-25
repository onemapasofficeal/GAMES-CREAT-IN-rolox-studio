-- HouseSystem.server.lua
-- Sistema de casas: comprar, entrar, mobília básica

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buyHouseEvent  = Instance.new("RemoteEvent")    buyHouseEvent.Name  = "BuyHouse"     buyHouseEvent.Parent  = remotes
local enterHouseEvent= Instance.new("RemoteEvent")    enterHouseEvent.Name= "EnterHouse"   enterHouseEvent.Parent= remotes
local houseListFn    = Instance.new("RemoteFunction") houseListFn.Name    = "GetHouseList" houseListFn.Parent    = remotes

local Houses = {
	{ id = 1, name = "Kitnet",    price = 5000,  size = Vector3.new(20,10,20) },
	{ id = 2, name = "Casa Simples", price = 15000, size = Vector3.new(30,12,30) },
	{ id = 3, name = "Mansão",    price = 100000, size = Vector3.new(60,20,60) },
}

local playerHouses = {}  -- userId → houseId
local houseModels  = {}  -- userId → Model

local function construirCasa(player, houseData)
	if houseModels[player.UserId] then
		houseModels[player.UserId]:Destroy()
	end

	local char = player.Character
	local basePos = char and char.HumanoidRootPart.Position + Vector3.new(0, 0, 80) or Vector3.new(0,0,80)
	local s = houseData.size

	local model = Instance.new("Model")
	model.Name = "Casa_" .. player.Name

	local function addPart(size, pos, color, name)
		local p = Instance.new("Part")
		p.Name = name or "Part"
		p.Size = size
		p.Position = pos
		p.Anchored = true
		p.Material = Enum.Material.SmoothPlastic
		p.Color = color
		p.Parent = model
		return p
	end

	-- Chão
	addPart(Vector3.new(s.X, 0.5, s.Z), basePos + Vector3.new(0, 0, 0), Color3.fromRGB(200,180,150), "Floor")
	-- Paredes
	addPart(Vector3.new(s.X, s.Y, 0.5), basePos + Vector3.new(0, s.Y/2, s.Z/2),  Color3.fromRGB(240,230,210), "WallFront")
	addPart(Vector3.new(s.X, s.Y, 0.5), basePos + Vector3.new(0, s.Y/2, -s.Z/2), Color3.fromRGB(240,230,210), "WallBack")
	addPart(Vector3.new(0.5, s.Y, s.Z), basePos + Vector3.new(s.X/2, s.Y/2, 0),  Color3.fromRGB(240,230,210), "WallRight")
	addPart(Vector3.new(0.5, s.Y, s.Z), basePos + Vector3.new(-s.X/2, s.Y/2, 0), Color3.fromRGB(240,230,210), "WallLeft")
	-- Teto
	addPart(Vector3.new(s.X, 0.5, s.Z), basePos + Vector3.new(0, s.Y, 0), Color3.fromRGB(180,100,60), "Roof")
	-- Cama
	addPart(Vector3.new(4,1,6), basePos + Vector3.new(-s.X/2+4, 1, -s.Z/2+5), Color3.fromRGB(100,150,200), "Bed")
	-- Mesa
	addPart(Vector3.new(4,1,2), basePos + Vector3.new(0, 1, 0), Color3.fromRGB(150,100,50), "Table")
	-- Sofá
	addPart(Vector3.new(6,1.5,2), basePos + Vector3.new(s.X/2-5, 1.5, s.Z/2-5), Color3.fromRGB(80,60,40), "Sofa")

	-- Spawn dentro da casa
	local spawn = Instance.new("SpawnLocation")
	spawn.Position = basePos + Vector3.new(0, 1, 0)
	spawn.Size = Vector3.new(4,0.5,4)
	spawn.Anchored = true
	spawn.Parent = model

	model.Parent = Workspace
	houseModels[player.UserId] = model
end

houseListFn.OnServerInvoke = function()
	return Houses
end

buyHouseEvent.OnServerEvent:Connect(function(player, houseId)
	local house = nil
	for _, v in ipairs(Houses) do if v.id == houseId then house = v break end end
	if not house then return end
	if playerHouses[player.UserId] then warn("[Casa] Já possui uma casa") return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, house.price) end
	playerHouses[player.UserId] = houseId
	construirCasa(player, house)
	print(("[Casa] %s comprou %s"):format(player.Name, house.name))
end)

enterHouseEvent.OnServerEvent:Connect(function(player)
	local houseId = playerHouses[player.UserId]
	if not houseId then warn("[Casa] Sem casa") return end
	local house = nil
	for _, v in ipairs(Houses) do if v.id == houseId then house = v break end end
	if house and not houseModels[player.UserId] then
		construirCasa(player, house)
	end
end)

Players.PlayerAdded:Connect(function(p) playerHouses[p.UserId] = nil end)
Players.PlayerRemoving:Connect(function(p)
	playerHouses[p.UserId] = nil
	if houseModels[p.UserId] then houseModels[p.UserId]:Destroy() end
	houseModels[p.UserId] = nil
end)
