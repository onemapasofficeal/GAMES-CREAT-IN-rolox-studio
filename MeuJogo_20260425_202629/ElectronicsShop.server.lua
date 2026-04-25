local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buyElecEvent = Instance.new("RemoteEvent")    buyElecEvent.Name = "BuyElectronics"  buyElecEvent.Parent = remotes
local elecListFn   = Instance.new("RemoteFunction") elecListFn.Name   = "GetElecList"     elecListFn.Parent   = remotes

local Electronics = {
	{ id=1,  name="Celular Básico",   price=500,   bonus="phone"    },
	{ id=2,  name="Smartphone",       price=2000,  bonus="phone+"   },
	{ id=3,  name="Laptop",           price=3000,  bonus="work+"    },
	{ id=4,  name="TV 50\"",          price=2500,  bonus="entertain"},
	{ id=5,  name="Console de Jogos", price=3500,  bonus="entertain"},
	{ id=6,  name="Câmera",           price=1500,  bonus="photo"    },
	{ id=7,  name="Drone",            price=5000,  bonus="drone"    },
	{ id=8,  name="Smartwatch",       price=800,   bonus="health"   },
	{ id=9,  name="Fone Bluetooth",   price=400,   bonus="music"    },
	{ id=10, name="Tablet",           price=1800,  bonus="work"     },
}

local playerElectronics = {}

Players.PlayerAdded:Connect(function(p) playerElectronics[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p) playerElectronics[p.UserId]=nil end)

elecListFn.OnServerInvoke = function(player)
	return Electronics, playerElectronics[player.UserId] or {}
end

buyElecEvent.OnServerEvent:Connect(function(player, itemId)
	local item = nil
	for _, e in ipairs(Electronics) do if e.id==itemId then item=e break end end
	if not item then return end
	if playerElectronics[player.UserId][itemId] then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, item.price) end
	playerElectronics[player.UserId][itemId] = true

	local addItem = remotes:FindFirstChild("AddItem")
	if addItem then addItem:FireServer(player, item.name, 1) end

	print(("[Eletrônicos] %s comprou %s"):format(player.Name, item.name))
end)
