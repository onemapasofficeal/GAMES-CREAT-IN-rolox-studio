local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="JobMenuGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,380,0,460) panel.Position=UDim2.new(0.5,-190,0.5,-230) panel.BackgroundColor3=Color3.fromRGB(18,18,18) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,220,50) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="💼 Empregos" title.Parent=panel

local scroll = Instance.new("ScrollingFrame") scroll.Size=UDim2.new(1,-20,1,-100) scroll.Position=UDim2.new(0,10,0,50) scroll.BackgroundTransparency=1 scroll.ScrollBarThickness=4 scroll.Parent=panel
local layout = Instance.new("UIListLayout") layout.Padding=UDim.new(0,6) layout.Parent=scroll

local getJobInfoFn = remotes:WaitForChild("GetJobInfo")
local jobs = getJobInfoFn:InvokeServer()

for i, job in ipairs(jobs) do
	local row = Instance.new("Frame") row.Size=UDim2.new(1,0,0,54) row.BackgroundColor3=Color3.fromRGB(35,35,35) row.BorderSizePixel=0 row.Parent=scroll
	Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)

	local nameLbl = Instance.new("TextLabel") nameLbl.Size=UDim2.new(0.55,0,0.5,0) nameLbl.BackgroundTransparency=1 nameLbl.TextColor3=Color3.new(1,1,1) nameLbl.TextScaled=true nameLbl.Font=Enum.Font.GothamBold nameLbl.Text=job.name nameLbl.TextXAlignment=Enum.TextXAlignment.Left nameLbl.Position=UDim2.new(0,8,0,0) nameLbl.Parent=row
	local salLbl = Instance.new("TextLabel") salLbl.Size=UDim2.new(0.55,0,0.5,0) salLbl.Position=UDim2.new(0,8,0.5,0) salLbl.BackgroundTransparency=1 salLbl.TextColor3=Color3.fromRGB(100,220,100) salLbl.TextScaled=true salLbl.Font=Enum.Font.Gotham salLbl.Text=("R$%d / %ds"):format(job.salary, job.cooldown) salLbl.TextXAlignment=Enum.TextXAlignment.Left salLbl.Parent=row

	local btn = Instance.new("TextButton") btn.Size=UDim2.new(0,90,0,34) btn.Position=UDim2.new(1,-98,0.5,-17) btn.BackgroundColor3=Color3.fromRGB(40,100,40) btn.TextColor3=Color3.new(1,1,1) btn.TextScaled=true btn.Font=Enum.Font.GothamBold btn.Text="Empregar" btn.Parent=row
	Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
	local idx = i
	btn.MouseButton1Click:Connect(function()
		remotes:WaitForChild("GetJob"):FireServer(idx)
		sg.Enabled=false
	end)
end

local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0.8,0,0,38) closeBtn.Position=UDim2.new(0.1,0,1,-46) closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40) closeBtn.TextColor3=Color3.new(1,1,1) closeBtn.TextScaled=true closeBtn.Font=Enum.Font.GothamBold closeBtn.Text="Fechar" closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

_G.OpenJobMenu = function() sg.Enabled=true end
