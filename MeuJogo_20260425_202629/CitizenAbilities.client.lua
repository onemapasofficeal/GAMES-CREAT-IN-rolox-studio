-- CitizenAbilities.client.lua
-- Habilidades e UI exclusivas do Cidadão

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local currentClass = "cidadao"

remotes:WaitForChild("ClassUpdate").OnClientEvent:Connect(function(classKey)
	currentClass = classKey
end)

local sg = Instance.new("ScreenGui")
sg.Name = "CitizenGui"
sg.ResetOnSpawn = false
sg.Parent = playerGui

-- Painel de ações do cidadão
local actionPanel = Instance.new("Frame")
actionPanel.Size = UDim2.new(0,220,0,160)
actionPanel.Position = UDim2.new(1,-230,0.5,-80)
actionPanel.BackgroundColor3 = Color3.fromRGB(15,25,40)
actionPanel.BackgroundTransparency = 0.2
actionPanel.BorderSizePixel = 0
actionPanel.Visible = false
actionPanel.Parent = sg
Instance.new("UICorner",actionPanel).CornerRadius = UDim.new(0,8)

local actionTitle = Instance.new("TextLabel")
actionTitle.Size = UDim2.new(1,0,0,30)
actionTitle.BackgroundTransparency = 1
actionTitle.TextColor3 = Color3.fromRGB(100,180,255)
actionTitle.TextScaled = true
actionTitle.Font = Enum.Font.GothamBold
actionTitle.Text = "👤 Ações do Cidadão"
actionTitle.Parent = actionPanel

local function addCitizenBtn(txt, posY, fn)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.9,0,0,30)
	b.Position = UDim2.new(0.05,0,0,posY)
	b.BackgroundColor3 = Color3.fromRGB(30,60,100)
	b.TextColor3 = Color3.new(1,1,1)
	b.TextScaled = true
	b.Font = Enum.Font.GothamBold
	b.Text = txt
	b.Parent = actionPanel
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,4)
	b.MouseButton1Click:Connect(fn)
end

addCitizenBtn("💼 Trabalhar (F1)", 34, function()
	if currentClass ~= "cidadao" and currentClass ~= "admin" then return end
	remotes:WaitForChild("Work"):FireServer()
end)

addCitizenBtn("📞 Ligar 190 (F2)", 70, function()
	if currentClass ~= "cidadao" and currentClass ~= "admin" then return end
	-- Chama polícia
	remotes:WaitForChild("CallCops"):FireServer("", "Minha localização")
end)

addCitizenBtn("🏥 Chamar Ambulância", 106, function()
	remotes:WaitForChild("HospitalHeal"):FireServer()
end)

-- Bônus passivo: cidadão ganha +10% de salário
-- (aplicado no servidor via ClassSystem)

-- Indicador de reputação
local repFrame = Instance.new("Frame")
repFrame.Size = UDim2.new(0,160,0,24)
repFrame.Position = UDim2.new(0,10,0,52)
repFrame.BackgroundColor3 = Color3.fromRGB(15,25,40)
repFrame.BackgroundTransparency = 0.3
repFrame.BorderSizePixel = 0
repFrame.Parent = sg
Instance.new("UICorner",repFrame).CornerRadius = UDim.new(0,6)

local repLbl = Instance.new("TextLabel")
repLbl.Size = UDim2.new(1,0,1,0)
repLbl.BackgroundTransparency = 1
repLbl.TextColor3 = Color3.fromRGB(100,220,100)
repLbl.TextScaled = true
repLbl.Font = Enum.Font.Gotham
repLbl.Text = "⭐ Reputação: Neutro"
repLbl.Parent = repFrame

remotes:WaitForChild("ReputationUpdate").OnClientEvent:Connect(function(rep, tier)
	if currentClass == "cidadao" then
		repLbl.Text = tier.name.." ("..rep..")"
		repLbl.TextColor3 = tier.color
		repFrame.Visible = true
	else
		repFrame.Visible = false
	end
end)

-- Toggle com F1
UIS.InputBegan:Connect(function(inp, gp)
	if gp then return end
	if inp.KeyCode == Enum.KeyCode.F1 then
		if currentClass == "cidadao" then
			actionPanel.Visible = not actionPanel.Visible
		end
	end
end)
