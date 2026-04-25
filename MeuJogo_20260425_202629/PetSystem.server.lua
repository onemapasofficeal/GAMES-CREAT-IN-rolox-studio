local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buyPetEvent  = Instance.new("RemoteEvent")    buyPetEvent.Name  = "BuyPet"      buyPetEvent.Parent  = remotes
local feedPetEvent = Instance.new("RemoteEvent")    feedPetEvent.Name = "FeedPet"     feedPetEvent.Parent = remotes
local petListFn    = Instance.new("RemoteFunction") petListFn.Name    = "GetPetList"  petListFn.Parent    = remotes

local Pets = {
	{ id=1, name="Cachorro", price=500,  color=Color3.fromRGB(200,150,80),  bonus="speed"  },
	{ id=2, name="Gato",     price=400,  color=Color3.fromRGB(180,180,180), bonus="luck"   },
	{ id=3, name="Papagaio", price=800,  color=Color3.fromRGB(50,150,255),  bonus="xp"     },
	{ id=4, name="Coelho",   price=300,  color=Color3.fromRGB(255,220,200), bonus="hunger" },
	{ id=5, name="Dragão",   price=5000, color=Color3.fromRGB(200,50,50),   bonus="money"  },
}

local playerPets  = {}  -- userId → petId
local petModels   = {}  -- userId → Model

petListFn.OnServerInvoke = function() return Pets end

local function spawnPet(player, pet)
	if petModels[player.UserId] then petModels[player.UserId]:Destroy() end
	local char = player.Character
	if not char then return end

	local model = Instance.new("Model") model.Name="Pet_"..player.Name

	local body = Instance.new("Part") body.Size=Vector3.new(2,2,2) body.Color=pet.color body.Material=Enum.Material.SmoothPlastic body.Anchored=false body.Parent=model
	Instance.new("UICorner") -- visual only

	local bb = Instance.new("BillboardGui",body) bb.Size=UDim2.new(0,80,0,24) bb.StudsOffset=Vector3.new(0,2,0)
	local lbl = Instance.new("TextLabel",bb) lbl.Size=UDim2.new(1,0,1,0) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.new(1,1,1) lbl.TextScaled=true lbl.Font=Enum.Font.GothamBold lbl.Text=pet.name

	model.PrimaryPart = body
	model:SetPrimaryPartCFrame(char.HumanoidRootPart.CFrame * CFrame.new(3,0,0))
	model.Parent = Workspace

	petModels[player.UserId] = model

	-- Segue o jogador
	task.spawn(function()
		while model.Parent and player.Character do
			task.wait(0.1)
			local root = player.Character:FindFirstChild("HumanoidRootPart")
			if root then
				local target = root.Position + Vector3.new(3,0,0)
				body.Position = body.Position:Lerp(target, 0.1)
			end
		end
	end)
end

buyPetEvent.OnServerEvent:Connect(function(player, petId)
	local pet = nil
	for _, p in ipairs(Pets) do if p.id==petId then pet=p break end end
	if not pet then return end
	if playerPets[player.UserId] then warn("[Pet] Já tem pet") return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, pet.price) end
	playerPets[player.UserId] = petId
	spawnPet(player, pet)
	print(("[Pet] %s comprou %s"):format(player.Name, pet.name))
end)

feedPetEvent.OnServerEvent:Connect(function(player)
	print(("[Pet] %s alimentou o pet"):format(player.Name))
end)

Players.PlayerAdded:Connect(function(p) playerPets[p.UserId]=nil end)
Players.PlayerRemoving:Connect(function(p)
	if petModels[p.UserId] then petModels[p.UserId]:Destroy() end
	playerPets[p.UserId]=nil petModels[p.UserId]=nil
end)
