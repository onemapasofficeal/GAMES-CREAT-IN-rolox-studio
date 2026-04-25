local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local customizeEvent = Instance.new("RemoteEvent") customizeEvent.Name="CustomizeChar" customizeEvent.Parent=remotes

local sg = Instance.new("ScreenGui") sg.Name="CustomizeGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,360,0,480) panel.Position=UDim2.new(0.5,-180,0.5,-240) panel.BackgroundColor3=Color3.fromRGB(18,18,18) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,220,50) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="👤 Personalizar Personagem" title.Parent=panel

local colors = {
	{name="Pele Clara", color=Color3.fromRGB(255,220,185)},
	{name="Pele Média", color=Color3.fromRGB(200,160,120)},
	{name="Pele Escura", color=Color3.fromRGB(120,80,50)},
	{name="Azul",  color=Color3.fromRGB(50,100,200)},
	{name="Verde", color=Color3.fromRGB(50,180,80)},
}

local skinLabel = Instance.new("TextLabel") skinLabel.Size=UDim2.new(1,0,0,28) skinLabel.Position=UDim2.new(0,0,0,50) skinLabel.BackgroundTransparency=1 skinLabel.TextColor3=Color3.new(1,1,1) skinLabel.TextScaled=true skinLabel.Font=Enum.Font.Gotham skinLabel.Text="Cor da Pele:" skinLabel.Parent=panel

for i, c in ipairs(colors) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0,60,0,30)
	btn.Position = UDim2.new(0, 10+(i-1)*65, 0, 80)
	btn.BackgroundColor3 = c.color
	btn.TextColor3 = Color3.new(1,1,1)
	btn.TextScaled = true
	btn.Font = Enum.Font.Gotham
	btn.Text = ""
	btn.Parent = panel
	Instance.new("UICorner",btn).CornerRadius=UDim.new(0,4)
	btn.MouseButton1Click:Connect(function()
		customizeEvent:FireServer("skin", c.color)
	end)
end

local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0.8,0,0,40) closeBtn.Position=UDim2.new(0.1,0,1,-50) closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40) closeBtn.TextColor3=Color3.new(1,1,1) closeBtn.TextScaled=true closeBtn.Font=Enum.Font.GothamBold closeBtn.Text="Fechar" closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

_G.OpenCustomize = function() sg.Enabled=true end
