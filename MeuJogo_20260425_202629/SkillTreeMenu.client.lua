local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="SkillGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,420,0,480) panel.Position=UDim2.new(0.5,-210,0.5,-240) panel.BackgroundColor3=Color3.fromRGB(18,18,18) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,180,50) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="⚡ Árvore de Habilidades" title.Parent=panel

local pointsLbl = Instance.new("TextLabel") pointsLbl.Size=UDim2.new(1,0,0,24) pointsLbl.Position=UDim2.new(0,0,0,46) pointsLbl.BackgroundTransparency=1 pointsLbl.TextColor3=Color3.fromRGB(100,220,255) pointsLbl.TextScaled=true pointsLbl.Font=Enum.Font.GothamBold pointsLbl.Text="Pontos disponíveis: 0" pointsLbl.Parent=panel

local scroll = Instance.new("ScrollingFrame") scroll.Size=UDim2.new(1,-20,1,-120) scroll.Position=UDim2.new(0,10,0,75) scroll.BackgroundTransparency=1 scroll.ScrollBarThickness=4 scroll.Parent=panel
Instance.new("UIListLayout",scroll).Padding=UDim.new(0,6)

local skillRows = {}

local skillTreeFn = remotes:WaitForChild("GetSkillTree")
local skills, playerSkills, points = skillTreeFn:InvokeServer()
pointsLbl.Text = "Pontos disponíveis: "..(points or 0)

for _, skill in ipairs(skills) do
	local level = playerSkills[skill.id] or 0
	local row = Instance.new("Frame") row.Size=UDim2.new(1,0,0,56) row.BackgroundColor3=Color3.fromRGB(30,30,30) row.BorderSizePixel=0 row.Parent=scroll
	Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)

	local nameLbl = Instance.new("TextLabel") nameLbl.Size=UDim2.new(0.4,0,0.5,0) nameLbl.Position=UDim2.new(0,8,0,4) nameLbl.BackgroundTransparency=1 nameLbl.TextColor3=Color3.new(1,1,1) nameLbl.TextScaled=true nameLbl.Font=Enum.Font.GothamBold nameLbl.Text=skill.name nameLbl.TextXAlignment=Enum.TextXAlignment.Left nameLbl.Parent=row
	local effectLbl = Instance.new("TextLabel") effectLbl.Size=UDim2.new(0.4,0,0.5,0) effectLbl.Position=UDim2.new(0,8,0.5,0) effectLbl.BackgroundTransparency=1 effectLbl.TextColor3=Color3.fromRGB(180,180,180) effectLbl.TextScaled=true effectLbl.Font=Enum.Font.Gotham effectLbl.Text=skill.effect effectLbl.TextXAlignment=Enum.TextXAlignment.Left effectLbl.Parent=row

	-- Barras de nível
	for i = 1, skill.maxLevel do
		local bar = Instance.new("Frame") bar.Size=UDim2.new(0,12,0,20) bar.Position=UDim2.new(0.55,(i-1)*16,0.5,-10) bar.BackgroundColor3=i<=level and Color3.fromRGB(255,180,50) or Color3.fromRGB(50,50,50) bar.BorderSizePixel=0 bar.Parent=row
		Instance.new("UICorner",bar).CornerRadius=UDim.new(0,3)
	end

	local upgradeBtn = Instance.new("TextButton") upgradeBtn.Size=UDim2.new(0,60,0,32) upgradeBtn.Position=UDim2.new(1,-68,0.5,-16) upgradeBtn.BackgroundColor3=level>=skill.maxLevel and Color3.fromRGB(60,60,60) or Color3.fromRGB(40,100,40) upgradeBtn.TextColor3=Color3.new(1,1,1) upgradeBtn.TextScaled=true upgradeBtn.Font=Enum.Font.GothamBold upgradeBtn.Text=level>=skill.maxLevel and "MAX" or "▲ Up" upgradeBtn.Parent=row
	Instance.new("UICorner",upgradeBtn).CornerRadius=UDim.new(0,4)
	local id = skill.id
	upgradeBtn.MouseButton1Click:Connect(function()
		remotes:WaitForChild("UpgradeSkill"):FireServer(id)
	end)
	skillRows[skill.id] = { row=row, upgradeBtn=upgradeBtn }
end

remotes:WaitForChild("SkillUpdate").OnClientEvent:Connect(function(newSkills, newPoints)
	pointsLbl.Text = "Pontos disponíveis: "..newPoints
end)

local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0.8,0,0,38) closeBtn.Position=UDim2.new(0.1,0,1,-46) closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40) closeBtn.TextColor3=Color3.new(1,1,1) closeBtn.TextScaled=true closeBtn.Font=Enum.Font.GothamBold closeBtn.Text="Fechar" closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

_G.OpenSkillTree = function() sg.Enabled=true end
