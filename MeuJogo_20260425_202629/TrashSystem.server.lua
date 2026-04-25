-- Trabalho de lixeiro: coletar lixo pelo mapa
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local collectTrashEvent = Instance.new("RemoteEvent") collectTrashEvent.Name="CollectTrash" collectTrashEvent.Parent=remotes

local trashFolder = Instance.new("Folder") trashFolder.Name="Trash" trashFolder.Parent=Workspace

local function spawnTrash(pos)
	local part = Instance.new("Part")
	part.Size = Vector3.new(1,1,1)
	part.Position = pos
	part.Anchored = true
	part.Color = Color3.fromRGB(80,60,20)
	part.Material = Enum.Material.SmoothPlastic
	part.Name = "TrashBag"
	part.Parent = trashFolder

	local bb = Instance.new("BillboardGui",part) bb.Size=UDim2.new(0,60,0,20) bb.StudsOffset=Vector3.new(0,2,0)
	local lbl = Instance.new("TextLabel",bb) lbl.Size=UDim2.new(1,0,1,0) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.new(1,1,1) lbl.TextScaled=true lbl.Font=Enum.Font.Gotham lbl.Text="🗑 Lixo"

	return part
end

-- Spawna lixo pelo mapa
for i = 1, 20 do
	spawnTrash(Vector3.new(math.random(-200,200), 1, math.random(-200,200)))
end

-- Respawn periódico
task.spawn(function()
	while true do
		task.wait(60)
		if #trashFolder:GetChildren() < 10 then
			for i = 1, 5 do
				spawnTrash(Vector3.new(math.random(-200,200), 1, math.random(-200,200)))
			end
		end
	end
end)

collectTrashEvent.OnServerEvent:Connect(function(player)
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	for _, trash in ipairs(trashFolder:GetChildren()) do
		if (trash.Position - root.Position).Magnitude < 8 then
			trash:Destroy()
			local addMoney = remotes:FindFirstChild("AddMoney")
			local addXP    = remotes:FindFirstChild("AddXP")
			if addMoney then addMoney:FireServer(player, 15) end
			if addXP    then addXP:FireServer(player, 5) end
			print(("[Lixeiro] %s coletou lixo"):format(player.Name))
			return
		end
	end
end)
