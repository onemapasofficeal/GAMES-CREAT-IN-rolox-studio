local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="QuestGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,400,0,480) panel.Position=UDim2.new(0.5,-200,0.5,-240) panel.BackgroundColor3=Color3.fromRGB(18,18,18) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,220,50) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="📋 Missões" title.Parent=panel

local scroll = Instance.new("ScrollingFrame") scroll.Size=UDim2.new(1,-20,1,-100) scroll.Position=UDim2.new(0,10,0,50) scroll.BackgroundTransparency=1 scroll.ScrollBarThickness=4 scroll.Parent=panel
Instance.new("UIListLayout",scroll).Padding=UDim.new(0,6)

local questListFn = remotes:WaitForChild("GetQuestList")
local quests, progress = questListFn:InvokeServer()
local questRows = {}

for _, quest in ipairs(quests) do
	local row = Instance.new("Frame") row.Size=UDim2.new(1,0,0,70) row.BackgroundColor3=Color3.fromRGB(35,35,35) row.BorderSizePixel=0 row.Parent=scroll
	Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)

	local nameLbl = Instance.new("TextLabel") nameLbl.Size=UDim2.new(0.6,0,0,24) nameLbl.Position=UDim2.new(0,8,0,4) nameLbl.BackgroundTransparency=1 nameLbl.TextColor3=Color3.new(1,1,1) nameLbl.TextScaled=true nameLbl.Font=Enum.Font.GothamBold nameLbl.Text=quest.name nameLbl.TextXAlignment=Enum.TextXAlignment.Left nameLbl.Parent=row
	local descLbl = Instance.new("TextLabel") descLbl.Size=UDim2.new(0.6,0,0,20) descLbl.Position=UDim2.new(0,8,0,28) descLbl.BackgroundTransparency=1 descLbl.TextColor3=Color3.fromRGB(180,180,180) descLbl.TextScaled=true descLbl.Font=Enum.Font.Gotham descLbl.Text=quest.desc descLbl.TextXAlignment=Enum.TextXAlignment.Left descLbl.Parent=row
	local rewardLbl = Instance.new("TextLabel") rewardLbl.Size=UDim2.new(0.6,0,0,18) rewardLbl.Position=UDim2.new(0,8,0,50) rewardLbl.BackgroundTransparency=1 rewardLbl.TextColor3=Color3.fromRGB(255,220,50) rewardLbl.TextScaled=true rewardLbl.Font=Enum.Font.Gotham rewardLbl.Text="Recompensa: R$"..quest.reward.." + "..quest.xp.."XP" rewardLbl.TextXAlignment=Enum.TextXAlignment.Left rewardLbl.Parent=row

	local btn = Instance.new("TextButton") btn.Size=UDim2.new(0,80,0,36) btn.Position=UDim2.new(1,-88,0.5,-18) btn.BackgroundColor3=Color3.fromRGB(40,80,160) btn.TextColor3=Color3.new(1,1,1) btn.TextScaled=true btn.Font=Enum.Font.GothamBold btn.Text="Aceitar" btn.Parent=row
	Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
	local id = quest.id
	btn.MouseButton1Click:Connect(function() remotes:WaitForChild("AcceptQuest"):FireServer(id) btn.Text="Ativa" btn.BackgroundColor3=Color3.fromRGB(60,60,60) end)

	questRows[quest.id] = { row=row, btn=btn }
end

remotes:WaitForChild("QuestUpdate").OnClientEvent:Connect(function(questId, prog)
	local row = questRows[questId]
	if row then
		row.btn.Text = tostring(prog)
	end
end)

local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0.8,0,0,38) closeBtn.Position=UDim2.new(0.1,0,1,-46) closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40) closeBtn.TextColor3=Color3.new(1,1,1) closeBtn.TextScaled=true closeBtn.Font=Enum.Font.GothamBold closeBtn.Text="Fechar" closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

UIS.InputBegan:Connect(function(inp,gp) if gp then return end if inp.KeyCode==Enum.KeyCode.Q then sg.Enabled=not sg.Enabled end end)
_G.OpenQuests = function() sg.Enabled=true end
