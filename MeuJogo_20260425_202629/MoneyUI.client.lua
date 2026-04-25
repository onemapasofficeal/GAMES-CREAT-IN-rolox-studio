-- MoneyUI.client.lua
-- Exibe o dinheiro do jogador na tela

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local updateMoneyUI = remotes:WaitForChild("UpdateMoneyUI")
local getMoney = remotes:WaitForChild("GetMoney")

-- Cria a UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoneyGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 50)
frame.Position = UDim2.new(1, -190, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 220, 50)
label.TextScaled = true
label.Font = Enum.Font.GothamBold
label.Text = "R$ 0"
label.Parent = frame

-- Atualiza o texto
local function atualizarUI(valor)
	label.Text = ("R$ %s"):format(tostring(valor))
end

-- Recebe atualização do servidor
updateMoneyUI.OnClientEvent:Connect(atualizarUI)

-- Pede o saldo ao entrar
task.spawn(function()
	local saldo = getMoney:InvokeServer()
	atualizarUI(saldo)
end)
