local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="VehicleMenuGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,400,0,460) panel.Position=UDim2.new(0.5,-200,0.5,-230) panel.BackgroundColor3=Color3.fromRGB(18,18,18) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,220,50) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="🚗 Veículos" title.Parent=panel

local scroll = Instance.new("ScrollingFrame") scroll.Size=UDim2.new(1,-20,1,-100) scroll.Position=UDim2.new(0,10,0,50) scroll.BackgroundTransparency=1 scroll.ScrollBarThickness=4 scroll.Parent=panel
Instance.new("UIListLayout",scroll).Padding=UDim.new(0,6)

local carListFn = remotes:WaitForChild("GetCarList")
local cars = carListFn:InvokeServer()

for _, car in ipairs(cars) do
	local row = Instance.new("Frame") row.Size=UDim2.new(1,0,0,60) row.BackgroundColor3=Color3.fromRGB(35,35,35) row.BorderSizePixel=0 row.Parent=scroll
	Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)

	local colorDot = Instance.new("Frame") colorDot.Size=UDim2.new(0,20,0,20) colorDot.Position=UDim2.new(0,8,0.5,-10) colorDot.BackgroundColor3=car.color colorDot.BorderSizePixel=0 colorDot.Parent=row
	Instance.new("UICorner",colorDot).CornerRadius=UDim.new(1,0)

	local nameLbl = Instance.new("TextLabel") nameLbl.Size=UDim2.new(0.4,0,0.5,0) nameLbl.Position=UDim2.new(0,36,0,0) nameLbl.BackgroundTransparency=1 nameLbl.TextColor3=Color3.new(1,1,1) nameLbl.TextScaled=true nameLbl.Font=Enum.Font.GothamBold nameLbl.Text=car.name nameLbl.TextXAlignment=Enum.TextXAlignment.Left nameLbl.Parent=row
	local infoLbl = Instance.new("TextLabel") infoLbl.Size=UDim2.new(0.4,0,0.5,0) infoLbl.Position=UDim2.new(0,36,0.5,0) infoLbl.BackgroundTransparency=1 infoLbl.TextColor3=Color3.fromRGB(180,180,180) infoLbl.TextScaled=true infoLbl.Font=Enum.Font.Gotham infoLbl.Text=("R$%d | %dkm/h"):format(car.price,car.speed) infoLbl.TextXAlignment=Enum.TextXAlignment.Left infoLbl.Parent=row

	local buyBtn = Instance.new("TextButton") buyBtn.Size=UDim2.new(0,80,0,34) buyBtn.Position=UDim2.new(1,-170,0.5,-17) buyBtn.BackgroundColor3=Color3.fromRGB(40,100,40) buyBtn.TextColor3=Color3.new(1,1,1) buyBtn.TextScaled=true buyBtn.Font=Enum.Font.GothamBold buyBtn.Text="Comprar" buyBtn.Parent=row
	Instance.new("UICorner",buyBtn).CornerRadius=UDim.new(0,6)

	local useBtn = Instance.new("TextButton") useBtn.Size=UDim2.new(0,70,0,34) useBtn.Position=UDim2.new(1,-86,0.5,-17) useBtn.BackgroundColor3=Color3.fromRGB(40,60,140) useBtn.TextColor3=Color3.new(1,1,1) useBtn.TextScaled=true useBtn.Font=Enum.Font.GothamBold useBtn.Text="Usar" useBtn.Parent=row
	Instance.new("UICorner",useBtn).CornerRadius=UDim.new(0,6)

	local id = car.id
	buyBtn.MouseButton1Click:Connect(function() remotes:WaitForChild("BuyCar"):FireServer(id) end)
	useBtn.MouseButton1Click:Connect(function() remotes:WaitForChild("EnterCar"):FireServer(id) sg.Enabled=false end)
end

local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0.8,0,0,38) closeBtn.Position=UDim2.new(0.1,0,1,-46) closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40) closeBtn.TextColor3=Color3.new(1,1,1) closeBtn.TextScaled=true closeBtn.Font=Enum.Font.GothamBold closeBtn.Text="Fechar" closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

_G.OpenVehicleMenu = function() sg.Enabled=true end
