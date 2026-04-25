local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local cloneEvent  = Instance.new("RemoteEvent")    cloneEvent.Name  = "ClonePlayer"  cloneEvent.Parent  = remotes
local deleteClone = Instance.new("RemoteEvent")    deleteClone.Name = "DeleteClone"  deleteClone.Parent = remotes

local playerClones = {}

Players.PlayerAdded:Connect(function(p) playerClones[p.UserId]=nil end)
Players.PlayerRemoving:Connect(function(p)
	if playerClones[p.UserId] then playerClones[p.UserId]:Destroy() end
	playerClones[p.UserId]=nil
end)

cloneEvent.OnServerEvent:Connect(function(player)
	if playerClones[player.UserId] then
		playerClones[player.UserId]:Destroy()
	end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, 5000) end

	local char = player.Character
	if not char then return end

	-- Cria clone visual
	local clone = Instance.new("Model") clone.Name="Clone_"..player.Name

	local torso = Instance.new("Part") torso.Size=Vector3.new(2,2,1) torso.Position=char.HumanoidRootPart.Position+Vector3.new(3,0,0) torso.Color=Color3.fromRGB(200,200,255) torso.Material=Enum.Material.Neon torso.Anchored=false torso.Parent=clone
	local head  = Instance.new("Part") head.Size=Vector3.new(1.5,1.5,1.5) head.Position=torso.Position+Vector3.new(0,2,0) head.Color=Color3.fromRGB(200,200,255) head.Material=Enum.Material.Neon head.Anchored=false head.Parent=clone

	local bb = Instance.new("BillboardGui",head) bb.Size=UDim2.new(0,100,0,24) bb.StudsOffset=Vector3.new(0,2,0)
	local lbl = Instance.new("TextLabel",bb) lbl.Size=UDim2.new(1,0,1,0) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.fromRGB(200,200,255) lbl.TextScaled=true lbl.Font=Enum.Font.GothamBold lbl.Text="Clone de "..player.Name

	clone.PrimaryPart = torso
	clone.Parent = Workspace
	playerClones[player.UserId] = clone

	-- Clone segue o jogador
	task.spawn(function()
		while clone.Parent and player.Character do
			task.wait(0.2)
			local root = player.Character:FindFirstChild("HumanoidRootPart")
			if root then
				torso.Position = torso.Position:Lerp(root.Position + Vector3.new(3,0,0), 0.1)
				head.Position = torso.Position + Vector3.new(0,2,0)
			end
		end
	end)

	print(("[Clone] %s criou um clone"):format(player.Name))
end)

deleteClone.OnServerEvent:Connect(function(player)
	if playerClones[player.UserId] then
		playerClones[player.UserId]:Destroy()
		playerClones[player.UserId] = nil
	end
end)
