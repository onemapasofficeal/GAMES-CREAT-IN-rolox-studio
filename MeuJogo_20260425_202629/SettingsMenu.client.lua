local Players = game:GetService("Players")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local SoundService = game:GetService("SoundService")

local sg = Instance.new("ScreenGui") sg.Name="SettingsGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,340,0,400) panel.Position=UDim2.new(0.5,-170,0.5,-200) panel.BackgroundColor3=Color3.fromRGB(18,18,18) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,220,50) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="⚙ Configurações" title.Parent=panel

local function addSlider(label, posY, default, onChange)
	local lbl = Instance.new("TextLabel") lbl.Size=UDim2.new(0.5,0,0,28) lbl.Position=UDim2.new(0.05,0,0,posY) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.new(1,1,1) lbl.TextScaled=true lbl.Font=Enum.Font.Gotham lbl.Text=label lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.Parent=panel
	local track = Instance.new("Frame") track.Size=UDim2.new(0.4,0,0,8) track.Position=UDim2.new(0.55,0,0,posY+10) track.BackgroundColor3=Color3.fromRGB(60,60,60) track.BorderSizePixel=0 track.Parent=panel
	Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
	local fill = Instance.new("Frame") fill.Size=UDim2.new(default,0,1,0) fill.BackgroundColor3=Color3.fromRGB(100,180,255) fill.BorderSizePixel=0 fill.Parent=track
	Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
end

addSlider("Volume Geral", 55, 0.8, function(v) SoundService.RespectFilteringEnabled=true end)
addSlider("Volume Música", 100, 0.5, function() end)
addSlider("Volume SFX",   145, 1.0, function() end)
addSlider("Brilho",       190, 0.5, function() end)
addSlider("Sensibilidade",235, 0.5, function() end)

local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0.8,0,0,40) closeBtn.Position=UDim2.new(0.1,0,1,-50) closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40) closeBtn.TextColor3=Color3.new(1,1,1) closeBtn.TextScaled=true closeBtn.Font=Enum.Font.GothamBold closeBtn.Text="Fechar" closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

_G.OpenSettings = function() sg.Enabled=true end
