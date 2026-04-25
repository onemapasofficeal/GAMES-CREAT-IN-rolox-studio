local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local setBirthdayEvent  = Instance.new("RemoteEvent")    setBirthdayEvent.Name  = "SetBirthday"   setBirthdayEvent.Parent  = remotes
local claimBirthdayEvent= Instance.new("RemoteEvent")    claimBirthdayEvent.Name= "ClaimBirthday" claimBirthdayEvent.Parent= remotes
local birthdayInfoFn    = Instance.new("RemoteFunction") birthdayInfoFn.Name    = "GetBirthdayInfo" birthdayInfoFn.Parent  = remotes
local birthdayAlert     = Instance.new("RemoteEvent")    birthdayAlert.Name     = "BirthdayAlert"  birthdayAlert.Parent    = remotes

local playerBirthdays = {}  -- userId → { month, day, claimed }

Players.PlayerAdded:Connect(function(p)
	playerBirthdays[p.UserId] = { month=nil, day=nil, claimed=false }
end)
Players.PlayerRemoving:Connect(function(p) playerBirthdays[p.UserId]=nil end)

birthdayInfoFn.OnServerInvoke = function(player)
	return playerBirthdays[player.UserId]
end

setBirthdayEvent.OnServerEvent:Connect(function(player, month, day)
	if type(month)~="number" or type(day)~="number" then return end
	if month<1 or month>12 or day<1 or day>31 then return end
	playerBirthdays[player.UserId].month = month
	playerBirthdays[player.UserId].day = day
	playerBirthdays[player.UserId].claimed = false
	print(("[Aniversário] %s definiu aniversário: %d/%d"):format(player.Name, day, month))
end)

claimBirthdayEvent.OnServerEvent:Connect(function(player)
	local data = playerBirthdays[player.UserId]
	if not data or not data.month then return end
	if data.claimed then return end

	local date = os.date("*t")
	if data.month ~= date.month or data.day ~= date.day then return end

	data.claimed = true
	local addMoney = remotes:FindFirstChild("AddMoney")
	local addXP    = remotes:FindFirstChild("AddXP")
	if addMoney then addMoney:FireServer(player, 5000) end
	if addXP    then addXP:FireServer(player, 500) end

	-- Avisa todos
	for _, p in ipairs(Players:GetPlayers()) do
		birthdayAlert:FireClient(p, player.Name)
	end
	print(("[Aniversário] Feliz aniversário, %s!"):format(player.Name))
end)
