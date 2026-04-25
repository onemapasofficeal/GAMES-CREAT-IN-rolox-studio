local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="TeleportGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,360,0,460) panel.Position=UDim2.new(0.5,-180,0.5,-230) panel.BackgroundColor3=Color3.fromRGB(18,18,18) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(100,200,255) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="🗺 Mapa / Teleporte" title.Parent=panel

local scroll = Instance.new("ScrollingFrame") scroll.Size=UDim2.new(1,-20,1,-100) scroll.Position=UDim2.new(0,10,0,50) scroll.BackgroundTransparency=1 scroll.ScrollBarThickness=4 scroll.Parent=panel
Instance.new("UIListLayout",scroll).Padding=UDim.new(0,4)

local waypointListFn = remotes:WaitForChild("GetWaypoints")
local waypoints = waypointListFn:InvokeServer()

for i, wp in ipairs(waypoints) do
	local row = Instance.new("Frame") row.Size=UDim2.new(1,0,0,44) row.BackgroundColor3=Color3.fromRGB(30,30,30) row.BorderSizePixel=0 row.Parent=scroll
	Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)

	local nameLbl = Instance.new("TextLabel") nameLbl.Size=UDim2.new(0.7,0,1,0) nameLbl.Position=UDim2.new(0,8,0,0) nameLbl.BackgroundTransparency=1 nameLbl.TextColor3=Color3.new(1,1,1) nameLbl.TextScaled=true nameLbl.Font=Enum.Font.Gotham nameLbl.Text=(wp.icon or "📍").." "..wp.name nameLbl.TextXAlignment=Enum.TextXAlignment.Left nameLbl.Parent=row

	local btn = Instance.new("TextButton") btn.Size=UDim2.new(0,70,0,32) btn.Position=UDim2.new(1,-78,0.5,-16) btn.BackgroundColor3=Color3.fromRGB(40,80,160) btn.TextColor3=Color3.new(1,1,1) btn.TextScaled=true btn.Font=Enum.Font.GothamBold btn.Text="Ir (R$25)" btn.Parent=row
	Instance.new("UICorner",btn).CornerRadius=UDim.new(0,4)
	local idx = i
	btn.MouseButton1Click:Connect(function()
		remotes:WaitForChild("TeleportTo"):FireServer(idx)
		sg.Enabled=false
	end)
end

local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0.8,0,0,38) closeBtn.Position=UDim2.new(0.1,0,1,-46) closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40) closeBtn.TextColor3=Color3.new(1,1,1) closeBtn.TextScaled=true closeBtn.Font=Enum.Font.GothamBold closeBtn.Text="Fechar" closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

UIS.InputBegan:Connect(function(inp,gp) if gp then return end if inp.KeyCode==Enum.KeyCode.M then sg.Enabled=not sg.Enabled end end)
_G.OpenTeleport = function() sg.Enabled=true end
