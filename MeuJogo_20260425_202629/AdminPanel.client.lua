-- AdminPanel.client.lua
-- Painel completo de admin (só aparece para admins)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local currentClass = "cidadao"

remotes:WaitForChild("ClassUpdate").OnClientEvent:Connect(function(classKey)
	currentClass = classKey
	if classKey == "admin" then
		sg.Enabled = false  -- painel fechado por padrão, abre com F12
	end
end)

local sg = Instance.new("ScreenGui")
sg.Name = "AdminPanelGui"
sg.ResetOnSpawn = false
sg.Enabled = false
sg.Parent = playerGui

local panel = Instance.new("Frame")
panel.Size = UDim2.new(0,480,0,520)
panel.Position = UDim2.new(0.5,-240,0.5,-260)
panel.BackgroundColor3 = Color3.fromRGB(10,10,10)
panel.BorderSizePixel = 0
panel.Parent = sg
Instance.new("UICorner",panel).CornerRadius = UDim.new(0,10)

-- Borda dourada
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255,200,0)
stroke.Thickness = 2
stroke.Parent = panel

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,44)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,200,0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Text = "⭐ Painel Admin"
title.Parent = panel

-- Campo de alvo
local targetBox = Instance.new("TextBox")
targetBox.Size = UDim2.new(0.7,0,0,34)
targetBox.Position = UDim2.new(0.05,0,0,50)
targetBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
targetBox.TextColor3 = Color3.new(1,1,1)
targetBox.PlaceholderText = "Nome do jogador..."
targetBox.TextScaled = true
targetBox.Font = Enum.Font.Gotham
targetBox.Text = ""
targetBox.Parent = panel
Instance.new("UICorner",targetBox).CornerRadius = UDim.new(0,6)

-- Campo de valor
local valueBox = Instance.new("TextBox")
valueBox.Size = UDim2.new(0.22,0,0,34)
valueBox.Position = UDim2.new(0.77,0,0,50)
valueBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
valueBox.TextColor3 = Color3.new(1,1,1)
valueBox.PlaceholderText = "Valor"
valueBox.TextScaled = true
valueBox.Font = Enum.Font.Gotham
valueBox.Text = ""
valueBox.Parent = panel
Instance.new("UICorner",valueBox).CornerRadius = UDim.new(0,6)

-- Grid de botões admin
local grid = Instance.new("Frame")
grid.Size = UDim2.new(0.9,0,0,340)
grid.Position = UDim2.new(0.05,0,0,95)
grid.BackgroundTransparency = 1
grid.Parent = panel

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0,140,0,44)
gridLayout.CellPadding = UDim2.new(0,6,0,6)
gridLayout.Parent = grid

local AdminActions = {
	{ name="💰 Dar Dinheiro",  color=Color3.fromRGB(40,120,40),  fn=function(t,v)
		remotes:WaitForChild("AddMoney"):FireServer(tonumber(v) or 1000)
	end},
	{ name="💸 Remover Dinheiro",color=Color3.fromRGB(120,40,40), fn=function(t,v)
		remotes:WaitForChild("RemoveMoney"):FireServer(tonumber(v) or 100)
	end},
	{ name="❤ Curar",          color=Color3.fromRGB(40,100,40),  fn=function(t,v)
		remotes:WaitForChild("HospitalHeal"):FireServer()
	end},
	{ name="⚡ Dar XP",         color=Color3.fromRGB(80,40,160),  fn=function(t,v)
		remotes:WaitForChild("AddXP"):FireServer(tonumber(v) or 500)
	end},
	{ name="🚀 Velocidade",     color=Color3.fromRGB(40,80,160),  fn=function(t,v)
		local char = player.Character
		if char then
			local hum = char:FindFirstChild("Humanoid")
			if hum then hum.WalkSpeed = tonumber(v) or 50 end
		end
	end},
	{ name="🌤 Mudar Clima",    color=Color3.fromRGB(60,80,100),  fn=function(t,v)
		-- Muda clima via servidor
	end},
	{ name="🕐 Mudar Hora",     color=Color3.fromRGB(60,60,100),  fn=function(t,v)
		game:GetService("Lighting").TimeOfDay = (v or "12").."00:00"
	end},
	{ name="🗺 Teleportar",     color=Color3.fromRGB(40,100,80),  fn=function(t,v)
		remotes:WaitForChild("TeleportTo"):FireServer(tonumber(v) or 1)
	end},
	{ name="👮 Prender",        color=Color3.fromRGB(30,50,120),  fn=function(t,v)
		remotes:WaitForChild("Arrest"):FireServer(t)
	end},
	{ name="🔓 Soltar Preso",   color=Color3.fromRGB(50,80,50),   fn=function(t,v)
		-- Libera da prisão
	end},
	{ name="🌟 Dar Título",     color=Color3.fromRGB(100,80,20),  fn=function(t,v)
		remotes:WaitForChild("EquipTitle"):FireServer(tonumber(v) or 1)
	end},
	{ name="🚫 Banir",          color=Color3.fromRGB(150,20,20),  fn=function(t,v)
		-- Kick via chat command :kick
	end},
}

for _, action in ipairs(AdminActions) do
	local btn = Instance.new("TextButton")
	btn.BackgroundColor3 = action.color
	btn.TextColor3 = Color3.new(1,1,1)
	btn.TextScaled = true
	btn.Font = Enum.Font.GothamBold
	btn.Text = action.name
	btn.Parent = grid
	Instance.new("UICorner",btn).CornerRadius = UDim.new(0,6)
	btn.MouseButton1Click:Connect(function()
		action.fn(targetBox.Text, valueBox.Text)
	end)
end

-- Log de ações
local logFrame = Instance.new("ScrollingFrame")
logFrame.Size = UDim2.new(0.9,0,0,50)
logFrame.Position = UDim2.new(0.05,0,1,-60)
logFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
logFrame.BorderSizePixel = 0
logFrame.ScrollBarThickness = 3
logFrame.Parent = panel
Instance.new("UICorner",logFrame).CornerRadius = UDim.new(0,4)
Instance.new("UIListLayout",logFrame).VerticalAlignment = Enum.VerticalAlignment.Bottom

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,80,0,30)
closeBtn.Position = UDim2.new(1,-88,0,8)
closeBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "✕ Fechar"
closeBtn.Parent = panel
Instance.new("UICorner",closeBtn).CornerRadius = UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled = false end)

-- Abre com F12
UIS.InputBegan:Connect(function(inp, gp)
	if gp then return end
	if inp.KeyCode == Enum.KeyCode.F12 then
		if currentClass == "admin" then
			sg.Enabled = not sg.Enabled
		end
	end
end)
