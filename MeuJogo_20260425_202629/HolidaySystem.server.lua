local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local holidayUpdate = Instance.new("RemoteEvent") holidayUpdate.Name="HolidayUpdate" holidayUpdate.Parent=remotes
local claimHolidayEvent = Instance.new("RemoteEvent") claimHolidayEvent.Name="ClaimHoliday" claimHolidayEvent.Parent=remotes

local Holidays = {
	{ name="Natal",          month=12, day=25, reward=2000, xp=200, icon="🎄" },
	{ name="Ano Novo",       month=1,  day=1,  reward=1000, xp=100, icon="🎆" },
	{ name="Carnaval",       month=2,  day=14, reward=500,  xp=50,  icon="🎭" },
	{ name="Páscoa",         month=4,  day=1,  reward=800,  xp=80,  icon="🐣" },
	{ name="Dia das Crianças",month=10,day=12, reward=600,  xp=60,  icon="🎈" },
	{ name="Halloween",      month=10, day=31, reward=700,  xp=70,  icon="🎃" },
}

local claimedHolidays = {}  -- userId → set of holiday names

Players.PlayerAdded:Connect(function(p)
	claimedHolidays[p.UserId] = {}
	-- Verifica feriado atual
	local date = os.date("*t")
	for _, h in ipairs(Holidays) do
		if h.month == date.month and h.day == date.day then
			holidayUpdate:FireClient(p, h)
			break
		end
	end
end)
Players.PlayerRemoving:Connect(function(p) claimedHolidays[p.UserId]=nil end)

claimHolidayEvent.OnServerEvent:Connect(function(player, holidayName)
	if claimedHolidays[player.UserId][holidayName] then return end

	local holiday = nil
	for _, h in ipairs(Holidays) do if h.name==holidayName then holiday=h break end end
	if not holiday then return end

	local date = os.date("*t")
	if holiday.month ~= date.month or holiday.day ~= date.day then return end

	claimedHolidays[player.UserId][holidayName] = true
	local addMoney = remotes:FindFirstChild("AddMoney")
	local addXP    = remotes:FindFirstChild("AddXP")
	if addMoney then addMoney:FireServer(player, holiday.reward) end
	if addXP    then addXP:FireServer(player, holiday.xp) end
	print(("[Feriado] %s coletou recompensa de %s"):format(player.Name, holidayName))
end)
