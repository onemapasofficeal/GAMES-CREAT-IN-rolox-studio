local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buyClothingEvent  = Instance.new("RemoteEvent")    buyClothingEvent.Name  = "BuyClothing"    buyClothingEvent.Parent  = remotes
local wearClothingEvent = Instance.new("RemoteEvent")    wearClothingEvent.Name = "WearClothing"   wearClothingEvent.Parent = remotes
local clothingListFn    = Instance.new("RemoteFunction") clothingListFn.Name    = "GetClothingList" clothingListFn.Parent   = remotes

local Clothing = {
	{ id=1,  name="Camiseta Branca",  price=50,   type="shirt",  color=Color3.fromRGB(255,255,255) },
	{ id=2,  name="Calça Jeans",      price=80,   type="pants",  color=Color3.fromRGB(50,80,150)   },
	{ id=3,  name="Terno",            price=500,  type="shirt",  color=Color3.fromRGB(30,30,30)    },
	{ id=4,  name="Uniforme Policial",price=0,    type="shirt",  color=Color3.fromRGB(30,50,120)   },
	{ id=5,  name="Jaleco Médico",    price=0,    type="shirt",  color=Color3.fromRGB(240,240,240) },
	{ id=6,  name="Moletom",          price=120,  type="shirt",  color=Color3.fromRGB(80,80,80)    },
	{ id=7,  name="Vestido",          price=150,  type="shirt",  color=Color3.fromRGB(220,100,150) },
	{ id=8,  name="Shorts",           price=60,   type="pants",  color=Color3.fromRGB(100,180,100) },
	{ id=9,  name="Chapéu Cowboy",    price=200,  type="hat",    color=Color3.fromRGB(150,100,50)  },
	{ id=10, name="Óculos de Sol",    price=100,  type="hat",    color=Color3.fromRGB(20,20,20)    },
}

local playerWardrobe = {}  -- userId → set of clothingIds

Players.PlayerAdded:Connect(function(p) playerWardrobe[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p) playerWardrobe[p.UserId]=nil end)

clothingListFn.OnServerInvoke = function(player)
	return Clothing, playerWardrobe[player.UserId] or {}
end

buyClothingEvent.OnServerEvent:Connect(function(player, clothingId)
	local item = nil
	for _, c in ipairs(Clothing) do if c.id==clothingId then item=c break end end
	if not item then return end
	if playerWardrobe[player.UserId][clothingId] then return end
	if item.price > 0 then
		local removeMoney = remotes:FindFirstChild("RemoveMoney")
		if removeMoney then removeMoney:FireServer(player, item.price) end
	end
	playerWardrobe[player.UserId][clothingId] = true
	print(("[Roupa] %s comprou %s"):format(player.Name, item.name))
end)

wearClothingEvent.OnServerEvent:Connect(function(player, clothingId)
	local item = nil
	for _, c in ipairs(Clothing) do if c.id==clothingId then item=c break end end
	if not item then return end
	if not playerWardrobe[player.UserId][clothingId] then return end

	local char = player.Character
	if not char then return end

	-- Muda cor do torso como representação visual
	local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
	if torso and item.type=="shirt" then
		torso.Color = item.color
	end
	print(("[Roupa] %s vestiu %s"):format(player.Name, item.name))
end)
