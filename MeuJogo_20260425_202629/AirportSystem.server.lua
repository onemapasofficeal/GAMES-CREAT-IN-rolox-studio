local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buyTicketEvent = Instance.new("RemoteEvent")    buyTicketEvent.Name = "BuyTicket"    buyTicketEvent.Parent = remotes
local flightListFn   = Instance.new("RemoteFunction") flightListFn.Name   = "GetFlightList" flightListFn.Parent   = remotes

local Flights = {
	{ id=1, name="Voo para Praia",    price=200,  dest=Vector3.new(-200,5,220) },
	{ id=2, name="Voo para Montanha", price=300,  dest=Vector3.new(150,80,150) },
	{ id=3, name="Voo para Cidade",   price=150,  dest=Vector3.new(0,5,0)      },
	{ id=4, name="Voo Internacional", price=1000, dest=Vector3.new(200,5,-200) },
}

-- Cria aeroporto
local airportFolder = Instance.new("Folder") airportFolder.Name="Airport" airportFolder.Parent=Workspace

local terminal = Instance.new("Part") terminal.Size=Vector3.new(60,15,40) terminal.Position=Vector3.new(200,7.5,-200) terminal.Anchored=true terminal.Color=Color3.fromRGB(220,220,220) terminal.Material=Enum.Material.SmoothPlastic terminal.Parent=airportFolder
local runway = Instance.new("Part") runway.Size=Vector3.new(20,0.2,200) runway.Position=Vector3.new(200,0.1,-100) runway.Anchored=true runway.Color=Color3.fromRGB(40,40,40) runway.Material=Enum.Material.SmoothPlastic runway.Parent=airportFolder

flightListFn.OnServerInvoke = function() return Flights end

buyTicketEvent.OnServerEvent:Connect(function(player, flightId)
	local flight = nil
	for _, f in ipairs(Flights) do if f.id==flightId then flight=f break end end
	if not flight then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, flight.price) end

	task.wait(3)
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(flight.dest)
	end
	print(("[Aeroporto] %s voou para %s"):format(player.Name, flight.name))
end)
