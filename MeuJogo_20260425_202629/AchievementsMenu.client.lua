local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="AchievGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,400,0,480) panel.Position=UDim2.new(0.5,-200,0.5,-240) panel.BackgroundColor3=Color3.fromRGB(18,18,18) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,220,50) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="🏆 Conquistas" title.Parent=panel

local scroll = Instance.new("ScrollingFrame") scroll.Size=UDim2.new(1,-20,1,-100) scroll.Position=UDim2.new(0,10,0,50) scroll.BackgroundTransparency=1 scroll.ScrollBarThickness=4 scroll.Parent=panel
Instance.new("UIListLayout",scroll).Padding=UDim.new(0,6)

local getAchievementsFn = remotes:WaitForChild("GetAchievements")
local achievements, unlocked = getAchievementsFn:InvokeServer()

for _, ach in ipairs(achievements) do
	local isUnlocked = unlocked[ach.id]
	local row = Instance.new("Frame") row.Size=UDim2.new(1,0,0,56) row.BackgroundColor3=isUnlocked and Color3.fromRGB(40,60,30) or Color3.fromRGB(35,35,35) row.BorderSizePixel=0 row.Parent=scroll
	Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)

	local icon = Instance.new("TextLabel") icon.Size=UDim2.new(0,40,1,0) icon.BackgroundTransparency=1 icon.TextColor3=Color3.new(1,1,1) icon.TextScaled=true icon.Font=Enum.Font.GothamBold icon.Text=isUnlocked and "🏆" or "🔒" icon.Parent=row
	local nameLbl = Instance.new("TextLabel") nameLbl.Size=UDim2.new(0.6,0,0.5,0) nameLbl.Position=UDim2.new(0,44,0,4) nameLbl.BackgroundTransparency=1 nameLbl.TextColor3=isUnlocked and Color3.fromRGB(255,220,50) or Color3.fromRGB(150,150,150) nameLbl.TextScaled=true nameLbl.Font=Enum.Font.GothamBold nameLbl.Text=ach.name nameLbl.TextXAlignment=Enum.TextXAlignment.Left nameLbl.Parent=row
	local descLbl = Instance.new("TextLabel") descLbl.Size=UDim2.new(0.6,0,0.5,0) descLbl.Position=UDim2.new(0,44,0.5,0) descLbl.BackgroundTransparency=1 descLbl.TextColor3=Color3.fromRGB(160,160,160) descLbl.TextScaled=true descLbl.Font=Enum.Font.Gotham descLbl.Text=ach.desc descLbl.TextXAlignment=Enum.TextXAlignment.Left descLbl.Parent=row
	local rewardLbl = Instance.new("TextLabel") rewardLbl.Size=UDim2.new(0.3,0,1,0) rewardLbl.Position=UDim2.new(0.7,0,0,0) rewardLbl.BackgroundTransparency=1 rewardLbl.TextColor3=Color3.fromRGB(255,220,50) rewardLbl.TextScaled=true rewardLbl.Font=Enum.Font.Gotham rewardLbl.Text="R$"..ach.reward rewardLbl.Parent=row
end

-- Popup de conquista desbloqueada
remotes:WaitForChild("AchievementUnlocked").OnClientEvent:Connect(function(ach)
	local popup = Instance.new("Frame") popup.Size=UDim2.new(0,300,0,70) popup.Position=UDim2.new(0.5,-150,0,80) popup.BackgroundColor3=Color3.fromRGB(40,60,20) popup.BorderSizePixel=0 popup.Parent=sg
	Instance.new("UICorner",popup).CornerRadius=UDim.new(0,8)
	local lbl = Instance.new("TextLabel") lbl.Size=UDim2.new(1,0,1,0) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.fromRGB(255,220,50) lbl.TextScaled=true lbl.Font=Enum.Font.GothamBold lbl.Text="🏆 "..ach.name lbl.Parent=popup
	game:GetService("TweenService"):Create(popup, TweenInfo.new(0.3), {Position=UDim2.new(0.5,-150,0,10)}):Play()
	task.wait(3)
	game:GetService("TweenService"):Create(popup, TweenInfo.new(0.3), {Position=UDim2.new(0.5,-150,-0.15,0)}):Play()
	task.wait(0.3) popup:Destroy()
end)

local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0.8,0,0,38) closeBtn.Position=UDim2.new(0.1,0,1,-46) closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40) closeBtn.TextColor3=Color3.new(1,1,1) closeBtn.TextScaled=true closeBtn.Font=Enum.Font.GothamBold closeBtn.Text="Fechar" closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

_G.OpenAchievements = function() sg.Enabled=true end
