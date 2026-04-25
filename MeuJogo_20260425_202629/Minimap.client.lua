local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local sg = Instance.new("ScreenGui") sg.Name="MinimapGui" sg.ResetOnSpawn=false sg.Parent=playerGui

local mapFrame = Instance.new("Frame") mapFrame.Size=UDim2.new(0,150,0,150) mapFrame.Position=UDim2.new(1,-160,0,10) mapFrame.BackgroundColor3=Color3.fromRGB(20,30,20) mapFrame.BorderSizePixel=0 mapFrame.Parent=sg
Instance.new("UICorner",mapFrame).CornerRadius=UDim.new(0,75)

local playerDot = Instance.new("Frame") playerDot.Size=UDim2.new(0,8,0,8) playerDot.AnchorPoint=Vector2.new(0.5,0.5) playerDot.Position=UDim2.new(0.5,0,0.5,0) playerDot.BackgroundColor3=Color3.fromRGB(255,255,0) playerDot.BorderSizePixel=0 playerDot.Parent=mapFrame
Instance.new("UICorner",playerDot).CornerRadius=UDim.new(1,0)

local coordLabel = Instance.new("TextLabel") coordLabel.Size=UDim2.new(1,0,0,16) coordLabel.Position=UDim2.new(0,0,1,2) coordLabel.BackgroundTransparency=1 coordLabel.TextColor3=Color3.new(1,1,1) coordLabel.TextScaled=true coordLabel.Font=Enum.Font.Gotham coordLabel.Text="0, 0" coordLabel.Parent=mapFrame

local MAP_SIZE = 500
RunService.RenderStepped:Connect(function()
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local pos = root.Position
	local nx = (pos.X + MAP_SIZE/2) / MAP_SIZE
	local nz = (pos.Z + MAP_SIZE/2) / MAP_SIZE
	playerDot.Position = UDim2.new(math.clamp(nx,0,1),0,math.clamp(nz,0,1),0)
	coordLabel.Text = ("%d, %d"):format(math.floor(pos.X), math.floor(pos.Z))
end)
