local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local slotEvent    = Instance.new("RemoteEvent")    slotEvent.Name    = "SlotMachine"  slotEvent.Parent    = remotes
local slotResult   = Instance.new("RemoteEvent")    slotResult.Name   = "SlotResult"   slotResult.Parent   = remotes
local coinFlipEvent= Instance.new("RemoteEvent")    coinFlipEvent.Name= "CoinFlip"     coinFlipEvent.Parent= remotes
local coinResult   = Instance.new("RemoteEvent")    coinResult.Name   = "CoinResult"   coinResult.Parent   = remotes
local diceEvent    = Instance.new("RemoteEvent")    diceEvent.Name    = "RollDice"     diceEvent.Parent    = remotes
local diceResult   = Instance.new("RemoteEvent")    diceResult.Name   = "DiceResult"   diceResult.Parent   = remotes

local symbols = {"🍒","🍋","🍊","⭐","💎","7️⃣"}

slotEvent.OnServerEvent:Connect(function(player, bet)
	if type(bet)~="number" or bet<10 or bet>1000 then return end
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, bet) end

	local s1 = symbols[math.random(1,#symbols)]
	local s2 = symbols[math.random(1,#symbols)]
	local s3 = symbols[math.random(1,#symbols)]

	local win = 0
	if s1==s2 and s2==s3 then
		if s3=="💎" then win=bet*10
		elseif s3=="7️⃣" then win=bet*7
		elseif s3=="⭐" then win=bet*5
		else win=bet*3 end
	elseif s1==s2 or s2==s3 then
		win=bet*1.5
	end

	if win>0 then
		local addMoney = remotes:FindFirstChild("AddMoney")
		if addMoney then addMoney:FireServer(player, math.floor(win)) end
	end

	slotResult:FireClient(player, s1, s2, s3, math.floor(win))
	print(("[Cassino] %s: %s %s %s | ganhou R$%d"):format(player.Name,s1,s2,s3,math.floor(win)))
end)

coinFlipEvent.OnServerEvent:Connect(function(player, bet, choice)
	if type(bet)~="number" or bet<10 then return end
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, bet) end

	local result = math.random(0,1)==1 and "cara" or "coroa"
	local won = result==choice
	if won then
		local addMoney = remotes:FindFirstChild("AddMoney")
		if addMoney then addMoney:FireServer(player, bet*2) end
	end
	coinResult:FireClient(player, result, won, bet)
end)

diceEvent.OnServerEvent:Connect(function(player, bet, guess)
	if type(bet)~="number" or bet<10 then return end
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, bet) end

	local roll = math.random(1,6)
	local won = roll==guess
	if won then
		local addMoney = remotes:FindFirstChild("AddMoney")
		if addMoney then addMoney:FireServer(player, bet*6) end
	end
	diceResult:FireClient(player, roll, won, bet)
end)
