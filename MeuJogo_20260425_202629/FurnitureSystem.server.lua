local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buyFurnitureEvent   = Instance.new("RemoteEvent")    buyFurnitureEvent.Name   = "BuyFurniture"   buyFurnitureEvent.Parent   = remotes
local placeFurnitureEvent = Instance.new("RemoteEvent")    placeFurnitureEvent.Name = "PlaceFurniture" placeFurnitureEvent.Parent = remotes
local furnitureListFn     = Instance.new("RemoteFunction") furnitureListFn.Name     = "GetFurnitureList" furnitureListFn.Parent   = remotes

local Furniture = {
	{ id=1,  name="Sofá",          price=500,  size=Vector3.new(6,2,2),  color=Color3.fromRGB(80,60,40)   },
	{ id=2,  name="Cama de Casal", price=800,  size=Vector3.new(4,1,6),  color=Color3.fromRGB(100,150,200)},
	{ id=3,  name="Mesa de Jantar",price=400,  size=Vector3.new(4,1,2),  color=Color3.fromRGB(150,100,50) },
	{ id=4,  name="Geladeira",     price=1200, size=Vector3.new(2,4,2),  color=Color3.fromRGB(220,220,220)},
	{ id=5,  name="TV",            price=1500, size=Vector3.new(4,2,0.3),color=Color3.fromRGB(20,20,20)   },
	{ id=6,  name="Armário",       price=600,  size=Vector3.new(3,4,1),  color=Color3.fromRGB(150,100,50) },
	{ id=7,  name="Banheira",      price=2000, size=Vector3.new(4,2,6),  color=Color3.fromRGB(240,240,240)},
	{ id=8,  name="Estante",       price=300,  size=Vector3.new(3,4,0.5),color=Color3.fromRGB(150,100,50) },
}

local playerFurniture = {}

Players.PlayerAdded:Connect(function(p) playerFurniture[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p) playerFurniture[p.UserId]=nil end)

furnitureListFn.OnServerInvoke = function(player)
	return Furniture, playerFurniture[player.UserId] or {}
end

buyFurnitureEvent.OnServerEvent:Connect(function(player, furnitureId)
	local item = nil
	for _, f in ipairs(Furniture) do if f.id==furnitureId then item=f break end end
	if not item then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, item.price) end
	playerFurniture[player.UserId][furnitureId] = (playerFurniture[player.UserId][furnitureId] or 0) + 1
	print(("[Móveis] %s comprou %s"):format(player.Name, item.name))
end)

placeFurnitureEvent.OnServerEvent:Connect(function(player, furnitureId)
	local item = nil
	for _, f in ipairs(Furniture) do if f.id==furnitureId then item=f break end end
	if not item then return end
	if not playerFurniture[player.UserId][furnitureId] or playerFurniture[player.UserId][furnitureId] <= 0 then return end

	local char = player.Character
	if not char then return end
	local pos = char.HumanoidRootPart.Position + Vector3.new(0,0,5)

	local part = Instance.new("Part") part.Size=item.size part.Position=pos part.Anchored=true part.Color=item.color part.Material=Enum.Material.SmoothPlastic part.Name=item.name part.Parent=Workspace

	playerFurniture[player.UserId][furnitureId] -= 1
	print(("[Móveis] %s colocou %s"):format(player.Name, item.name))
end)
