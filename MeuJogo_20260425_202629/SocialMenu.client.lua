local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="SocialGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,380,0,460) panel.Position=UDim2.new(0.5,-190,0.5,-230) panel.BackgroundColor3=Color3.fromRGB(18,18,18) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(100,180,255) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="👥 Social" title.Parent=panel

-- Feed de posts
local feedFrame = Instance.new("ScrollingFrame") feedFrame.Size=UDim2.new(1,-20,0,200) feedFrame.Position=UDim2.new(0,10,0,50) feedFrame.BackgroundColor3=Color3.fromRGB(25,25,25) feedFrame.BorderSizePixel=0 feedFrame.ScrollBarThickness=3 feedFrame.Parent=panel
Instance.new("UICorner",feedFrame).CornerRadius=UDim.new(0,6)
local feedLayout = Instance.new("UIListLayout") feedLayout.Parent=feedFrame

-- Caixa de post
local postBox = Instance.new("TextBox") postBox.Size=UDim2.new(0.75,0,0,36) postBox.Position=UDim2.new(0.05,0,0,260) postBox.BackgroundColor3=Color3.fromRGB(35,35,35) postBox.TextColor3=Color3.new(1,1,1) postBox.PlaceholderText="O que você está pensando?" postBox.TextScaled=true postBox.Font=Enum.Font.Gotham postBox.Text="" postBox.Parent=panel
Instance.new("UICorner",postBox).CornerRadius=UDim.new(0,6)

local postBtn = Instance.new("TextButton") postBtn.Size=UDim2.new(0.18,0,0,36) postBtn.Position=UDim2.new(0.81,0,0,260) postBtn.BackgroundColor3=Color3.fromRGB(40,80,160) postBtn.TextColor3=Color3.new(1,1,1) postBtn.TextScaled=true postBtn.Font=Enum.Font.GothamBold postBtn.Text="Post" postBtn.Parent=panel
Instance.new("UICorner",postBtn).CornerRadius=UDim.new(0,6)

postBtn.MouseButton1Click:Connect(function()
	if postBox.Text ~= "" then
		remotes:WaitForChild("SocialPost"):FireServer(postBox.Text)
		postBox.Text = ""
	end
end)

remotes:WaitForChild("FeedUpdate").OnClientEvent:Connect(function(post)
	local entry = Instance.new("Frame") entry.Size=UDim2.new(1,0,0,50) entry.BackgroundColor3=Color3.fromRGB(30,30,30) entry.BorderSizePixel=0 entry.Parent=feedFrame
	Instance.new("UICorner",entry).CornerRadius=UDim.new(0,4)
	local lbl = Instance.new("TextLabel") lbl.Size=UDim2.new(1,-10,1,0) lbl.Position=UDim2.new(0,5,0,0) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.new(1,1,1) lbl.TextScaled=true lbl.Font=Enum.Font.Gotham lbl.Text=post.author..": "..post.content lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.TextWrapped=true lbl.Parent=entry
	feedFrame.CanvasSize = UDim2.new(0,0,0,feedLayout.AbsoluteContentSize.Y)
end)

-- Botões sociais
local function addBtn(txt, posY, color, fn)
	local b = Instance.new("TextButton") b.Size=UDim2.new(0.44,0,0,38) b.Position=posY b.BackgroundColor3=color b.TextColor3=Color3.new(1,1,1) b.TextScaled=true b.Font=Enum.Font.GothamBold b.Text=txt b.Parent=panel
	Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
	b.MouseButton1Click:Connect(fn)
end

addBtn("👫 Amigos",    UDim2.new(0.05,0,0,310), Color3.fromRGB(40,80,160), function() end)
addBtn("🎉 Party",     UDim2.new(0.51,0,0,310), Color3.fromRGB(80,40,160), function() remotes:WaitForChild("CreateParty"):FireServer() end)
addBtn("💌 Flerte",    UDim2.new(0.05,0,0,358), Color3.fromRGB(160,40,80), function() end)
addBtn("🎁 Presente",  UDim2.new(0.51,0,0,358), Color3.fromRGB(40,120,40), function() end)

local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0.8,0,0,38) closeBtn.Position=UDim2.new(0.1,0,1,-46) closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40) closeBtn.TextColor3=Color3.new(1,1,1) closeBtn.TextScaled=true closeBtn.Font=Enum.Font.GothamBold closeBtn.Text="Fechar" closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

_G.OpenSocial = function() sg.Enabled=true end
