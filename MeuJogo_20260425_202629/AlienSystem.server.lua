local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local fightAlienEvent = Instance.new("RemoteEvent") fightAlienEvent.Name="FightAlien" fightAlienEvent.Parent=remotes
local alienAlert      = Instance.new("RemoteEvent") alienAlert.Name="AlienAlert"     alienAlert.Parent=remotes

local alienFolder = Instance.new("Folder") alienFolder.Name="Aliens" alienFolder.Parent=Workspace

local function spawnAlien(pos)
	local model = Instance.new("Model") model.Name="Alien"

	local body = Instance.new("Part") body.Size=Vector3.new(2,3,1) body.Position=pos+Vector3.new(0,2,0) body.Color=Color3.fromRGB(50,200,100) body.Material=Enum.Material.Neon body.Anchored=false body.Parent=model
	local head = Instance.new("Part") head.Shape=Enum.PartType.Ball head.Size=Vector3.new(2,2,2) head.Position=pos+Vector3.new(0,4,0) head.Color=Color3.fromRGB(50,200,100) head.Material=Enum.Material.Neon head.Anchored=false head.Parent=model

	local hp = Instance.new("IntValue") hp.Name="HP" hp.Value=200 hp.Parent=model

	local bb = Instance.new("BillboardGui",head) bb.Size=UDim2.new(0,80,0,24) bb.StudsOffset=Vector3.new(0,2,0)
	local lbl = Instance.new("TextLabel",bb) lbl.Size=UDim2.new(1,0,1,0) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.fromRGB(50,220,100) lbl.TextScaled=true lbl.Font=Enum.Font.GothamBold lbl.Text="👽 200HP"

	model.PrimaryPart = body
	model.Parent = alienFolder
	return model
end

-- Invasão alienígena aleatória
task.spawn(function()
	while true do
		task.wait(math.random(900, 1800))
		local pos = Vector3.new(math.random(-100,100), 50, math.random(-100,100))
		local alien = spawnAlien(pos)

		for _, p in ipairs(Players:GetPlayers()) do
			alienAlert:FireClient(p, pos)
		end
		print("[Alienígena] Invasão alienígena!")

		-- Alien cai do céu
		task.spawn(function()
			for i = 1, 50 do
				task.wait(0.1)
				if alien.PrimaryPart then
					alien.PrimaryPart.Position = alien.PrimaryPart.Position - Vector3.new(0,1,0)
				end
			end
		end)
	end
end)

fightAlienEvent.OnServerEvent:Connect(function(player, alienName)
	local alien = alienFolder:FindFirstChild(alienName)
	if not alien then return end
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	if (alien.PrimaryPart.Position - root.Position).Magnitude < 15 then
		local hp = alien:FindFirstChild("HP")
		if hp then
			hp.Value -= 50
			if hp.Value <= 0 then
				alien:Destroy()
				local addMoney = remotes:FindFirstChild("AddMoney")
				local addXP    = remotes:FindFirstChild("AddXP")
				if addMoney then addMoney:FireServer(player, 500) end
				if addXP    then addXP:FireServer(player, 100) end
				print(("[Alienígena] %s derrotou um alienígena!"):format(player.Name))
			end
		end
	end
end)
