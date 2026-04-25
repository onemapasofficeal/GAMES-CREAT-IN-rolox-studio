local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local mineEvent  = Instance.new("RemoteEvent")    mineEvent.Name  = "Mine"          mineEvent.Parent  = remotes
local mineListFn = Instance.new("RemoteFunction") mineListFn.Name = "GetMineList"   mineListFn.Parent = remotes

local Ores = {
	{ name="Pedra",    color=Color3.fromRGB(150,150,150), value=5,   xp=5,  respawn=30  },
	{ name="Ferro",    color=Color3.fromRGB(180,120,80),  value=20,  xp=15, respawn=60  },
	{ name="Ouro",     color=Color3.fromRGB(255,200,0),   value=80,  xp=40, respawn=120 },
	{ name="Diamante", color=Color3.fromRGB(100,220,255), value=300, xp=100,respawn=300 },
	{ name="Esmeralda",color=Color3.fromRGB(50,200,100),  value=200, xp=80, respawn=240 },
}

local mineFolder = Instance.new("Folder") mineFolder.Name="Mines" mineFolder.Parent=Workspace

local function spawnOre(ore, pos)
	local part = Instance.new("Part")
	part.Size = Vector3.new(3,3,3)
	part.Position = pos
	part.Anchored = true
	part.Color = ore.color
	part.Material = Enum.Material.SmoothPlastic
	part.Name = ore.name
	part.Parent = mineFolder

	local tag = Instance.new("StringValue") tag.Name="OreType" tag.Value=ore.name tag.Parent=part

	local bb = Instance.new("BillboardGui",part) bb.Size=UDim2.new(0,80,0,30) bb.StudsOffset=Vector3.new(0,3,0)
	local lbl = Instance.new("TextLabel",bb) lbl.Size=UDim2.new(1,0,1,0) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.new(1,1,1) lbl.TextScaled=true lbl.Font=Enum.Font.GothamBold lbl.Text=ore.name

	return part
end

-- Spawna minérios no mapa
local positions = {}
for i = 1, 30 do
	table.insert(positions, Vector3.new(math.random(-200,200), 1.5, math.random(-200,200)))
end
for i, pos in ipairs(positions) do
	local ore = Ores[math.random(1,#Ores)]
	spawnOre(ore, pos)
end

mineListFn.OnServerInvoke = function() return Ores end

mineEvent.OnServerEvent:Connect(function(player, oreName)
	local orePart = nil
	for _, p in ipairs(mineFolder:GetChildren()) do
		if p.Name == oreName then
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				if (p.Position - char.HumanoidRootPart.Position).Magnitude < 10 then
					orePart = p break
				end
			end
		end
	end
	if not orePart then return end

	local ore = nil
	for _, o in ipairs(Ores) do if o.name==oreName then ore=o break end end
	if not ore then return end

	local addMoney = remotes:FindFirstChild("AddMoney")
	local addItem  = remotes:FindFirstChild("AddItem")
	local addXP    = remotes:FindFirstChild("AddXP")

	if addMoney then addMoney:FireServer(player, ore.value) end
	if addItem  then addItem:FireServer(player, ore.name, 1) end
	if addXP    then addXP:FireServer(player, ore.xp) end

	orePart:Destroy()
	print(("[Mineração] %s minerou %s"):format(player.Name, ore.name))

	-- Respawn
	task.delay(ore.respawn, function()
		spawnOre(ore, orePart.Position)
	end)
end)
