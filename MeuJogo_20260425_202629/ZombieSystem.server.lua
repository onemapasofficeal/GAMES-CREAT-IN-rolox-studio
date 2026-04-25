local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local killZombieEvent = Instance.new("RemoteEvent") killZombieEvent.Name="KillZombie" killZombieEvent.Parent=remotes

local zombieFolder = Instance.new("Folder") zombieFolder.Name="Zombies" zombieFolder.Parent=Workspace

local function spawnZombie(pos)
	local model = Instance.new("Model") model.Name="Zombie"

	local torso = Instance.new("Part") torso.Size=Vector3.new(2,2,1) torso.Position=pos+Vector3.new(0,2,0) torso.Color=Color3.fromRGB(80,120,60) torso.Material=Enum.Material.SmoothPlastic torso.Anchored=false torso.Parent=model
	local head  = Instance.new("Part") head.Size=Vector3.new(1.5,1.5,1.5) head.Position=pos+Vector3.new(0,3.5,0) head.Color=Color3.fromRGB(80,120,60) head.Material=Enum.Material.SmoothPlastic head.Anchored=false head.Parent=model

	local hp = Instance.new("IntValue") hp.Name="HP" hp.Value=50 hp.Parent=model

	local bb = Instance.new("BillboardGui",head) bb.Size=UDim2.new(0,80,0,20) bb.StudsOffset=Vector3.new(0,2,0)
	local lbl = Instance.new("TextLabel",bb) lbl.Size=UDim2.new(1,0,1,0) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.fromRGB(50,220,50) lbl.TextScaled=true lbl.Font=Enum.Font.GothamBold lbl.Text="🧟 50HP"

	model.PrimaryPart = torso
	model.Parent = zombieFolder

	-- Persegue jogadores
	task.spawn(function()
		while model.Parent do
			task.wait(0.5)
			local nearest = nil
			local nearDist = 50
			for _, p in ipairs(Players:GetPlayers()) do
				local char = p.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					local dist = (char.HumanoidRootPart.Position - torso.Position).Magnitude
					if dist < nearDist then nearDist=dist nearest=p end
				end
			end
			if nearest and nearest.Character then
				local dir = (nearest.Character.HumanoidRootPart.Position - torso.Position).Unit
				torso.Velocity = dir * 8
				if nearDist < 4 then
					local hum = nearest.Character:FindFirstChild("Humanoid")
					if hum then hum.Health = math.max(0, hum.Health - 5) end
				end
			end
		end
	end)

	return model
end

-- Spawna zumbis à noite
task.spawn(function()
	while true do
		task.wait(60)
		local hour = tonumber(game:GetService("Lighting").TimeOfDay:sub(1,2)) or 12
		if hour >= 20 or hour < 6 then
			if #zombieFolder:GetChildren() < 10 then
				spawnZombie(Vector3.new(math.random(-200,200), 1, math.random(-200,200)))
			end
		end
	end
end)

killZombieEvent.OnServerEvent:Connect(function(player, zombieModel)
	local model = zombieFolder:FindFirstChild(zombieModel)
	if not model then return end
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	if (model.PrimaryPart.Position - root.Position).Magnitude < 10 then
		model:Destroy()
		local addMoney = remotes:FindFirstChild("AddMoney")
		local addXP    = remotes:FindFirstChild("AddXP")
		if addMoney then addMoney:FireServer(player, 50) end
		if addXP    then addXP:FireServer(player, 20) end
		print(("[Zumbi] %s matou um zumbi"):format(player.Name))
	end
end)
