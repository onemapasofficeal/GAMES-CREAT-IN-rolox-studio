local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="FarmGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,380,0,420) panel.Position=UDim2.new(0.5,-190,0.5,-210) panel.BackgroundColor3=Color3.fromRGB(30,50,20) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(150,220,80) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="🌾 Fazenda" title.Parent=panel

local scroll = Instance.new("ScrollingFrame") scroll.Size=UDim2.new(1,-20,1,-100) scroll.Position=UDim2.new(0,10,0,50) scroll.BackgroundTransparency=1 scroll.ScrollBarThickness=4 scroll.Parent=panel
Instance.new("UIListLayout",scroll).Padding=UDim.new(0,6)

local farmListFn = remotes:WaitForChild("GetFarmList")
local crops = farmListFn:InvokeServer()

for i, crop in ipairs(crops) do
	local row = Instance.new("Frame") row.Size=UDim2.new(1,0,0,60) row.BackgroundColor3=Color3.fromRGB(40,60,25) row.BorderSizePixel=0 row.Parent=scroll
	Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)

	local nameLbl = Instance.new("TextLabel") nameLbl.Size=UDim2.new(0.5,0,0.5,0) nameLbl.Position=UDim2.new(0,8,0,4) nameLbl.BackgroundTransparency=1 nameLbl.TextColor3=Color3.new(1,1,1) nameLbl.TextScaled=true nameLbl.Font=Enum.Font.GothamBold nameLbl.Text="🌱 "..crop.name nameLbl.TextXAlignment=Enum.TextXAlignment.Left nameLbl.Parent=row
	local infoLbl = Instance.new("TextLabel") infoLbl.Size=UDim2.new(0.5,0,0.5,0) infoLbl.Position=UDim2.new(0,8,0.5,0) infoLbl.BackgroundTransparency=1 infoLbl.TextColor3=Color3.fromRGB(180,220,100) infoLbl.TextScaled=true infoLbl.Font=Enum.Font.Gotham infoLbl.Text=("Semente: R$%d | Venda: R$%d"):format(crop.seedCost, crop.sellPrice) infoLbl.TextXAlignment=Enum.TextXAlignment.Left infoLbl.Parent=row

	local plantBtn = Instance.new("TextButton") plantBtn.Size=UDim2.new(0,80,0,36) plantBtn.Position=UDim2.new(1,-88,0.5,-18) plantBtn.BackgroundColor3=Color3.fromRGB(50,120,30) plantBtn.TextColor3=Color3.new(1,1,1) plantBtn.TextScaled=true plantBtn.Font=Enum.Font.GothamBold plantBtn.Text="Plantar" plantBtn.Parent=row
	Instance.new("UICorner",plantBtn).CornerRadius=UDim.new(0,6)
	local idx = i
	plantBtn.MouseButton1Click:Connect(function() remotes:WaitForChild("Plant"):FireServer(idx) end)
end

local harvestBtn = Instance.new("TextButton") harvestBtn.Size=UDim2.new(0.8,0,0,38) harvestBtn.Position=UDim2.new(0.1,0,1,-46) harvestBtn.BackgroundColor3=Color3.fromRGB(180,120,20) harvestBtn.TextColor3=Color3.new(1,1,1) harvestBtn.TextScaled=true harvestBtn.Font=Enum.Font.GothamBold harvestBtn.Text="🌾 Colher Tudo" harvestBtn.Parent=panel
Instance.new("UICorner",harvestBtn).CornerRadius=UDim.new(0,6)
harvestBtn.MouseButton1Click:Connect(function()
	for i = 1, 10 do remotes:WaitForChild("Harvest"):FireServer(1) end
end)

_G.OpenFarm = function() sg.Enabled=true end
