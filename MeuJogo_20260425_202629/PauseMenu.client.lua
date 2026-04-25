local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local sg = Instance.new("ScreenGui") sg.Name="PauseGui" sg.ResetOnSpawn=false sg.Parent=playerGui

local overlay = Instance.new("Frame") overlay.Size=UDim2.new(1,0,1,0) overlay.BackgroundColor3=Color3.new(0,0,0) overlay.BackgroundTransparency=0.5 overlay.Visible=false overlay.Parent=sg

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,280,0,320) panel.Position=UDim2.new(0.5,-140,0.5,-160) panel.BackgroundColor3=Color3.fromRGB(20,20,20) panel.BorderSizePixel=0 panel.Parent=overlay
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local function addBtn(txt, posY, fn)
	local b = Instance.new("TextButton") b.Size=UDim2.new(0.8,0,0,44) b.Position=UDim2.new(0.1,0,0,posY) b.BackgroundColor3=Color3.fromRGB(50,50,50) b.TextColor3=Color3.new(1,1,1) b.TextScaled=true b.Font=Enum.Font.GothamBold b.Text=txt b.Parent=panel
	Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
	b.MouseButton1Click:Connect(fn)
	return b
end

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,50) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,220,50) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="Pausado" title.Parent=panel

addBtn("▶ Continuar", 60, function() overlay.Visible=false end)
addBtn("⚙ Configurações", 115, function() end)
addBtn("🔊 Áudio", 170, function() end)
addBtn("🚪 Sair do Jogo", 225, function() game:GetService("TeleportService"):Teleport(game.PlaceId) end)

UIS.InputBegan:Connect(function(inp, gp)
	if gp then return end
	if inp.KeyCode == Enum.KeyCode.Escape then
		overlay.Visible = not overlay.Visible
	end
end)
