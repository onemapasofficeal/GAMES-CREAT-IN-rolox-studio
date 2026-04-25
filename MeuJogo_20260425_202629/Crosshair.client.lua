local Players = game:GetService("Players")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local sg = Instance.new("ScreenGui") sg.Name="CrosshairGui" sg.ResetOnSpawn=false sg.Parent=playerGui

local function line(size, pos)
	local f = Instance.new("Frame") f.Size=size f.Position=pos f.AnchorPoint=Vector2.new(0.5,0.5) f.BackgroundColor3=Color3.new(1,1,1) f.BorderSizePixel=0 f.Parent=sg
	return f
end

line(UDim2.new(0,20,0,2), UDim2.new(0.5,0,0.5,0))
line(UDim2.new(0,2,0,20), UDim2.new(0.5,0,0.5,0))
