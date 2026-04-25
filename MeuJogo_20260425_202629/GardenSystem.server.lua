local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local plantFlowerEvent = Instance.new("RemoteEvent")    plantFlowerEvent.Name = "PlantFlower"   plantFlowerEvent.Parent = remotes
local gardenListFn     = Instance.new("RemoteFunction") gardenListFn.Name     = "GetGardenList" gardenListFn.Parent     = remotes

local Flowers = {
	{ id=1, name="Rosa",      price=20,  color=Color3.fromRGB(220,50,80),  xp=5  },
	{ id=2, name="Girassol",  price=15,  color=Color3.fromRGB(255,200,0),  xp=4  },
	{ id=3, name="Tulipa",    price=25,  color=Color3.fromRGB(200,50,200), xp=6  },
	{ id=4, name="Orquídea",  price=80,  color=Color3.fromRGB(150,50,200), xp=15 },
	{ id=5, name="Margarida", price=10,  color=Color3.fromRGB(255,255,200),xp=3  },
}

local gardenFolder = Instance.new("Folder") gardenFolder.Name="Garden" gardenFolder.Parent=Workspace

gardenListFn.OnServerInvoke = function() return Flowers end

plantFlowerEvent.OnServerEvent:Connect(function(player, flowerId)
	local flower = nil
	for _, f in ipairs(Flowers) do if f.id==flowerId then flower=f break end end
	if not flower then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, flower.price) end

	local char = player.Character
	if not char then return end
	local pos = char.HumanoidRootPart.Position + Vector3.new(math.random(-3,3), 0, math.random(2,5))

	local stem = Instance.new("Part") stem.Size=Vector3.new(0.2,1,0.2) stem.Position=pos+Vector3.new(0,0.5,0) stem.Anchored=true stem.Color=Color3.fromRGB(50,150,50) stem.Material=Enum.Material.SmoothPlastic stem.Parent=gardenFolder
	local bloom = Instance.new("Part") bloom.Shape=Enum.PartType.Ball bloom.Size=Vector3.new(1,1,1) bloom.Position=pos+Vector3.new(0,1.5,0) bloom.Anchored=true bloom.Color=flower.color bloom.Material=Enum.Material.SmoothPlastic bloom.Parent=gardenFolder

	local addXP = remotes:FindFirstChild("AddXP")
	if addXP then addXP:FireServer(player, flower.xp) end
	print(("[Jardim] %s plantou %s"):format(player.Name, flower.name))
end)
