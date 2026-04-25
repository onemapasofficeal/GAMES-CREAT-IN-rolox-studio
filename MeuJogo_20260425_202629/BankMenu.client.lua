local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="BankMenuGui" sg.ResetOnSpawn=false sg.Enabled=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,360,0,420) panel.Position=UDim2.new(0.5,-180,0.5,-210) panel.BackgroundColor3=Color3.fromRGB(18,18,18) panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)

local title = Instance.new("TextLabel") title.Size=UDim2.new(1,0,0,44) title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,220,50) title.TextScaled=true title.Font=Enum.Font.GothamBold title.Text="🏦 Banco" title.Parent=panel

local balanceLbl = Instance.new("TextLabel") balanceLbl.Size=UDim2.new(1,0,0,30) balanceLbl.Position=UDim2.new(0,0,0,50) balanceLbl.BackgroundTransparency=1 balanceLbl.TextColor3=Color3.fromRGB(100,220,100) balanceLbl.TextScaled=true balanceLbl.Font=Enum.Font.GothamBold balanceLbl.Text="Saldo: R$0" balanceLbl.Parent=panel
local loanLbl = Instance.new("TextLabel") loanLbl.Size=UDim2.new(1,0,0,24) loanLbl.Position=UDim2.new(0,0,0,80) loanLbl.BackgroundTransparency=1 loanLbl.TextColor3=Color3.fromRGB(220,80,80) loanLbl.TextScaled=true loanLbl.Font=Enum.Font.Gotham loanLbl.Text="Dívida: R$0" loanLbl.Parent=panel

local amountBox = Instance.new("TextBox") amountBox.Size=UDim2.new(0.7,0,0,36) amountBox.Position=UDim2.new(0.15,0,0,115) amountBox.BackgroundColor3=Color3.fromRGB(40,40,40) amountBox.TextColor3=Color3.new(1,1,1) amountBox.PlaceholderText="Valor..." amountBox.TextScaled=true amountBox.Font=Enum.Font.Gotham amountBox.Text="" amountBox.Parent=panel
Instance.new("UICorner",amountBox).CornerRadius=UDim.new(0,6)

local function addBtn(txt, posY, color, fn)
	local b = Instance.new("TextButton") b.Size=UDim2.new(0.8,0,0,40) b.Position=UDim2.new(0.1,0,0,posY) b.BackgroundColor3=color b.TextColor3=Color3.new(1,1,1) b.TextScaled=true b.Font=Enum.Font.GothamBold b.Text=txt b.Parent=panel
	Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
	b.MouseButton1Click:Connect(fn)
end

local function getAmt() return tonumber(amountBox.Text) or 0 end

addBtn("💰 Depositar",  165, Color3.fromRGB(40,100,40),  function() remotes:WaitForChild("BankDeposit"):FireServer(getAmt()) end)
addBtn("💸 Sacar",      215, Color3.fromRGB(100,60,20),  function() remotes:WaitForChild("BankWithdraw"):FireServer(getAmt()) end)
addBtn("🏦 Empréstimo", 265, Color3.fromRGB(60,40,120),  function() remotes:WaitForChild("BankLoan"):FireServer(getAmt()) end)
addBtn("✅ Pagar Dívida",315, Color3.fromRGB(20,80,80),   function() remotes:WaitForChild("PayLoan"):FireServer(getAmt()) end)
addBtn("Fechar",         365, Color3.fromRGB(180,40,40),  function() sg.Enabled=false end)

local function refresh()
	local info = remotes:WaitForChild("GetBankInfo"):InvokeServer()
	if info then
		balanceLbl.Text = "Saldo: R$"..info.balance
		loanLbl.Text = "Dívida: R$"..info.loan
	end
end

_G.OpenBank = function() sg.Enabled=true refresh() end
