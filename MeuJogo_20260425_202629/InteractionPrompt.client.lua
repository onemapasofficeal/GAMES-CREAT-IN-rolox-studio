local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local sg = Instance.new("ScreenGui") sg.Name="InteractGui" sg.ResetOnSpawn=false sg.Parent=playerGui

local frame = Instance.new("Frame") frame.Size=UDim2.new(0,220,0,44) frame.Position=UDim2.new(0.5,-110,0.7,0) frame.BackgroundColor3=Color3.fromRGB(0,0,0) frame.BackgroundTransparency=0.4 frame.BorderSizePixel=0 frame.Visible=false frame.Parent=sg
Instance.new("UICorner",frame).CornerRadius=UDim.new(0,8)

local lbl = Instance.new("TextLabel") lbl.Size=UDim2.new(1,0,1,0) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.new(1,1,1) lbl.TextScaled=true lbl.Font=Enum.Font.Gotham lbl.Text="[E] Interagir" lbl.Parent=frame

local INTERACT_DIST = 8
RunService.RenderStepped:Connect(function()
	local char = player.Character
	if not char then frame.Visible=false return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then frame.Visible=false return end

	local found = false
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj:FindFirstChild("Interactable") then
			if (obj.Position - root.Position).Magnitude < INTERACT_DIST then
				lbl.Text = "[E] " .. (obj:FindFirstChild("Interactable").Value or "Interagir")
				frame.Visible = true
				found = true
				break
			end
		end
	end
	if not found then frame.Visible = false end
end)
