local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="NewsGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,380,0,460) panel.Position=UDim2.new(0.5,-190,0.5,-230) panel.BackgroundColor3=Color3.fromRGB(18,18,18) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,220,50) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="📰 Jornal da Cidade" title.Parent=panel

local scroll = Instance.new("ScrollingFrame") scroll.Size=UDim2.new(1,-20,1,-150) scroll.Position=UDim2.new(0,10,0,50) scroll.BackgroundTransparency=1 scroll.ScrollBarThickness=4 scroll.Parent=panel
local layout = Instance.new("UIListLayout") layout.Padding=UDim.new(0,4) layout.Parent=scroll

local function addNewsEntry(news)
	local row = Instance.new("Frame") row.Size=UDim2.new(1,0,0,60) row.BackgroundColor3=Color3.fromRGB(28,28,28) row.BorderSizePixel=0 row.Parent=scroll
	Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)
	local authorLbl = Instance.new("TextLabel") authorLbl.Size=UDim2.new(1,0,0.4,0) authorLbl.BackgroundTransparency=1 authorLbl.TextColor3=Color3.fromRGB(255,220,50) authorLbl.TextScaled=true authorLbl.Font=Enum.Font.GothamBold authorLbl.Text=news.author authorLbl.TextXAlignment=Enum.TextXAlignment.Left authorLbl.Position=UDim2.new(0,8,0,0) authorLbl.Parent=row
	local msgLbl = Instance.new("TextLabel") msgLbl.Size=UDim2.new(1,0,0.6,0) msgLbl.Position=UDim2.new(0,8,0.4,0) msgLbl.BackgroundTransparency=1 msgLbl.TextColor3=Color3.new(1,1,1) msgLbl.TextScaled=true msgLbl.Font=Enum.Font.Gotham msgLbl.Text=news.message msgLbl.TextXAlignment=Enum.TextXAlignment.Left msgLbl.TextWrapped=true msgLbl.Parent=row
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
end

-- Carrega notícias existentes
local getNewsFn = remotes:WaitForChild("GetNews")
local news = getNewsFn:InvokeServer()
if news then for _, n in ipairs(news) do addNewsEntry(n) end end

remotes:WaitForChild("NewsUpdate").OnClientEvent:Connect(addNewsEntry)

-- Publicar notícia
local publishBox = Instance.new("TextBox") publishBox.Size=UDim2.new(0.7,0,0,36) publishBox.Position=UDim2.new(0.05,0,1,-90) publishBox.BackgroundColor3=Color3.fromRGB(35,35,35) publishBox.TextColor3=Color3.new(1,1,1) publishBox.PlaceholderText="Escreva uma notícia (R$50)..." publishBox.TextScaled=true publishBox.Font=Enum.Font.Gotham publishBox.Text="" publishBox.Parent=panel
Instance.new("UICorner",publishBox).CornerRadius=UDim.new(0,6)

local publishBtn = Instance.new("TextButton") publishBtn.Size=UDim2.new(0.22,0,0,36) publishBtn.Position=UDim2.new(0.77,0,1,-90) publishBtn.BackgroundColor3=Color3.fromRGB(40,80,160) publishBtn.TextColor3=Color3.new(1,1,1) publishBtn.TextScaled=true publishBtn.Font=Enum.Font.GothamBold publishBtn.Text="Publicar" publishBtn.Parent=panel
Instance.new("UICorner",publishBtn).CornerRadius=UDim.new(0,6)
publishBtn.MouseButton1Click:Connect(function()
	if publishBox.Text ~= "" then
		remotes:WaitForChild("PublishNews"):FireServer(publishBox.Text)
		publishBox.Text = ""
	end
end)

local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0.8,0,0,38) closeBtn.Position=UDim2.new(0.1,0,1,-46) closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40) closeBtn.TextColor3=Color3.new(1,1,1) closeBtn.TextScaled=true closeBtn.Font=Enum.Font.GothamBold closeBtn.Text="Fechar" closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

_G.OpenNews = function() sg.Enabled=true end
