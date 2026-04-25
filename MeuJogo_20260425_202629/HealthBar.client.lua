local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local sg = Instance.new("ScreenGui") sg.Name="HealthBarGui" sg.ResetOnSpawn=false sg.Parent=playerGui

local frame = Instance.new("Frame") frame.Size=UDim2.new(0,220,0,22) frame.Position=UDim2.new(0,10,1,-45) frame.BackgroundColor3=Color3.fromRGB(40,0,0) frame.BorderSizePixel=0 frame.Parent=sg
Instance.new("UICorner",frame).CornerRadius=UDim.new(0,5)

local fill = Instance.new("Frame") fill.Size=UDim2.new(1,0,1,0) fill.BackgroundColor3=Color3.fromRGB(200,30,30) fill.BorderSizePixel=0 fill.Parent=frame
Instance.new("UICorner",fill).CornerRadius=UDim.new(0,5)

local lbl = Instance.new("TextLabel") lbl.Size=UDim2.new(1,0,1,0) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.new(1,1,1) lbl.TextScaled=true lbl.Font=Enum.Font.GothamBold lbl.Text="HP: 100/100" lbl.Parent=frame

player.CharacterAdded:Connect(function(char)
	local hum = char:WaitForChild("Humanoid")
	hum.HealthChanged:Connect(function(hp)
		local pct = hp/hum.MaxHealth
		fill.Size = UDim2.new(pct,0,1,0)
		lbl.Text = ("HP: %d/%d"):format(math.floor(hp), hum.MaxHealth)
		fill.BackgroundColor3 = Color3.fromRGB(200*(1-pct)+30*pct, 30+170*pct, 30)
	end)
end)
