local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="InventoryGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,400,0,460) panel.Position=UDim2.new(0.5,-200,0.5,-230) panel.BackgroundColor3=Color3.fromRGB(18,18,18) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,220,50) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="🎒 Inventário" title.Parent=panel

local grid = Instance.new("Frame") grid.Size=UDim2.new(1,-20,1,-100) grid.Position=UDim2.new(0,10,0,50) grid.BackgroundTransparency=1 grid.Parent=panel
local layout = Instance.new("UIGridLayout") layout.CellSize=UDim2.new(0,72,0,72) layout.CellPadding=UDim2.new(0,6,0,6) layout.Parent=grid

local slots = {}
for i = 1, 20 do
	local slot = Instance.new("Frame") slot.Size=UDim2.new(0,72,0,72) slot.BackgroundColor3=Color3.fromRGB(35,35,35) slot.BorderSizePixel=0 slot.Parent=grid
	Instance.new("UICorner",slot).CornerRadius=UDim.new(0,6)
	local lbl = Instance.new("TextLabel") lbl.Size=UDim2.new(1,0,1,0) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.new(1,1,1) lbl.TextScaled=true lbl.Font=Enum.Font.Gotham lbl.Text="" lbl.Parent=slot
	slots[i] = {frame=slot, label=lbl}
end

local function refreshInv(inv)
	for i = 1, 20 do
		local item = inv[i]
		if item then
			slots[i].label.Text = item.name.."\nx"..item.qty
			slots[i].frame.BackgroundColor3 = Color3.fromRGB(50,70,50)
		else
			slots[i].label.Text = ""
			slots[i].frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
		end
	end
end

remotes:WaitForChild("InventoryUpdate").OnClientEvent:Connect(refreshInv)

local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0.8,0,0,38) closeBtn.Position=UDim2.new(0.1,0,1,-46) closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40) closeBtn.TextColor3=Color3.new(1,1,1) closeBtn.TextScaled=true closeBtn.Font=Enum.Font.GothamBold closeBtn.Text="Fechar" closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

UIS.InputBegan:Connect(function(inp,gp) if gp then return end if inp.KeyCode==Enum.KeyCode.I then sg.Enabled=not sg.Enabled end end)
_G.OpenInventory = function() sg.Enabled=true end
