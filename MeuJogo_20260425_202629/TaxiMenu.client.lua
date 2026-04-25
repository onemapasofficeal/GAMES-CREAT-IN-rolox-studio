local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="TaxiGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,360,0,440) panel.Position=UDim2.new(0.5,-180,0.5,-220) panel.BackgroundColor3=Color3.fromRGB(18,18,18) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,220,50) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="🚕 Táxi" title.Parent=panel

local scroll = Instance.new("ScrollingFrame") scroll.Size=UDim2.new(1,-20,1,-100) scroll.Position=UDim2.new(0,10,0,50) scroll.BackgroundTransparency=1 scroll.ScrollBarThickness=4 scroll.Parent=panel
Instance.new("UIListLayout",scroll).Padding=UDim.new(0,6)

local taxiListFn = remotes:WaitForChild("GetTaxiDests")
local dests = taxiListFn:InvokeServer()

for i, dest in ipairs(dests) do
	local row = Instance.new("Frame") row.Size=UDim2.new(1,0,0,50) row.BackgroundColor3=Color3.fromRGB(35,35,35) row.BorderSizePixel=0 row.Parent=scroll
	Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)

	local nameLbl = Instance.new("TextLabel") nameLbl.Size=UDim2.new(0.6,0,1,0) nameLbl.Position=UDim2.new(0,8,0,0) nameLbl.BackgroundTransparency=1 nameLbl.TextColor3=Color3.new(1,1,1) nameLbl.TextScaled=true nameLbl.Font=Enum.Font.GothamBold nameLbl.Text="📍 "..dest.name nameLbl.TextXAlignment=Enum.TextXAlignment.Left nameLbl.Parent=row
	local priceLbl = Instance.new("TextLabel") priceLbl.Size=UDim2.new(0.2,0,1,0) priceLbl.Position=UDim2.new(0.6,0,0,0) priceLbl.BackgroundTransparency=1 priceLbl.TextColor3=Color3.fromRGB(255,220,50) priceLbl.TextScaled=true priceLbl.Font=Enum.Font.Gotham priceLbl.Text="R$"..dest.price priceLbl.Parent=row

	local btn = Instance.new("TextButton") btn.Size=UDim2.new(0,70,0,34) btn.Position=UDim2.new(1,-78,0.5,-17) btn.BackgroundColor3=Color3.fromRGB(200,150,0) btn.TextColor3=Color3.new(0,0,0) btn.TextScaled=true btn.Font=Enum.Font.GothamBold btn.Text="Ir" btn.Parent=row
	Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
	local idx = i
	btn.MouseButton1Click:Connect(function()
		remotes:WaitForChild("CallTaxi"):FireServer(idx)
		sg.Enabled=false
	end)
end

local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0.8,0,0,38) closeBtn.Position=UDim2.new(0.1,0,1,-46) closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40) closeBtn.TextColor3=Color3.new(1,1,1) closeBtn.TextScaled=true closeBtn.Font=Enum.Font.GothamBold closeBtn.Text="Fechar" closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

_G.OpenTaxi = function() sg.Enabled=true end
