local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local huntEvent = Instance.new("RemoteEvent") huntEvent.Name="Hunt" huntEvent.Parent=remotes

local Animals = {
	{ name="Coelho",  color=Color3.fromRGB(200,180,160), size=Vector3.new(1,1,2), meat=1, xp=10, speed=12 },
	{ name="Veado",   color=Color3.fromRGB(180,140,80),  size=Vector3.new(2,2,3), meat=3, xp=25, speed=16 },
	{ name="Javali",  color=Color3.fromRGB(80,60,40),    size=Vector3.new(2,2,3), meat=4, xp=30, speed=14 },
	{ name="Urso",    color=Color3.fromRGB(100,70,40),   size=Vector3.new(3,3,4), meat=8, xp=80, speed=10 },
	{ name="Galinha", color=Color3.fromRGB(255,240,200), size=Vector3.new(1,1,1), meat=1, xp=5,  speed=8  },
}

local animalFolder = Instance.new("Folder") animalFolder.Name="Animals" animalFolder.Parent=Workspace

local function spawnAnimal(animalData)
	local model = Instance.new("Model") model.Name=animalData.name

	local body = Instance.new("Part") body.Size=animalData.size body.Color=animalData.color body.Material=Enum.Material.SmoothPlastic body.Anchored=false
	body.Position = Vector3.new(math.random(-200,200), 2, math.random(-200,200))
	body.Parent = model

	local tag = Instance.new("StringValue") tag.Name="AnimalType" tag.Value=animalData.name tag.Parent=body

	local bb = Instance.new("BillboardGui",body) bb.Size=UDim2.new(0,80,0,24) bb.StudsOffset=Vector3.new(0,2,0)
	local lbl = Instance.new("TextLabel",bb) lbl.Size=UDim2.new(1,0,1,0) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.new(1,1,1) lbl.TextScaled=true lbl.Font=Enum.Font.Gotham lbl.Text=animalData.name

	model.PrimaryPart = body
	model.Parent = animalFolder

	-- Movimento aleatório
	task.spawn(function()
		while model.Parent do
			task.wait(math.random(3,8))
			local newPos = body.Position + Vector3.new(math.random(-10,10), 0, math.random(-10,10))
			body.Position = newPos
		end
	end)

	return model
end

for i = 1, 15 do
	local animal = Animals[math.random(1,#Animals)]
	spawnAnimal(animal)
end

huntEvent.OnServerEvent:Connect(function(player, animalName)
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	for _, model in ipairs(animalFolder:GetChildren()) do
		if model.Name == animalName and model.PrimaryPart then
			if (model.PrimaryPart.Position - root.Position).Magnitude < 15 then
				local animalData = nil
				for _, a in ipairs(Animals) do if a.name==animalName then animalData=a break end end
				if not animalData then return end

				model:Destroy()
				local addItem = remotes:FindFirstChild("AddItem")
				local addXP   = remotes:FindFirstChild("AddXP")
				if addItem then addItem:FireServer(player, "Carne", animalData.meat) end
				if addXP   then addXP:FireServer(player, animalData.xp) end

				-- Respawn
				task.delay(120, function() spawnAnimal(animalData) end)
				print(("[Caça] %s caçou %s"):format(player.Name, animalName))
				return
			end
		end
	end
end)
