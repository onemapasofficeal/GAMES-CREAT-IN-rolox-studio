-- CriminalAbilities.client.lua
-- Habilidades exclusivas do Criminoso

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

task.spawn(function()
	task.wait(2)
	local classKey = remotes:WaitForChild("GetClass"):InvokeServer()
	if classKey then currentClass = classKey end
end)

-- HUD de criminoso
local sg = Instance.new("ScreenGui")
sg.Name = "CriminalGui"
sg.ResetOnSpawn = false
sg.Parent = playerGui

-- Barra de "Fuga" (stamina especial do criminoso)
local escapeFrame = Instance.new("Frame")
escapeFrame.Size = UDim2.new(0,200,0,18)
escapeFrame.Position = UDim2.new(0.5,-100,0,80)
escapeFrame.BackgroundColor3 = Color3.fromRGB(30,10,10)
escapeFrame.BorderSizePixel = 0
escapeFrame.Visible = false
escapeFrame.Parent = sg
Instance.new("UICorner",escapeFrame).CornerRadius = UDim.new(0,4)

local escapeFill = Instance.new("Frame")
escapeFill.Size = UDim2.new(1,0,1,0)
escapeFill.BackgroundColor3 = Color3.fromRGB(220,50,50)
escapeFill.BorderSizePixel = 0
escapeFill.Parent = escapeFrame
Instance.new("UICorner",escapeFill).CornerRadius = UDim.new(0,4)

local escapeLbl = Instance.new("TextLabel")
escapeLbl.Size = UDim2.new(1,0,1,0)
escapeLbl.BackgroundTransparency = 1
escapeLbl.TextColor3 = Color3.new(1,1,1)
escapeLbl.TextScaled = true
escapeLbl.Font = Enum.Font.GothamBold
escapeLbl.Text = "💨 Fuga"
escapeLbl.Parent = escapeFrame

-- Painel de ações criminosas
local actionPanel = Instance.new("Frame")
actionPanel.Size = UDim2.new(0,220,0,180)
actionPanel.Position = UDim2.new(1,-230,0.5,-90)
actionPanel.BackgroundColor3 = Color3.fromRGB(20,10,10)
actionPanel.BackgroundTransparency = 0.2
actionPanel.BorderSizePixel = 0
actionPanel.Visible = false
actionPanel.Parent = sg
Instance.new("UICorner",actionPanel).CornerRadius = UDim.new(0,8)

local actionTitle = Instance.new("TextLabel")
actionTitle.Size = UDim2.new(1,0,0,30)
actionTitle.BackgroundTransparency = 1
actionTitle.TextColor3 = Color3.fromRGB(220,50,50)
actionTitle.TextScaled = true
actionTitle.Font = Enum.Font.GothamBold
actionTitle.Text = "💀 Ações Criminosas"
actionTitle.Parent = actionPanel

local targetBox = Instance.new("TextBox")
targetBox.Size = UDim2.new(0.9,0,0,28)
targetBox.Position = UDim2.new(0.05,0,0,34)
targetBox.BackgroundColor3 = Color3.fromRGB(40,20,20)
targetBox.TextColor3 = Color3.new(1,1,1)
targetBox.PlaceholderText = "Alvo..."
targetBox.TextScaled = true
targetBox.Font = Enum.Font.Gotham
targetBox.Text = ""
targetBox.Parent = actionPanel
Instance.new("UICorner",targetBox).CornerRadius = UDim.new(0,4)

local function addCrimBtn(txt, posY, fn)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.9,0,0,28)
	b.Position = UDim2.new(0.05,0,0,posY)
	b.BackgroundColor3 = Color3.fromRGB(150,30,30)
	b.TextColor3 = Color3.new(1,1,1)
	b.TextScaled = true
	b.Font = Enum.Font.GothamBold
	b.Text = txt
	b.Parent = actionPanel
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,4)
	b.MouseButton1Click:Connect(fn)
end

addCrimBtn("🔫 Roubar", 68, function()
	if currentClass ~= "criminoso" and currentClass ~= "admin" then return end
	remotes:WaitForChild("Rob"):FireServer(targetBox.Text)
end)

addCrimBtn("🔪 Atacar", 102, function()
	if currentClass ~= "criminoso" and currentClass ~= "admin" then return end
	remotes:WaitForChild("MeleeAttack"):FireServer(targetBox.Text)
end)

addCrimBtn("💊 Fabricar Droga", 136, function()
	if currentClass ~= "criminoso" and currentClass ~= "admin" then return end
	remotes:WaitForChild("MakeDrug"):FireServer(1)
end)

-- Toggle painel com F1
UIS.InputBegan:Connect(function(inp, gp)
	if gp then return end
	if inp.KeyCode == Enum.KeyCode.F1 then
		if currentClass == "criminoso" or currentClass == "admin" then
			actionPanel.Visible = not actionPanel.Visible
		end
	end
end)

-- Mostra barra de fuga quando procurado
remotes:WaitForChild("WantedUpdate").OnClientEvent:Connect(function(wanted)
	if currentClass == "criminoso" then
		escapeFrame.Visible = wanted > 0
		escapeFill.Size = UDim2.new(wanted/5, 0, 1, 0)
		escapeLbl.Text = "⭐ Procurado: "..wanted.."/5"
	end
end)
