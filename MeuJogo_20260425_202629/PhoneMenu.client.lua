local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="PhoneGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local phone = Instance.new("Frame") phone.Size=UDim2.new(0,240,0,420) phone.Position=UDim2.new(0.5,-120,0.5,-210) phone.BackgroundColor3=Color3.fromRGB(15,15,15) phone.BorderSizePixel=0 phone.Parent=sg
Instance.new("UICorner",phone).CornerRadius=UDim.new(0,20)

local screen = Instance.new("Frame") screen.Size=UDim2.new(0.9,0,0.55,0) screen.Position=UDim2.new(0.05,0,0.05,0) screen.BackgroundColor3=Color3.fromRGB(30,30,50) screen.BorderSizePixel=0 screen.Parent=phone
Instance.new("UICorner",screen).CornerRadius=UDim.new(0,10)

local msgLog = Instance.new("ScrollingFrame") msgLog.Size=UDim2.new(1,0,0.7,0) msgLog.Position=UDim2.new(0,0,0.3,0) msgLog.BackgroundTransparency=1 msgLog.ScrollBarThickness=3 msgLog.Parent=screen
Instance.new("UIListLayout",msgLog).VerticalAlignment=Enum.VerticalAlignment.Bottom

local statusLbl = Instance.new("TextLabel") statusLbl.Size=UDim2.new(1,0,0.3,0) statusLbl.BackgroundTransparency=1 statusLbl.TextColor3=Color3.fromRGB(100,200,255) statusLbl.TextScaled=true statusLbl.Font=Enum.Font.GothamBold statusLbl.Text="📱 Celular" statusLbl.Parent=screen

local targetBox = Instance.new("TextBox") targetBox.Size=UDim2.new(0.9,0,0,32) targetBox.Position=UDim2.new(0.05,0,0.62,0) targetBox.BackgroundColor3=Color3.fromRGB(40,40,40) targetBox.TextColor3=Color3.new(1,1,1) targetBox.PlaceholderText="Nome do jogador..." targetBox.TextScaled=true targetBox.Font=Enum.Font.Gotham targetBox.Text="" targetBox.Parent=phone
Instance.new("UICorner",targetBox).CornerRadius=UDim.new(0,6)

local msgBox = Instance.new("TextBox") msgBox.Size=UDim2.new(0.9,0,0,32) msgBox.Position=UDim2.new(0.05,0,0.72,0) msgBox.BackgroundColor3=Color3.fromRGB(40,40,40) msgBox.TextColor3=Color3.new(1,1,1) msgBox.PlaceholderText="Mensagem..." msgBox.TextScaled=true msgBox.Font=Enum.Font.Gotham msgBox.Text="" msgBox.Parent=phone
Instance.new("UICorner",msgBox).CornerRadius=UDim.new(0,6)

local function addBtn(txt, posY, color, fn)
	local b = Instance.new("TextButton") b.Size=UDim2.new(0.42,0,0,32) b.Position=posY b.BackgroundColor3=color b.TextColor3=Color3.new(1,1,1) b.TextScaled=true b.Font=Enum.Font.GothamBold b.Text=txt b.Parent=phone
	Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
	b.MouseButton1Click:Connect(fn)
end

addBtn("📞 Ligar", UDim2.new(0.05,0,0,340), Color3.fromRGB(40,140,40), function()
	remotes:WaitForChild("PhoneCall"):FireServer(targetBox.Text)
end)
addBtn("💬 Enviar", UDim2.new(0.53,0,0,340), Color3.fromRGB(40,80,160), function()
	remotes:WaitForChild("PhoneMessage"):FireServer(targetBox.Text, msgBox.Text)
	msgBox.Text=""
end)
addBtn("❌ Fechar", UDim2.new(0.29,0,0,382), Color3.fromRGB(180,40,40), function() sg.Enabled=false end)

local function addMsg(from, msg)
	local lbl = Instance.new("TextLabel") lbl.Size=UDim2.new(1,0,0,24) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.new(1,1,1) lbl.TextScaled=true lbl.Font=Enum.Font.Gotham lbl.Text=from..": "..msg lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.Parent=msgLog
end

remotes:WaitForChild("ReceiveMessage").OnClientEvent:Connect(function(from, msg) addMsg(from, msg) end)
remotes:WaitForChild("ReceiveCall").OnClientEvent:Connect(function(from) statusLbl.Text="📞 "..from.." ligando..." end)

UIS.InputBegan:Connect(function(inp,gp) if gp then return end if inp.KeyCode==Enum.KeyCode.P then sg.Enabled=not sg.Enabled end end)
_G.OpenPhone = function() sg.Enabled=true end
