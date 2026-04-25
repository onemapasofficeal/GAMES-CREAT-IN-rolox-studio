local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local sg = Instance.new("ScreenGui") sg.Name="CompassGui" sg.ResetOnSpawn=false sg.Parent=playerGui

local frame = Instance.new("Frame") frame.Size=UDim2.new(0,200,0,28) frame.Position=UDim2.new(0.5,-100,0,50) frame.BackgroundColor3=Color3.fromRGB(0,0,0) frame.BackgroundTransparency=0.5 frame.BorderSizePixel=0 frame.Parent=sg
Instance.new("UICorner",frame).CornerRadius=UDim.new(0,6)

local lbl = Instance.new("TextLabel") lbl.Size=UDim2.new(1,0,1,0) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.new(1,1,1) lbl.TextScaled=true lbl.Font=Enum.Font.GothamBold lbl.Text="N" lbl.Parent=frame

local dirs = {"N","NE","L","SE","S","SO","O","NO"}
RunService.RenderStepped:Connect(function()
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local angle = math.deg(math.atan2(-root.CFrame.LookVector.Z, root.CFrame.LookVector.X))
	angle = (angle + 360) % 360
	local idx = math.floor((angle+22.5)/45) % 8 + 1
	lbl.Text = dirs[idx] .. (" | %.0f°"):format(angle)
end)
