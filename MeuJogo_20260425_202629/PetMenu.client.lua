local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="PetGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,380,0,420) panel.Position=UDim2.new(0.5,-190,0.5,-210) panel.BackgroundColor3=Color3.fromRGB(18,18,18) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,180,100) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="🐾 Pets" title.Parent=panel

local scroll = Instance.new("ScrollingFrame") scroll.Size=UDim2.new(1,-20,1,-100) scroll.Position=UDim2.new(0,10,0,50) scroll.BackgroundTransparency=1 scroll.ScrollBarThickness=4 scroll.Parent=panel
Instance.new("UIListLayout",scroll).Padding=UDim.new(0,6)

local petListFn = remotes:WaitForChild("GetPetList")
local pets = petListFn:InvokeServer()

for _, pet in ipairs(pets) do
	local row = Instance.new("Frame") row.Size=UDim2.new(1,0,0,60) row.BackgroundColor3=Color3.fromRGB(35,35,35) row.BorderSizePixel=0 row.Parent=scroll
	Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)

	local colorDot = Instance.new("Frame") colorDot.Size=UDim2.new(0,24,0,24) colorDot.Position=UDim2.new(0,8,0.5,-12) colorDot.BackgroundColor3=pet.color colorDot.BorderSizePixel=0 colorDot.Parent=row
	Instance.new("UICorner",colorDot).CornerRadius=UDim.new(1,0)

	local nameLbl = Instance.new("TextLabel") nameLbl.Size=UDim2.new(0.45,0,0.5,0) nameLbl.Position=UDim2.new(0,40,0,4) nameLbl.BackgroundTransparency=1 nameLbl.TextColor3=Color3.new(1,1,1) nameLbl.TextScaled=true nameLbl.Font=Enum.Font.GothamBold nameLbl.Text=pet.name nameLbl.TextXAlignment=Enum.TextXAlignment.Left nameLbl.Parent=row
	local bonusLbl = Instance.new("TextLabel") bonusLbl.Size=UDim2.new(0.45,0,0.5,0) bonusLbl.Position=UDim2.new(0,40,0.5,0) bonusLbl.BackgroundTransparency=1 bonusLbl.TextColor3=Color3.fromRGB(180,180,180) bonusLbl.TextScaled=true bonusLbl.Font=Enum.Font.Gotham bonusLbl.Text="Bônus: "..pet.bonus.." | R$"..pet.price bonusLbl.TextXAlignment=Enum.TextXAlignment.Left bonusLbl.Parent=row

	local btn = Instance.new("TextButton") btn.Size=UDim2.new(0,80,0,36) btn.Position=UDim2.new(1,-88,0.5,-18) btn.BackgroundColor3=Color3.fromRGB(180,80,20) btn.TextColor3=Color3.new(1,1,1) btn.TextScaled=true btn.Font=Enum.Font.GothamBold btn.Text="Adotar" btn.Parent=row
	Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
	local id = pet.id
	btn.MouseButton1Click:Connect(function() remotes:WaitForChild("BuyPet"):FireServer(id) end)
end

local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0.8,0,0,38) closeBtn.Position=UDim2.new(0.1,0,1,-46) closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40) closeBtn.TextColor3=Color3.new(1,1,1) closeBtn.TextScaled=true closeBtn.Font=Enum.Font.GothamBold closeBtn.Text="Fechar" closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

_G.OpenPets = function() sg.Enabled=true end
