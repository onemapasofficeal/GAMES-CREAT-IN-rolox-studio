local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="GamblingGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,380,0,460) panel.Position=UDim2.new(0.5,-190,0.5,-230) panel.BackgroundColor3=Color3.fromRGB(15,10,30) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,200,0) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="🎰 Cassino" title.Parent=panel

-- Slot Machine
local slotFrame = Instance.new("Frame") slotFrame.Size=UDim2.new(0.9,0,0,100) slotFrame.Position=UDim2.new(0.05,0,0,50) slotFrame.BackgroundColor3=Color3.fromRGB(30,20,50) slotFrame.BorderSizePixel=0 slotFrame.Parent=panel
Instance.new("UICorner",slotFrame).CornerRadius=UDim.new(0,8)

local slotDisplay = Instance.new("TextLabel") slotDisplay.Size=UDim2.new(1,0,0.6,0) slotDisplay.Position=UDim2.new(0,0,0,0) slotDisplay.BackgroundTransparency=1 slotDisplay.TextColor3=Color3.new(1,1,1) slotDisplay.TextScaled=true slotDisplay.Font=Enum.Font.GothamBold slotDisplay.Text="🍒 | 🍋 | 🍊" slotDisplay.Parent=slotFrame

local slotResult = Instance.new("TextLabel") slotResult.Size=UDim2.new(1,0,0.4,0) slotResult.Position=UDim2.new(0,0,0.6,0) slotResult.BackgroundTransparency=1 slotResult.TextColor3=Color3.fromRGB(255,220,50) slotResult.TextScaled=true slotResult.Font=Enum.Font.Gotham slotResult.Text="Aposte para jogar!" slotResult.Parent=slotFrame

local betBox = Instance.new("TextBox") betBox.Size=UDim2.new(0.5,0,0,34) betBox.Position=UDim2.new(0.05,0,0,160) betBox.BackgroundColor3=Color3.fromRGB(40,30,60) betBox.TextColor3=Color3.new(1,1,1) betBox.PlaceholderText="Aposta (10-1000)" betBox.TextScaled=true betBox.Font=Enum.Font.Gotham betBox.Text="" betBox.Parent=panel
Instance.new("UICorner",betBox).CornerRadius=UDim.new(0,6)

local spinBtn = Instance.new("TextButton") spinBtn.Size=UDim2.new(0.4,0,0,34) spinBtn.Position=UDim2.new(0.57,0,0,160) spinBtn.BackgroundColor3=Color3.fromRGB(180,30,30) spinBtn.TextColor3=Color3.new(1,1,1) spinBtn.TextScaled=true spinBtn.Font=Enum.Font.GothamBold spinBtn.Text="🎰 Girar" spinBtn.Parent=panel
Instance.new("UICorner",spinBtn).CornerRadius=UDim.new(0,6)

spinBtn.MouseButton1Click:Connect(function()
	local bet = tonumber(betBox.Text) or 0
	remotes:WaitForChild("SlotMachine"):FireServer(bet)
end)

remotes:WaitForChild("SlotResult").OnClientEvent:Connect(function(s1,s2,s3,win)
	slotDisplay.Text = s1.." | "..s2.." | "..s3
	if win > 0 then
		slotResult.Text = "🎉 Ganhou R$"..win
		slotResult.TextColor3 = Color3.fromRGB(50,220,50)
	else
		slotResult.Text = "😢 Perdeu!"
		slotResult.TextColor3 = Color3.fromRGB(220,50,50)
	end
end)

-- Cara ou Coroa
local coinTitle = Instance.new("TextLabel") coinTitle.Size=UDim2.new(1,0,0,24) coinTitle.Position=UDim2.new(0,0,0,210) coinTitle.BackgroundTransparency=1 coinTitle.TextColor3=Color3.new(1,1,1) coinTitle.TextScaled=true coinTitle.Font=Enum.Font.GothamBold coinTitle.Text="🪙 Cara ou Coroa" coinTitle.Parent=panel

local coinBetBox = Instance.new("TextBox") coinBetBox.Size=UDim2.new(0.3,0,0,32) coinBetBox.Position=UDim2.new(0.05,0,0,240) coinBetBox.BackgroundColor3=Color3.fromRGB(40,30,60) coinBetBox.TextColor3=Color3.new(1,1,1) coinBetBox.PlaceholderText="Aposta" coinBetBox.TextScaled=true coinBetBox.Font=Enum.Font.Gotham coinBetBox.Text="" coinBetBox.Parent=panel
Instance.new("UICorner",coinBetBox).CornerRadius=UDim.new(0,6)

local caraBtn = Instance.new("TextButton") caraBtn.Size=UDim2.new(0.28,0,0,32) caraBtn.Position=UDim2.new(0.37,0,0,240) caraBtn.BackgroundColor3=Color3.fromRGB(40,80,160) caraBtn.TextColor3=Color3.new(1,1,1) caraBtn.TextScaled=true caraBtn.Font=Enum.Font.GothamBold caraBtn.Text="Cara" caraBtn.Parent=panel
Instance.new("UICorner",caraBtn).CornerRadius=UDim.new(0,6)

local coroaBtn = Instance.new("TextButton") coroaBtn.Size=UDim2.new(0.28,0,0,32) coroaBtn.Position=UDim2.new(0.67,0,0,240) coroaBtn.BackgroundColor3=Color3.fromRGB(160,80,40) coroaBtn.TextColor3=Color3.new(1,1,1) coroaBtn.TextScaled=true coroaBtn.Font=Enum.Font.GothamBold coroaBtn.Text="Coroa" coroaBtn.Parent=panel
Instance.new("UICorner",coroaBtn).CornerRadius=UDim.new(0,6)

local coinResultLbl = Instance.new("TextLabel") coinResultLbl.Size=UDim2.new(1,0,0,24) coinResultLbl.Position=UDim2.new(0,0,0,280) coinResultLbl.BackgroundTransparency=1 coinResultLbl.TextColor3=Color3.new(1,1,1) coinResultLbl.TextScaled=true coinResultLbl.Font=Enum.Font.Gotham coinResultLbl.Text="" coinResultLbl.Parent=panel

caraBtn.MouseButton1Click:Connect(function()
	remotes:WaitForChild("CoinFlip"):FireServer(tonumber(coinBetBox.Text) or 10, "cara")
end)
coroaBtn.MouseButton1Click:Connect(function()
	remotes:WaitForChild("CoinFlip"):FireServer(tonumber(coinBetBox.Text) or 10, "coroa")
end)

remotes:WaitForChild("CoinResult").OnClientEvent:Connect(function(result, won, bet)
	coinResultLbl.Text = result:upper().." | "..(won and "✅ +R$"..bet or "❌ Perdeu")
	coinResultLbl.TextColor3 = won and Color3.fromRGB(50,220,50) or Color3.fromRGB(220,50,50)
end)

local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0.8,0,0,38) closeBtn.Position=UDim2.new(0.1,0,1,-46) closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40) closeBtn.TextColor3=Color3.new(1,1,1) closeBtn.TextScaled=true closeBtn.Font=Enum.Font.GothamBold closeBtn.Text="Fechar" closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

_G.OpenGambling = function() sg.Enabled=true end
