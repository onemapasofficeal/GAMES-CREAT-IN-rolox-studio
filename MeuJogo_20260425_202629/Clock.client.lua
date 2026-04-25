local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local sg = Instance.new("ScreenGui") sg.Name="ClockGui" sg.ResetOnSpawn=false sg.Parent=playerGui

local frame = Instance.new("Frame") frame.Size=UDim2.new(0,120,0,36) frame.Position=UDim2.new(0.5,-60,0,10) frame.BackgroundColor3=Color3.fromRGB(0,0,0) frame.BackgroundTransparency=0.4 frame.BorderSizePixel=0 frame.Parent=sg
Instance.new("UICorner",frame).CornerRadius=UDim.new(0,8)

local lbl = Instance.new("TextLabel") lbl.Size=UDim2.new(1,0,1,0) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.new(1,1,1) lbl.TextScaled=true lbl.Font=Enum.Font.GothamBold lbl.Text="12:00" lbl.Parent=frame

RunService.RenderStepped:Connect(function()
	local t = Lighting.TimeOfDay
	lbl.Text = t:sub(1,5)
end)
