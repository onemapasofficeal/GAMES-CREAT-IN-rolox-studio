-- StatsUI.client.lua
-- HUD: fome, sede, nível, wanted

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

-- ScreenGui
local sg = Instance.new("ScreenGui")
sg.Name = "StatsGui"
sg.ResetOnSpawn = false
sg.Parent = playerGui

-- Cria barra genérica
local function criarBarra(nome, cor, posY)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 200, 0, 20)
	frame.Position = UDim2.new(0, 10, 1, posY)
	frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
	frame.BorderSizePixel = 0
	frame.Parent = sg
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0,4)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(1, 0, 1, 0)
	fill.BackgroundColor3 = cor
	fill.BorderSizePixel = 0
	fill.Parent = frame
	Instance.new("UICorner", fill).CornerRadius = UDim.new(0,4)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1,1,1)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Text = nome .. ": 100"
	label.Parent = frame

	return fill, label
end

local hungerFill, hungerLabel = criarBarra("Fome",  Color3.fromRGB(220,150,50),  -90)
local thirstFill, thirstLabel = criarBarra("Sede",  Color3.fromRGB(50,150,220),  -65)

-- Nível
local levelLabel = Instance.new("TextLabel")
levelLabel.Size = UDim2.new(0, 200, 0, 25)
levelLabel.Position = UDim2.new(0, 10, 1, -115)
levelLabel.BackgroundTransparency = 1
levelLabel.TextColor3 = Color3.fromRGB(255,220,50)
levelLabel.TextScaled = true
levelLabel.Font = Enum.Font.GothamBold
levelLabel.Text = "Nível 1 | XP: 0/100"
levelLabel.Parent = sg

-- Wanted
local wantedLabel = Instance.new("TextLabel")
wantedLabel.Size = UDim2.new(0, 200, 0, 25)
wantedLabel.Position = UDim2.new(0, 10, 1, -140)
wantedLabel.BackgroundTransparency = 1
wantedLabel.TextColor3 = Color3.fromRGB(255,50,50)
wantedLabel.TextScaled = true
wantedLabel.Font = Enum.Font.GothamBold
wantedLabel.Text = ""
wantedLabel.Parent = sg

-- Clima
local weatherLabel = Instance.new("TextLabel")
weatherLabel.Size = UDim2.new(0, 200, 0, 25)
weatherLabel.Position = UDim2.new(0.5, -100, 0, 10)
weatherLabel.BackgroundTransparency = 1
weatherLabel.TextColor3 = Color3.new(1,1,1)
weatherLabel.TextScaled = true
weatherLabel.Font = Enum.Font.Gotham
weatherLabel.Text = "☀ Ensolarado"
weatherLabel.Parent = sg

-- Eventos
remotes:WaitForChild("UpdateStats").OnClientEvent:Connect(function(stats)
	local h = stats.hunger / 100
	local t = stats.thirst / 100
	hungerFill.Size = UDim2.new(h, 0, 1, 0)
	hungerLabel.Text = ("Fome: %d%%"):format(stats.hunger)
	thirstFill.Size = UDim2.new(t, 0, 1, 0)
	thirstLabel.Text = ("Sede: %d%%"):format(stats.thirst)
end)

remotes:WaitForChild("LevelUpdate").OnClientEvent:Connect(function(level, xp, nextXp)
	levelLabel.Text = ("Nível %d | XP: %d/%d"):format(level, xp, nextXp)
end)

remotes:WaitForChild("WantedUpdate").OnClientEvent:Connect(function(wanted)
	if wanted > 0 then
		wantedLabel.Text = ("⭐ Procurado: " .. string.rep("★", wanted))
	else
		wantedLabel.Text = ""
	end
end)

remotes:WaitForChild("WeatherUpdate").OnClientEvent:Connect(function(weatherName)
	local icons = { Ensolarado = "☀", Nublado = "☁", Chuva = "🌧", Tempestade = "⛈" }
	weatherLabel.Text = (icons[weatherName] or "") .. " " .. weatherName
end)
