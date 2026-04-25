local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="CrimeGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,360,0,380) panel.Position=UDim2.new(0.5,-180,0.5,-190) panel.BackgroundColor3=Color3.fromRGB(20,10,10) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,50,50) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="💀 Crime" title.Parent=panel

local targetBox = Instance.new("TextBox") targetBox.Size=UDim2.new(0.8,0,0,36) targetBox.Position=UDim2.new(0.1,0,0,55) targetBox.BackgroundColor3=Color3.fromRGB(40,20,20) targetBox.TextColor3=Color3.new(1,1,1) targetBox.PlaceholderText="Nome do alvo..." targetBox.TextScaled=true targetBox.Font=Enum.Font.Gotham targetBox.Text="" targetBox.Parent=panel
Instance.new("UICorner",targetBox).CornerRadius=UDim.new(0,6)

local function addBtn(txt, posY, color, fn)
	local b = Instance.new("TextButton") b.Size=UDim2.new(0.8,0,0,44) b.Position=UDim2.new(0.1,0,0,posY) b.BackgroundColor3=color b.TextColor3=Color3.new(1,1,1) b.TextScaled=true b.Font=Enum.Font.GothamBold b.Text=txt b.Parent=panel
	Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
	b.MouseButton1Click:Connect(fn)
end

addBtn("🔫 Roubar Jogador",  105, Color3.fromRGB(150,30,30), function()
	remotes:WaitForChild("Rob"):FireServer(targetBox.Text)
end)
addBtn("👮 Prender (Policial)",155, Color3.fromRGB(30,50,150), function()
	remotes:WaitForChild("Arrest"):FireServer(targetBox.Text)
end)
addBtn("📞 Chamar Polícia",   205, Color3.fromRGB(30,80,150), function()
	remotes:WaitForChild("CallCops"):FireServer(targetBox.Text, "Centro")
end)
addBtn("🔪 Atacar (Melee)",   255, Color3.fromRGB(120,30,30), function()
	remotes:WaitForChild("MeleeAttack"):FireServer(targetBox.Text)
end)
addBtn("Fechar",               315, Color3.fromRGB(80,80,80), function() sg.Enabled=false end)

_G.OpenCrime = function() sg.Enabled=true end
