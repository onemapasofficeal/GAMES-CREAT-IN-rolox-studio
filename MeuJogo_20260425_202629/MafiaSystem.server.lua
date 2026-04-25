local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local joinMafiaEvent    = Instance.new("RemoteEvent")    joinMafiaEvent.Name    = "JoinMafia"     joinMafiaEvent.Parent    = remotes
local extortEvent       = Instance.new("RemoteEvent")    extortEvent.Name       = "Extort"        extortEvent.Parent       = remotes
local mafiaListFn       = Instance.new("RemoteFunction") mafiaListFn.Name       = "GetMafiaList"  mafiaListFn.Parent       = remotes

local Mafias = {
	{ name="Família Rossi",  color=Color3.fromRGB(200,50,50),  territory="Norte" },
	{ name="Cartel Verde",   color=Color3.fromRGB(50,200,50),  territory="Sul"   },
	{ name="Yakuza Azul",    color=Color3.fromRGB(50,50,200),  territory="Leste" },
	{ name="Triad Dourada",  color=Color3.fromRGB(200,180,50), territory="Oeste" },
}

local playerMafia = {}
local mafiaFunds  = {}

for _, m in ipairs(Mafias) do mafiaFunds[m.name] = 0 end

Players.PlayerAdded:Connect(function(p) playerMafia[p.UserId]=nil end)
Players.PlayerRemoving:Connect(function(p) playerMafia[p.UserId]=nil end)

mafiaListFn.OnServerInvoke = function() return Mafias, mafiaFunds end

joinMafiaEvent.OnServerEvent:Connect(function(player, mafiaName)
	if playerMafia[player.UserId] then return end
	for _, m in ipairs(Mafias) do
		if m.name == mafiaName then
			playerMafia[player.UserId] = mafiaName
			print(("[Máfia] %s entrou na %s"):format(player.Name, mafiaName))
			return
		end
	end
end)

extortEvent.OnServerEvent:Connect(function(player, targetName)
	local mafiaName = playerMafia[player.UserId]
	if not mafiaName then return end

	local target = Players:FindFirstChild(targetName)
	if not target then return end

	local amount = math.random(100, 500)
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(target, amount) end

	mafiaFunds[mafiaName] = (mafiaFunds[mafiaName] or 0) + amount

	-- Distribui para membros da máfia
	local share = math.floor(amount * 0.7)
	local addMoney = remotes:FindFirstChild("AddMoney")
	if addMoney then addMoney:FireServer(player, share) end

	print(("[Máfia] %s extorquiu R$%d de %s"):format(player.Name, amount, target.Name))
end)
