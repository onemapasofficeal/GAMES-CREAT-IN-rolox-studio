-- MainMenu.client.lua
-- Menu principal com todos os sistemas

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui")
sg.Name = "MainMenuGui"
sg.ResetOnSpawn = false
sg.Parent = playerGui

-- Botão de abrir menu
local menuBtn = Instance.new("TextButton")
menuBtn.Size = UDim2.new(0, 60, 0, 60)
menuBtn.Position = UDim2.new(0.5, -30, 1, -70)
menuBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
menuBtn.TextColor3 = Color3.new(1,1,1)
menuBtn.Text = "☰"
menuBtn.TextScaled = true
menuBtn.Font = Enum.Font.GothamBold
menuBtn.Parent = sg
Instance.new("UICorner", menuBtn).CornerRadius = UDim.new(0,8)

-- Painel principal
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 320, 0, 420)
panel.Position = UDim2.new(0.5, -160, 0.5, -210)
panel.BackgroundColor3 = Color3.fromRGB(20,20,20)
panel.BackgroundTransparency = 0.1
panel.Visible = false
panel.Parent = sg
Instance.new("UICorner", panel).CornerRadius = UDim.new(0,10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,220,50)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Text = "The Game Realist"
title.Parent = panel

-- Cria botão de ação
local function criarBotao(texto, posY, cor)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.85, 0, 0, 38)
	btn.Position = UDim2.new(0.075, 0, 0, posY)
	btn.BackgroundColor3 = cor or Color3.fromRGB(50,50,50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = texto
	btn.TextScaled = true
	btn.Font = Enum.Font.Gotham
	btn.Parent = panel
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
	return btn
end

local btnWork     = criarBotao("💼 Trabalhar",        50,  Color3.fromRGB(40,100,40))
local btnShop     = criarBotao("🛒 Loja",             95,  Color3.fromRGB(40,60,120))
local btnBank     = criarBotao("🏦 Banco",            140, Color3.fromRGB(60,40,100))
local btnHouse    = criarBotao("🏠 Comprar Casa",     185, Color3.fromRGB(100,60,20))
local btnCar      = criarBotao("🚗 Comprar Carro",    230, Color3.fromRGB(80,20,20))
local btnHospital = criarBotao("🏥 Hospital (Curar)", 275, Color3.fromRGB(20,80,80))
local btnFarm     = criarBotao("🌱 Plantar Tomate",   320, Color3.fromRGB(30,80,30))
local btnFish     = criarBotao("🎣 Pescar",           365, Color3.fromRGB(20,60,100))

menuBtn.MouseButton1Click:Connect(function()
	panel.Visible = not panel.Visible
end)

btnWork.MouseButton1Click:Connect(function()
	-- Pega emprego 1 se não tiver, depois trabalha
	remotes:WaitForChild("GetJob"):FireServer(1)
	task.wait(0.1)
	remotes:WaitForChild("Work"):FireServer()
end)

btnShop.MouseButton1Click:Connect(function()
	remotes:WaitForChild("BuyItem"):FireServer(1)  -- Compra pão
end)

btnBank.MouseButton1Click:Connect(function()
	remotes:WaitForChild("BankDeposit"):FireServer(100)
end)

btnHouse.MouseButton1Click:Connect(function()
	remotes:WaitForChild("BuyHouse"):FireServer(1)
end)

btnCar.MouseButton1Click:Connect(function()
	remotes:WaitForChild("BuyCar"):FireServer(1)
	task.wait(0.2)
	remotes:WaitForChild("EnterCar"):FireServer(1)
end)

btnHospital.MouseButton1Click:Connect(function()
	remotes:WaitForChild("HospitalHeal"):FireServer()
end)

btnFarm.MouseButton1Click:Connect(function()
	remotes:WaitForChild("Plant"):FireServer(1)
end)

btnFish.MouseButton1Click:Connect(function()
	remotes:WaitForChild("Fish"):FireServer()
end)

-- Notificações de pesca
remotes:WaitForChild("FishResult").OnClientEvent:Connect(function(fishName, caught)
	if caught then
		print("🎣 Você pescou: " .. fishName)
	else
		print("🎣 Não pescou nada desta vez...")
	end
end)
