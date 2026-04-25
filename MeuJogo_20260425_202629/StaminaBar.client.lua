local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local player = Players.LocalPlayer

local sg = Instance.new("ScreenGui") sg.Name="StaminaGui" sg.ResetOnSpawn=false sg.Parent=playerGui

local frame = Instance.new("Frame") frame.Size=UDim2.new(0,220,0,14) frame.Position=UDim2.new(0,10,1,-25) frame.BackgroundColor3=Color3.fromRGB(20,20,20) frame.BorderSizePixel=0 frame.Parent=sg
Instance.new("UICorner",frame).CornerRadius=UDim.new(0,4)

local fill = Instance.new("Frame") fill.Size=UDim2.new(1,0,1,0) fill.BackgroundColor3=Color3.fromRGB(50,200,100) fill.BorderSizePixel=0 fill.Parent=frame
Instance.new("UICorner",fill).CornerRadius=UDim.new(0,4)

local stamina = 100
local sprinting = false

RunService.RenderStepped:Connect(function(dt)
	local char = player.Character
	if not char then return end
	local hum = char:FindFirstChild("Humanoid")
	if not hum then return end

	sprinting = UIS:IsKeyDown(Enum.KeyCode.LeftShift)
	if sprinting and hum.MoveDirection.Magnitude > 0 then
		stamina = math.max(0, stamina - dt*15)
		hum.WalkSpeed = stamina > 0 and 24 or 16
	else
		stamina = math.min(100, stamina + dt*8)
		hum.WalkSpeed = 16
	end
	fill.Size = UDim2.new(stamina/100, 0, 1, 0)
	fill.BackgroundColor3 = stamina > 30 and Color3.fromRGB(50,200,100) or Color3.fromRGB(200,50,50)
end)
