local Players = game:GetService("Players")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local sg = Instance.new("ScreenGui") sg.Name="PlayerListGui" sg.ResetOnSpawn=false sg.Parent=playerGui

local frame = Instance.new("Frame") frame.Size=UDim2.new(0,180,0,200) frame.Position=UDim2.new(1,-190,0.5,-100) frame.BackgroundColor3=Color3.fromRGB(15,15,15) frame.BackgroundTransparency=0.3 frame.BorderSizePixel=0 frame.Visible=false frame.Parent=sg
Instance.new("UICorner",frame).CornerRadius=UDim.new(0,8)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,30) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,220,50) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="Jogadores" title.Parent=frame

local list = Instance.new("ScrollingFrame") list.Size=UDim2.new(1,-10,1,-35) list.Position=UDim2.new(0,5,0,35) list.BackgroundTransparency=1 list.ScrollBarThickness=4 list.Parent=frame
Instance.new("UIListLayout",list).SortOrder=Enum.SortOrder.Name

local function refresh()
	for _,c in ipairs(list:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end
	for _,p in ipairs(Players:GetPlayers()) do
		local lbl = Instance.new("TextLabel") lbl.Size=UDim2.new(1,0,0,24) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.new(1,1,1) lbl.TextScaled=true lbl.Font=Enum.Font.Gotham lbl.Text="• "..p.Name lbl.Parent=list
	end
end

game:GetService("UserInputService").InputBegan:Connect(function(inp)
	if inp.KeyCode == Enum.KeyCode.Tab then frame.Visible=true refresh() end
end)
game:GetService("UserInputService").InputEnded:Connect(function(inp)
	if inp.KeyCode == Enum.KeyCode.Tab then frame.Visible=false end
end)

Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)
refresh()
