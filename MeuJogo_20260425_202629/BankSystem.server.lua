-- BankSystem.server.lua
-- Banco: conta, depósito, saque, empréstimo

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local depositEvent  = Instance.new("RemoteEvent")    depositEvent.Name  = "BankDeposit"  depositEvent.Parent  = remotes
local withdrawEvent = Instance.new("RemoteEvent")    withdrawEvent.Name = "BankWithdraw" withdrawEvent.Parent = remotes
local loanEvent     = Instance.new("RemoteEvent")    loanEvent.Name     = "BankLoan"     loanEvent.Parent     = remotes
local payLoanEvent  = Instance.new("RemoteEvent")    payLoanEvent.Name  = "PayLoan"      payLoanEvent.Parent  = remotes
local bankInfoFn    = Instance.new("RemoteFunction") bankInfoFn.Name    = "GetBankInfo"  bankInfoFn.Parent    = remotes

local accounts = {}  -- userId → { balance, loan }

Players.PlayerAdded:Connect(function(p)
	accounts[p.UserId] = { balance = 0, loan = 0 }
end)
Players.PlayerRemoving:Connect(function(p) accounts[p.UserId] = nil end)

bankInfoFn.OnServerInvoke = function(player)
	return accounts[player.UserId]
end

depositEvent.OnServerEvent:Connect(function(player, amount)
	if type(amount) ~= "number" or amount <= 0 then return end
	-- Remove da carteira (MoneySystem) e adiciona ao banco
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, amount) end
	accounts[player.UserId].balance += amount
	print(("[Banco] %s depositou R$%d"):format(player.Name, amount))
end)

withdrawEvent.OnServerEvent:Connect(function(player, amount)
	if type(amount) ~= "number" or amount <= 0 then return end
	local acc = accounts[player.UserId]
	if acc.balance < amount then warn("[Banco] Saldo insuficiente") return end
	acc.balance -= amount
	local addMoney = remotes:FindFirstChild("AddMoney")
	if addMoney then addMoney:FireServer(player, amount) end
	print(("[Banco] %s sacou R$%d"):format(player.Name, amount))
end)

loanEvent.OnServerEvent:Connect(function(player, amount)
	if type(amount) ~= "number" or amount <= 0 or amount > 10000 then return end
	local acc = accounts[player.UserId]
	if acc.loan > 0 then warn("[Banco] Já tem empréstimo ativo") return end
	acc.loan = math.floor(amount * 1.2)  -- 20% de juros
	local addMoney = remotes:FindFirstChild("AddMoney")
	if addMoney then addMoney:FireServer(player, amount) end
	print(("[Banco] %s pegou empréstimo de R$%d (deve R$%d)"):format(player.Name, amount, acc.loan))
end)

payLoanEvent.OnServerEvent:Connect(function(player, amount)
	local acc = accounts[player.UserId]
	if acc.loan <= 0 then return end
	amount = math.min(amount, acc.loan)
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, amount) end
	acc.loan -= amount
	print(("[Banco] %s pagou R$%d do empréstimo. Restante: R$%d"):format(player.Name, amount, acc.loan))
end)
