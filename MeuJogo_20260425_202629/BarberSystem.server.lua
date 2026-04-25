local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local hairEvent  = Instance.new("RemoteEvent")    hairEvent.Name  = "ChangeHair"   hairEvent.Parent  = remotes
local hairListFn = Instance.new("RemoteFunction") hairListFn.Name = "GetHairStyles" hairListFn.Parent = remotes

local HairStyles = {
	{ id=1, name="Careca",      price=0,   color=Color3.fromRGB(0,0,0)       },
	{ id=2, name="Curto",       price=50,  color=Color3.fromRGB(50,30,10)    },
	{ id=3, name="Médio",       price=80,  color=Color3.fromRGB(200,150,50)  },
	{ id=4, name="Longo",       price=100, color=Color3.fromRGB(30,30,30)    },
	{ id=5, name="Moicano",     price=150, color=Color3.fromRGB(200,50,50)   },
	{ id=6, name="Afro",        price=120, color=Color3.fromRGB(30,20,10)    },
	{ id=7, name="Colorido",    price=200, color=Color3.fromRGB(100,50,200)  },
}

hairListFn.OnServerInvoke = function() return HairStyles end

hairEvent.OnServerEvent:Connect(function(player, hairId)
	local hair = nil
	for _, h in ipairs(HairStyles) do if h.id==hairId then hair=h break end end
	if not hair then return end

	if hair.price > 0 then
		local removeMoney = remotes:FindFirstChild("RemoveMoney")
		if removeMoney then removeMoney:FireServer(player, hair.price) end
	end

	local char = player.Character
	if char then
		local head = char:FindFirstChild("Head")
		if head then head.Color = hair.color end
	end

	print(("[Barbearia] %s mudou cabelo para %s"):format(player.Name, hair.name))
end)
