local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="LeaderboardGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,340,0,440) panel.Position=UDim2.new(0.5,-170,0.5,-220) panel.BackgroundColor3=Color3.fromRGB(18,18,18) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,220,50) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="🏅 Ranking" title.Parent=panel

local scroll = Instance.new("ScrollingFrame") scroll.Size=UDim2.new(1,-20,1,-100) scroll.Position=UDim2.new(0,10,0,50) scroll.BackgroundTransparency=1 scroll.ScrollBarThickness=4 scroll.Parent=panel
local layout = Instance.new("UIListLayout") layout.Padding=UDim.new(0,4) layout.Parent=scroll

local medals = {"🥇","🥈","🥉"}

local function refreshLeaderboard(data)
	for _, c in ipairs(scroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
	for i, entry in ipairs(data) do
		local row = Instance.new("Frame") row.Size=UDim2.new(1,0,0,44) row.BackgroundColor3=Color3.fromRGB(35,35,35) row.BorderSizePixel=0 row.Parent=scroll
		Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)

		local rankLbl = Instance.new("TextLabel") rankLbl.Size=UDim2.new(0,40,1,0) rankLbl.BackgroundTransparency=1 rankLbl.TextColor3=Color3.new(1,1,1) rankLbl.TextScaled=true rankLbl.Font=Enum.Font.GothamBold rankLbl.Text=medals[i] or tostring(i) rankLbl.Parent=row
		local nameLbl = Instance.new("TextLabel") nameLbl.Size=UDim2.new(0.5,0,1,0) nameLbl.Position=UDim2.new(0,44,0,0) nameLbl.BackgroundTransparency=1 nameLbl.TextColor3=Color3.new(1,1,1) nameLbl.TextScaled=true nameLbl.Font=Enum.Font.Gotham nameLbl.Text=entry.name nameLbl.TextXAlignment=Enum.TextXAlignment.Left nameLbl.Parent=row
		local moneyLbl = Instance.new("TextLabel") moneyLbl.Size=UDim2.new(0.4,0,1,0) moneyLbl.Position=UDim2.new(0.6,0,0,0) moneyLbl.BackgroundTransparency=1 moneyLbl.TextColor3=Color3.fromRGB(255,220,50) moneyLbl.TextScaled=true moneyLbl.Font=Enum.Font.GothamBold moneyLbl.Text="R$"..entry.money moneyLbl.Parent=row
	end
end

remotes:WaitForChild("LeaderboardUpdate").OnClientEvent:Connect(refreshLeaderboard)

local getLeaderboardFn = remotes:WaitForChild("GetLeaderboard")
local data = getLeaderboardFn:InvokeServer()
if data then refreshLeaderboard(data) end

local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0.8,0,0,38) closeBtn.Position=UDim2.new(0.1,0,1,-46) closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40) closeBtn.TextColor3=Color3.new(1,1,1) closeBtn.TextScaled=true closeBtn.Font=Enum.Font.GothamBold closeBtn.Text="Fechar" closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

_G.OpenLeaderboard = function() sg.Enabled=true end
