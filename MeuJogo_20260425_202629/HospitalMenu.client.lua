local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="HospitalGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,340,0,320) panel.Position=UDim2.new(0.5,-170,0.5,-160) panel.BackgroundColor3=Color3.fromRGB(18,18,18) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,100,100) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="🏥 Hospital" title.Parent=panel

local function addBtn(txt, posY, color, fn)
	local b = Instance.new("TextButton") b.Size=UDim2.new(0.8,0,0,44) b.Position=UDim2.new(0.1,0,0,posY) b.BackgroundColor3=color b.TextColor3=Color3.new(1,1,1) b.TextScaled=true b.Font=Enum.Font.GothamBold b.Text=txt b.Parent=panel
	Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
	b.MouseButton1Click:Connect(fn)
end

addBtn("💊 Curar (R$200)",        55,  Color3.fromRGB(40,120,40),  function() remotes:WaitForChild("HospitalHeal"):FireServer() end)
addBtn("🏥 Plano de Saúde (R$1000)",105, Color3.fromRGB(40,80,160),  function() remotes:WaitForChild("BuyHealthPlan"):FireServer() end)
addBtn("📋 Verificar Plano",       155, Color3.fromRGB(60,60,60),   function()
	local hasPlan = remotes:WaitForChild("HasHealthPlan"):InvokeServer()
	-- Notificação visual
end)
addBtn("Fechar",                   215, Color3.fromRGB(180,40,40),  function() sg.Enabled=false end)

_G.OpenHospital = function() sg.Enabled=true end
