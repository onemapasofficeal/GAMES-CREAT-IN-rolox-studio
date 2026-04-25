local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buyTicketEvent = Instance.new("RemoteEvent")    buyTicketEvent.Name = "BuyLotteryTicket" buyTicketEvent.Parent = remotes
local lotteryInfoFn  = Instance.new("RemoteFunction") lotteryInfoFn.Name  = "GetLotteryInfo"   lotteryInfoFn.Parent  = remotes
local lotteryResult  = Instance.new("RemoteEvent")    lotteryResult.Name  = "LotteryResult"    lotteryResult.Parent  = remotes

local TICKET_PRICE = 50
local jackpot = 1000
local tickets = {}  -- { playerName, userId, numbers }
local drawTime = tick() + 300

Players.PlayerAdded:Connect(function(p) end)

lotteryInfoFn.OnServerInvoke = function()
	return { jackpot=jackpot, ticketPrice=TICKET_PRICE, drawIn=math.max(0, math.floor(drawTime-tick())) }
end

buyTicketEvent.OnServerEvent:Connect(function(player)
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, TICKET_PRICE) end
	jackpot += TICKET_PRICE * 0.8

	local numbers = {}
	for i = 1, 6 do table.insert(numbers, math.random(1,60)) end
	table.insert(tickets, { playerName=player.Name, userId=player.UserId, numbers=numbers })
	print(("[Loteria] %s comprou bilhete"):format(player.Name))
end)

-- Sorteio periódico
task.spawn(function()
	while true do
		task.wait(300)
		if #tickets == 0 then jackpot += 500 drawTime=tick()+300 continue end

		local winningNumbers = {}
		for i = 1, 6 do table.insert(winningNumbers, math.random(1,60)) end

		local winner = tickets[math.random(1,#tickets)]
		local winnerPlayer = Players:GetPlayerByUserId(winner.userId)

		if winnerPlayer then
			local addMoney = remotes:FindFirstChild("AddMoney")
			if addMoney then addMoney:FireServer(winnerPlayer, jackpot) end
			lotteryResult:FireClient(winnerPlayer, jackpot, winningNumbers)
		end

		for _, p in ipairs(Players:GetPlayers()) do
			lotteryResult:FireClient(p, jackpot, winningNumbers, winner.playerName)
		end

		print(("[Loteria] Vencedor: %s ganhou R$%d"):format(winner.playerName, jackpot))
		jackpot = 1000
		tickets = {}
		drawTime = tick() + 300
	end
end)
