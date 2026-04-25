local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local callTaxiEvent  = Instance.new("RemoteEvent")    callTaxiEvent.Name  = "CallTaxi"      callTaxiEvent.Parent  = remotes
local taxiListFn     = Instance.new("RemoteFunction") taxiListFn.Name     = "GetTaxiDests"  taxiListFn.Parent     = remotes

local Destinations = {
	{ name="Centro",      pos=Vector3.new(0,5,0),      price=50  },
	{ name="Hospital",    pos=Vector3.new(100,5,100),  price=80  },
	{ name="Banco",       pos=Vector3.new(-100,5,50),  price=70  },
	{ name="Aeroporto",   pos=Vector3.new(200,5,-200), price=150 },
	{ name="Praia",       pos=Vector3.new(-200,5,200), price=100 },
	{ name="Montanha",    pos=Vector3.new(150,30,150), price=120 },
	{ name="Cassino",     pos=Vector3.new(80,5,-80),   price=90  },
	{ name="Delegacia",   pos=Vector3.new(-80,5,-80),  price=60  },
}

taxiListFn.OnServerInvoke = function() return Destinations end

callTaxiEvent.OnServerEvent:Connect(function(player, destIndex)
	local dest = Destinations[destIndex]
	if not dest then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, dest.price) end

	task.wait(2)  -- "viagem"
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(dest.pos)
	end
	print(("[Táxi] %s foi para %s por R$%d"):format(player.Name, dest.name, dest.price))
end)
