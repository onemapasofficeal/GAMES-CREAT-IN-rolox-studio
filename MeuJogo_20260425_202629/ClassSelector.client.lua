-- ClassSelector.client.lua
-- Tela de seleção de classe ao entrar no jogo

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui")
sg.Name = "ClassSelectorGui"
sg.ResetOnSpawn = false
sg.Parent = playerGui

-- Overlay escuro
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1,0,1,0)
overlay.BackgroundColor3 = Color3.new(0,0,0)
overlay.BackgroundTransparency = 0.3
overlay.BorderSizePixel = 0
overlay.Parent = sg

-- Painel principal
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0,700,0,420)
panel.Position = UDim2.new(0.5,-350,0.5,-210)
panel.BackgroundColor3 = Color3.fromRGB(15,15,15)
panel.BorderSizePixel = 0
panel.Parent = sg
Instance.new("UICorner",panel).CornerRadius = UDim.new(0,12)

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1,0,0,50)
titleLbl.BackgroundTransparency = 1
titleLbl.TextColor3 = Color3.fromRGB(255,220,50)
titleLbl.TextScaled = true
titleLbl.Font = Enum.Font.GothamBold
titleLbl.Text = "Escolha sua Classe"
titleLbl.Parent = panel

local subLbl = Instance.new("TextLabel")
subLbl.Size = UDim2.new(1,0,0,24)
subLbl.Position = UDim2.new(0,0,0,50)
subLbl.BackgroundTransparency = 1
subLbl.TextColor3 = Color3.fromRGB(180,180,180)
subLbl.TextScaled = true
subLbl.Font = Enum.Font.Gotham
subLbl.Text = "Sua escolha define como você joga. Pode trocar depois por R$1000."
subLbl.Parent = panel

-- Dados das classes
local ClassData = {
	{
		key = "cidadao",
		name = "Cidadão",
		icon = "👤",
		color = Color3.fromRGB(100,180,255),
		bgColor = Color3.fromRGB(20,40,70),
		desc = "Pessoa comum e honesta.\nTrabalha, compra casa,\ncuida da família.",
		perks = { "✅ Todos os empregos", "✅ Casa e carro", "✅ Banco e loja", "❌ Sem crimes" }
	},
	{
		key = "criminoso",
		name = "Criminoso",
		icon = "💀",
		color = Color3.fromRGB(220,50,50),
		bgColor = Color3.fromRGB(50,15,15),
		desc = "Vive fora da lei.\nFoge da polícia,\nrouba e trafega.",
		perks = { "✅ Roubar jogadores", "✅ Armas ilegais", "✅ Velocidade +4", "⚠ Sempre procurado" }
	},
	{
		key = "admin",
		name = "Admin",
		icon = "⭐",
		color = Color3.fromRGB(255,200,0),
		bgColor = Color3.fromRGB(50,40,10),
		desc = "Administrador.\nPode fazer tudo,\nsem restrições.",
		perks = { "✅ Tudo liberado", "✅ Imortal", "✅ Dinheiro infinito", "🔒 Apenas admins" }
	},
}

local cards = {}

for i, data in ipairs(ClassData) do
	local card = Instance.new("Frame")
	card.Size = UDim2.new(0,200,0,280)
	card.Position = UDim2.new(0, 20 + (i-1)*220, 0, 85)
	card.BackgroundColor3 = data.bgColor
	card.BorderSizePixel = 0
	card.Parent = panel
	Instance.new("UICorner",card).CornerRadius = UDim.new(0,10)

	-- Borda colorida
	local stroke = Instance.new("UIStroke")
	stroke.Color = data.color
	stroke.Thickness = 2
	stroke.Parent = card

	-- Ícone
	local iconLbl = Instance.new("TextLabel")
	iconLbl.Size = UDim2.new(1,0,0,50)
	iconLbl.Position = UDim2.new(0,0,0,10)
	iconLbl.BackgroundTransparency = 1
	iconLbl.TextColor3 = data.color
	iconLbl.TextScaled = true
	iconLbl.Font = Enum.Font.GothamBold
	iconLbl.Text = data.icon
	iconLbl.Parent = card

	-- Nome
	local nameLbl = Instance.new("TextLabel")
	nameLbl.Size = UDim2.new(1,0,0,28)
	nameLbl.Position = UDim2.new(0,0,0,60)
	nameLbl.BackgroundTransparency = 1
	nameLbl.TextColor3 = data.color
	nameLbl.TextScaled = true
	nameLbl.Font = Enum.Font.GothamBold
	nameLbl.Text = data.name
	nameLbl.Parent = card

	-- Descrição
	local descLbl = Instance.new("TextLabel")
	descLbl.Size = UDim2.new(0.9,0,0,60)
	descLbl.Position = UDim2.new(0.05,0,0,92)
	descLbl.BackgroundTransparency = 1
	descLbl.TextColor3 = Color3.fromRGB(200,200,200)
	descLbl.TextScaled = true
	descLbl.Font = Enum.Font.Gotham
	descLbl.Text = data.desc
	descLbl.TextWrapped = true
	descLbl.Parent = card

	-- Perks
	for j, perk in ipairs(data.perks) do
		local perkLbl = Instance.new("TextLabel")
		perkLbl.Size = UDim2.new(0.9,0,0,18)
		perkLbl.Position = UDim2.new(0.05,0,0,158+(j-1)*20)
		perkLbl.BackgroundTransparency = 1
		perkLbl.TextColor3 = Color3.fromRGB(180,180,180)
		perkLbl.TextScaled = true
		perkLbl.Font = Enum.Font.Gotham
		perkLbl.Text = perk
		perkLbl.TextXAlignment = Enum.TextXAlignment.Left
		perkLbl.Parent = card
	end

	-- Botão escolher
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.8,0,0,36)
	btn.Position = UDim2.new(0.1,0,1,-46)
	btn.BackgroundColor3 = data.color
	btn.TextColor3 = Color3.new(0,0,0)
	btn.TextScaled = true
	btn.Font = Enum.Font.GothamBold
	btn.Text = "Escolher"
	btn.Parent = card
	Instance.new("UICorner",btn).CornerRadius = UDim.new(0,6)

	local classKey = data.key
	btn.MouseButton1Click:Connect(function()
		-- Hover effect
		TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3=Color3.fromRGB(255,255,255)}):Play()
		task.wait(0.1)
		TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3=data.color}):Play()

		remotes:WaitForChild("ChooseClass"):FireServer(classKey)

		-- Fecha o seletor
		TweenService:Create(panel, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0,0,0,0),
			Position = UDim2.new(0.5,0,0.5,0)
		}):Play()
		task.wait(0.4)
		sg:Destroy()
	end)

	cards[i] = card
end

-- Animação de entrada
panel.Size = UDim2.new(0,0,0,0)
panel.Position = UDim2.new(0.5,0,0.5,0)
TweenService:Create(panel, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.new(0,700,0,420),
	Position = UDim2.new(0.5,-350,0.5,-210)
}):Play()
