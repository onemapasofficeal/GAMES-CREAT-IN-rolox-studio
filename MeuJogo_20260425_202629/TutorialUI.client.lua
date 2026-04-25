local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="TutorialGui" sg.ResetOnSpawn=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,380,0,140) panel.Position=UDim2.new(0.5,-190,1,10) panel.BackgroundColor3=Color3.fromRGB(20,20,40) panel.BorderSizePixel=0 panel.Visible=false panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local titleLbl = Instance.new("TextLabel") titleLbl.Size=UDim2.new(1,0,0,36) titleLbl.BackgroundTransparency=1 titleLbl.TextColor3=Color3.fromRGB(255,220,50) titleLbl.TextScaled=true titleLbl.Font=Enum.Font.GothamBold titleLbl.Text="Tutorial" titleLbl.Parent=panel

local msgLbl = Instance.new("TextLabel") msgLbl.Size=UDim2.new(0.9,0,0,60) msgLbl.Position=UDim2.new(0.05,0,0,38) msgLbl.BackgroundTransparency=1 msgLbl.TextColor3=Color3.new(1,1,1) msgLbl.TextScaled=true msgLbl.Font=Enum.Font.Gotham msgLbl.Text="" msgLbl.TextWrapped=true msgLbl.Parent=panel

local nextBtn = Instance.new("TextButton") nextBtn.Size=UDim2.new(0.4,0,0,32) nextBtn.Position=UDim2.new(0.55,0,1,-40) nextBtn.BackgroundColor3=Color3.fromRGB(40,100,40) nextBtn.TextColor3=Color3.new(1,1,1) nextBtn.TextScaled=true nextBtn.Font=Enum.Font.GothamBold nextBtn.Text="Próximo ✓" nextBtn.Parent=panel
Instance.new("UICorner",nextBtn).CornerRadius=UDim.new(0,6)

local skipBtn = Instance.new("TextButton") skipBtn.Size=UDim2.new(0.3,0,0,32) skipBtn.Position=UDim2.new(0.05,0,1,-40) skipBtn.BackgroundColor3=Color3.fromRGB(80,80,80) skipBtn.TextColor3=Color3.new(1,1,1) skipBtn.TextScaled=true skipBtn.Font=Enum.Font.Gotham skipBtn.Text="Pular" skipBtn.Parent=panel
Instance.new("UICorner",skipBtn).CornerRadius=UDim.new(0,6)

local function showPanel(step)
	titleLbl.Text = step.title
	msgLbl.Text = step.msg
	panel.Visible = true
	TweenService:Create(panel, TweenInfo.new(0.4), {Position=UDim2.new(0.5,-190,1,-150)}):Play()
end

local function hidePanel()
	TweenService:Create(panel, TweenInfo.new(0.3), {Position=UDim2.new(0.5,-190,1,10)}):Play()
	task.wait(0.3)
	panel.Visible = false
end

remotes:WaitForChild("TutorialStep").OnClientEvent:Connect(function(step)
	showPanel(step)
end)

nextBtn.MouseButton1Click:Connect(function()
	hidePanel()
	remotes:WaitForChild("CompleteTutorial"):FireServer()
end)

skipBtn.MouseButton1Click:Connect(function()
	hidePanel()
end)
