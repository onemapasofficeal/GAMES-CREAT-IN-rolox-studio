local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="FishGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,320,0,360) panel.Position=UDim2.new(0.5,-160,0.5,-180) panel.BackgroundColor3=Color3.fromRGB(10,30,60) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(100,180,255) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="🎣 Pesca" title.Parent=panel

local statusLbl = Instance.new("TextLabel") statusLbl.Size=UDim2.new(1,0,0,40) statusLbl.Position=UDim2.new(0,0,0,50) statusLbl.BackgroundTransparency=1 statusLbl.TextColor3=Color3.new(1,1,1) statusLbl.TextScaled=true statusLbl.Font=Enum.Font.Gotham statusLbl.Text="Pronto para pescar!" statusLbl.Parent=panel

local fishBtn = Instance.new("TextButton") fishBtn.Size=UDim2.new(0.7,0,0,60) fishBtn.Position=UDim2.new(0.15,0,0,100) fishBtn.BackgroundColor3=Color3.fromRGB(30,80,160) fishBtn.TextColor3=Color3.new(1,1,1) fishBtn.TextScaled=true fishBtn.Font=Enum.Font.GothamBold fishBtn.Text="🎣 Pescar!" fishBtn.Parent=panel
Instance.new("UICorner",fishBtn).CornerRadius=UDim.new(0,10)

local sellBtn = Instance.new("TextButton") sellBtn.Size=UDim2.new(0.7,0,0,44) sellBtn.Position=UDim2.new(0.15,0,0,175) sellBtn.BackgroundColor3=Color3.fromRGB(40,120,40) sellBtn.TextColor3=Color3.new(1,1,1) sellBtn.TextScaled=true sellBtn.Font=Enum.Font.GothamBold sellBtn.Text="💰 Vender Peixes" sellBtn.Parent=panel
Instance.new("UICorner",sellBtn).CornerRadius=UDim.new(0,8)

local logFrame = Instance.new("ScrollingFrame") logFrame.Size=UDim2.new(0.9,0,0,100) logFrame.Position=UDim2.new(0.05,0,0,230) logFrame.BackgroundColor3=Color3.fromRGB(5,15,30) logFrame.BorderSizePixel=0 logFrame.ScrollBarThickness=3 logFrame.Parent=panel
Instance.new("UICorner",logFrame).CornerRadius=UDim.new(0,6)
local logLayout = Instance.new("UIListLayout") logLayout.VerticalAlignment=Enum.VerticalAlignment.Bottom logLayout.Parent=logFrame

local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0.5,0,0,34) closeBtn.Position=UDim2.new(0.25,0,1,-42) closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40) closeBtn.TextColor3=Color3.new(1,1,1) closeBtn.TextScaled=true closeBtn.Font=Enum.Font.GothamBold closeBtn.Text="Fechar" closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)

local fishing = false
fishBtn.MouseButton1Click:Connect(function()
	if fishing then return end
	fishing = true
	fishBtn.Text = "⏳ Pescando..."
	fishBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	statusLbl.Text = "Aguardando peixe..."
	remotes:WaitForChild("Fish"):FireServer()
end)

remotes:WaitForChild("FishResult").OnClientEvent:Connect(function(fishName, caught)
	fishing = false
	fishBtn.Text = "🎣 Pescar!"
	fishBtn.BackgroundColor3 = Color3.fromRGB(30,80,160)
	statusLbl.Text = caught and ("🐟 Pescou: "..fishName) or "😔 Nada desta vez..."

	local lbl = Instance.new("TextLabel") lbl.Size=UDim2.new(1,0,0,18) lbl.BackgroundTransparency=1 lbl.TextColor3=caught and Color3.fromRGB(100,220,100) or Color3.fromRGB(200,100,100) lbl.TextScaled=true lbl.Font=Enum.Font.Gotham lbl.Text=(caught and "✅ " or "❌ ")..fishName lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.Parent=logFrame
	logFrame.CanvasSize = UDim2.new(0,0,0,logLayout.AbsoluteContentSize.Y)
end)

sellBtn.MouseButton1Click:Connect(function() remotes:WaitForChild("SellFish"):FireServer() end)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

_G.OpenFishing = function() sg.Enabled=true end
