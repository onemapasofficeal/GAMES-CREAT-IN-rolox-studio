local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local sg = Instance.new("ScreenGui") sg.Name="SpeedGui" sg.ResetOnSpawn=false sg.Parent=playerGui

local frame = Instance.new("Frame") frame.Size=UDim2.new(0,120,0,36) frame.Position=UDim2.new(1,-130,1,-45) frame.BackgroundColor3=Color3.fromRGB(0,0,0) frame.BackgroundTransparency=0.4 frame.BorderSizePixel=0 frame.Parent=sg
Instance.new("UICorner",frame).CornerRadius=UDim.new(0,8)

local lbl = Instance.new("TextLabel") lbl.Size=UDim2.new(1,0,1,0) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.fromRGB(255,220,50) lbl.TextScaled=true lbl.Font=Enum.Font.GothamBold lbl.Text="0 km/h" lbl.Parent=frame

local lastPos = Vector3.new()
RunService.RenderStepped:Connect(function(dt)
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local speed = (root.Position - lastPos).Magnitude / dt * 0.06
	lastPos = root.Position
	lbl.Text = ("%d km/h"):format(math.floor(speed))
end)
