local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local joinRaceEvent    = Instance.new("RemoteEvent")    joinRaceEvent.Name    = "JoinRace"     joinRaceEvent.Parent    = remotes
local raceStartEvent   = Instance.new("RemoteEvent")    raceStartEvent.Name   = "RaceStart"    raceStartEvent.Parent   = remotes
local raceFinishEvent  = Instance.new("RemoteEvent")    raceFinishEvent.Name  = "RaceFinish"   raceFinishEvent.Parent  = remotes
local checkpointEvent  = Instance.new("RemoteEvent")    checkpointEvent.Name  = "Checkpoint"   checkpointEvent.Parent  = remotes

local raceFolder = Instance.new("Folder") raceFolder.Name="Race" raceFolder.Parent=Workspace

-- Checkpoints da corrida
local Checkpoints = {
	Vector3.new(0,1,0), Vector3.new(50,1,0), Vector3.new(50,1,50),
	Vector3.new(0,1,50), Vector3.new(-50,1,50), Vector3.new(-50,1,0),
}

for i, pos in ipairs(Checkpoints) do
	local cp = Instance.new("Part") cp.Size=Vector3.new(8,4,0.5) cp.Position=pos cp.Anchored=true cp.Color=Color3.fromRGB(255,200,0) cp.Transparency=0.5 cp.CanCollide=false cp.Name="Checkpoint_"..i cp.Parent=raceFolder
	local lbl = Instance.new("BillboardGui",cp) lbl.Size=UDim2.new(0,60,0,30) lbl.StudsOffset=Vector3.new(0,3,0)
	local txt = Instance.new("TextLabel",lbl) txt.Size=UDim2.new(1,0,1,0) txt.BackgroundTransparency=1 txt.TextColor3=Color3.new(1,1,1) txt.TextScaled=true txt.Font=Enum.Font.GothamBold txt.Text="CP "..i
end

local raceQueue = {}
local activeRace = nil

joinRaceEvent.OnServerEvent:Connect(function(player)
	table.insert(raceQueue, player)
	if #raceQueue >= 2 and not activeRace then
		activeRace = { players=raceQueue, progress={}, startTime=tick() }
		raceQueue = {}
		for _, p in ipairs(activeRace.players) do
			activeRace.progress[p.UserId] = 0
			raceStartEvent:FireClient(p, #Checkpoints)
		end
		print("[Corrida] Corrida iniciada!")
	end
end)

checkpointEvent.OnServerEvent:Connect(function(player, cpIndex)
	if not activeRace then return end
	local prog = activeRace.progress[player.UserId] or 0
	if cpIndex == prog + 1 then
		activeRace.progress[player.UserId] = cpIndex
		if cpIndex >= #Checkpoints then
			local time = tick() - activeRace.startTime
			local prize = math.max(500, 2000 - math.floor(time)*10)
			local addMoney = remotes:FindFirstChild("AddMoney")
			local addXP    = remotes:FindFirstChild("AddXP")
			if addMoney then addMoney:FireServer(player, prize) end
			if addXP    then addXP:FireServer(player, 100) end
			raceFinishEvent:FireClient(player, time, prize)
			print(("[Corrida] %s terminou em %.1fs, ganhou R$%d"):format(player.Name, time, prize))
		end
	end
end)
