local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="DailyGui" sg.ResetOnSpawn=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,360,0,320) panel.Position=UDim2.new(0.5,-180,0.5,-160) panel.BackgroundColor3=Color3.fromRGB(18,18,18) panel.BorderSizePixel=0 panel.Visible=false panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,220,50) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="🎁 Recompensa Diária" title.Parent=panel

local streakLbl = Instance.new("TextLabel") streakLbl.Size=UDim2.new(1,0,0,30) streakLbl.Position=UDim2.new(0,0,0,50) streakLbl.BackgroundTransparency=1 streakLbl.TextColor3=Color3.new(1,1,1) streakLbl.TextScaled=true streakLbl.Font=Enum.Font.Gotham streakLbl.Text="Sequência: 0 dias" streakLbl.Parent=panel

local rewardLbl = Instance.new("TextLabel") rewardLbl.Size=UDim2.new(1,0,0,60) rewardLbl.Position=UDim2.new(0,0,0,85) rewardLbl.BackgroundTransparency=1 rewardLbl.TextColor3=Color3.fromRGB(100,220,100) rewardLbl.TextScaled=true rewardLbl.Font=Enum.Font.GothamBold rewardLbl.Text="Hoje: R$100 + 50XP" rewardLbl.Parent=panel

-- 7 dias de recompensas
local daysFrame = Instance.new("Frame") daysFrame.Size=UDim2.new(0.9,0,0,60) daysFrame.Position=UDim2.new(0.05,0,0,155) daysFrame.BackgroundTransparency=1 daysFrame.Parent=panel
local daysLayout = Instance.new("UIGridLayout") daysLayout.CellSize=UDim2.new(0,40,0,40) daysLayout.CellPadding=UDim2.new(0,4,0,4) daysLayout.Parent=daysFrame

for i = 1, 7 do
	local day = Instance.new("Frame") day.BackgroundColor3=Color3.fromRGB(40,40,40) day.BorderSizePixel=0 day.Parent=daysFrame
	Instance.new("UICorner",day).CornerRadius=UDim.new(0,4)
	local lbl = Instance.new("TextLabel") lbl.Size=UDim2.new(1,0,1,0) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.new(1,1,1) lbl.TextScaled=true lbl.Font=Enum.Font.GothamBold lbl.Text=tostring(i) lbl.Parent=day
end

local claimBtn = Instance.new("TextButton") claimBtn.Size=UDim2.new(0.7,0,0,44) claimBtn.Position=UDim2.new(0.15,0,0,230) claimBtn.BackgroundColor3=Color3.fromRGB(40,140,40) claimBtn.TextColor3=Color3.new(1,1,1) claimBtn.TextScaled=true claimBtn.Font=Enum.Font.GothamBold claimBtn.Text="🎁 Coletar!" claimBtn.Parent=panel
Instance.new("UICorner",claimBtn).CornerRadius=UDim.new(0,8)

local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0.4,0,0,34) closeBtn.Position=UDim2.new(0.3,0,0,282) closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40) closeBtn.TextColor3=Color3.new(1,1,1) closeBtn.TextScaled=true closeBtn.Font=Enum.Font.GothamBold closeBtn.Text="Fechar" closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)

local dailyInfoFn = remotes:WaitForChild("GetDailyInfo")
local info = dailyInfoFn:InvokeServer()
if info then
	streakLbl.Text = "Sequência: "..info.streak.." dias"
	if info.reward then
		rewardLbl.Text = ("Hoje: R$%d + %dXP"):format(info.reward.money, info.reward.xp)
	end
	if not info.canClaim then
		claimBtn.Text = "✅ Já coletado hoje"
		claimBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	end
end

claimBtn.MouseButton1Click:Connect(function()
	remotes:WaitForChild("ClaimDaily"):FireServer()
	claimBtn.Text = "✅ Coletado!"
	claimBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
end)

closeBtn.MouseButton1Click:Connect(function() panel.Visible=false end)

-- Mostra automaticamente ao entrar
task.wait(2)
if info and info.canClaim then panel.Visible=true end

_G.OpenDailyReward = function() panel.Visible=true end
