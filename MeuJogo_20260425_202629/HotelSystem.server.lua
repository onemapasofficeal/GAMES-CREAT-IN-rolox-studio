local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local checkInEvent  = Instance.new("RemoteEvent")    checkInEvent.Name  = "HotelCheckIn"  checkInEvent.Parent  = remotes
local checkOutEvent = Instance.new("RemoteEvent")    checkOutEvent.Name = "HotelCheckOut" checkOutEvent.Parent = remotes
local hotelListFn   = Instance.new("RemoteFunction") hotelListFn.Name   = "GetHotelList"  hotelListFn.Parent   = remotes

local Rooms = {
	{ id=1, name="Quarto Simples",  price=100, energyBonus=30, hungerBonus=10 },
	{ id=2, name="Quarto Duplo",    price=250, energyBonus=60, hungerBonus=20 },
	{ id=3, name="Suite",           price=600, energyBonus=100,hungerBonus=40 },
	{ id=4, name="Suite Presidencial",price=2000,energyBonus=100,hungerBonus=60},
}

local playerRooms = {}

Players.PlayerAdded:Connect(function(p) playerRooms[p.UserId]=nil end)
Players.PlayerRemoving:Connect(function(p) playerRooms[p.UserId]=nil end)

hotelListFn.OnServerInvoke = function() return Rooms end

checkInEvent.OnServerEvent:Connect(function(player, roomId)
	local room = nil
	for _, r in ipairs(Rooms) do if r.id==roomId then room=r break end end
	if not room then return end
	if playerRooms[player.UserId] then warn("[Hotel] Já hospedado") return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, room.price) end
	playerRooms[player.UserId] = roomId

	-- Teleporta para o hotel
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(120, 5, 120)
	end

	-- Restaura energia e fome
	local sleepUpdate = remotes:FindFirstChild("SleepUpdate")
	local updateStats = remotes:FindFirstChild("UpdateStats")
	task.wait(1)
	if sleepUpdate then sleepUpdate:FireClient(player, 100, false) end

	print(("[Hotel] %s fez check-in no %s"):format(player.Name, room.name))
end)

checkOutEvent.OnServerEvent:Connect(function(player)
	playerRooms[player.UserId] = nil
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(0, 5, 0)
	end
	print(("[Hotel] %s fez check-out"):format(player.Name))
end)
