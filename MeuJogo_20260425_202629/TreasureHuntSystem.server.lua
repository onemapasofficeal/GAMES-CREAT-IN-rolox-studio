local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local digEvent      = Instance.new("RemoteEvent")    digEvent.Name      = "Dig"           digEvent.Parent      = remotes
local treasureListFn= Instance.new("RemoteFunction") treasureListFn.Name= "GetTreasures"  treasureListFn.Parent= remotes
local treasureFound = Instance.new("RemoteEvent")    treasureFound.Name = "TreasureFound" treasureFound.Parent = remotes

local treasureFolder = Instance.new("Folder") treasureFolder.Name="Treasures" treasureFolder.Parent=Workspace

local Treasures = {
	{ name="Moedas Antigas",  value=200,  rarity="comum"    },
	{ name="Joia Rara",       value=800,  rarity="raro"     },
	{ name="Ouro Puro",       value=2000, rarity="épico"    },
	{ name="Diamante",        value=5000, rarity="lendário" },
}

local function spawnTreasure()
	local pos = Vector3.new(math.random(-200,200), 0.5, math.random(-200,200))
	local treasure = Treasures[math.random(1,#Treasures)]

	local part = Instance.new("Part") part.Size=Vector3.new(1,1,1) part.Position=pos part.Anchored=true part.Color=Color3.fromRGB(200,150,50) part.Material=Enum.Material.SmoothPlastic part.Name="Treasure" part.Parent=treasureFolder

	local tag = Instance.new("StringValue") tag.Name="TreasureData" tag.Value=treasure.name.."|"..treasure.value tag.Parent=part

	-- Esconde (sem billboard)
	return part
end

-- Spawna tesouros escondidos
for i = 1, 10 do spawnTreasure() end

treasureListFn.OnServerInvoke = function()
	local list = {}
	for _, t in ipairs(treasureFolder:GetChildren()) do
		table.insert(list, { pos=t.Position, name=t.Name })
	end
	return list
end

digEvent.OnServerEvent:Connect(function(player)
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	for _, t in ipairs(treasureFolder:GetChildren()) do
		if (t.Position - root.Position).Magnitude < 5 then
			local data = t:FindFirstChild("TreasureData")
			if data then
				local parts = data.Value:split("|")
				local name = parts[1]
				local value = tonumber(parts[2]) or 100

				t:Destroy()
				local addMoney = remotes:FindFirstChild("AddMoney")
				local addXP    = remotes:FindFirstChild("AddXP")
				if addMoney then addMoney:FireServer(player, value) end
				if addXP    then addXP:FireServer(player, value/10) end
				treasureFound:FireClient(player, name, value)

				-- Respawn
				task.delay(300, spawnTreasure)
				print(("[Tesouro] %s encontrou %s (R$%d)"):format(player.Name, name, value))
				return
			end
		end
	end
end)
