local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="GymGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,380,0,420) panel.Position=UDim2.new(0.5,-190,0.5,-210) panel.BackgroundColor3=Color3.fromRGB(30,20,10) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,150,50) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="💪 Academia" title.Parent=panel

local scroll = Instance.new("ScrollingFrame") scroll.Size=UDim2.new(1,-20,1,-100) scroll.Position=UDim2.new(0,10,0,50) scroll.BackgroundTransparency=1 scroll.ScrollBarThickness=4 scroll.Parent=panel
Instance.new("UIListLayout",scroll).Padding=UDim.new(0,6)

local gymListFn = remotes:WaitForChild("GetGymList")
local exercises = gymListFn:InvokeServer()

for i, ex in ipairs(exercises) do
	local row = Instance.new("Frame") row.Size=UDim2.new(1,0,0,56) row.BackgroundColor3=Color3.fromRGB(40,30,15) row.BorderSizePixel=0 row.Parent=scroll
	Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)

	local nameLbl = Instance.new("TextLabel") nameLbl.Size=UDim2.new(0.55,0,0.5,0) nameLbl.Position=UDim2.new(0,8,0,4) nameLbl.BackgroundTransparency=1 nameLbl.TextColor3=Color3.new(1,1,1) nameLbl.TextScaled=true nameLbl.Font=Enum.Font.GothamBold nameLbl.Text=ex.name nameLbl.TextXAlignment=Enum.TextXAlignment.Left nameLbl.Parent=row
	local infoLbl = Instance.new("TextLabel") infoLbl.Size=UDim2.new(0.55,0,0.5,0) infoLbl.Position=UDim2.new(0,8,0.5,0) infoLbl.BackgroundTransparency=1 infoLbl.TextColor3=Color3.fromRGB(255,150,50) infoLbl.TextScaled=true infoLbl.Font=Enum.Font.Gotham infoLbl.Text=("+%dHP | +%dXP | CD:%ds"):format(ex.hpBonus,ex.xp,ex.cooldown) infoLbl.TextXAlignment=Enum.TextXAlignment.Left infoLbl.Parent=row

	local btn = Instance.new("TextButton") btn.Size=UDim2.new(0,80,0,36) btn.Position=UDim2.new(1,-88,0.5,-18) btn.BackgroundColor3=Color3.fromRGB(180,80,20) btn.TextColor3=Color3.new(1,1,1) btn.TextScaled=true btn.Font=Enum.Font.GothamBold btn.Text="Treinar" btn.Parent=row
	Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
	local idx = i
	btn.MouseButton1Click:Connect(function() remotes:WaitForChild("Workout"):FireServer(idx) end)
end

local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0.8,0,0,38) closeBtn.Position=UDim2.new(0.1,0,1,-46) closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40) closeBtn.TextColor3=Color3.new(1,1,1) closeBtn.TextScaled=true closeBtn.Font=Enum.Font.GothamBold closeBtn.Text="Fechar" closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

_G.OpenGym = function() sg.Enabled=true end
