local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local enterVREvent = Instance.new("RemoteEvent")    enterVREvent.Name = "EnterVR"     enterVREvent.Parent = remotes
local exitVREvent  = Instance.new("RemoteEvent")    exitVREvent.Name  = "ExitVR"      exitVREvent.Parent  = remotes
local vrListFn     = Instance.new("RemoteFunction") vrListFn.Name     = "GetVRList"   vrListFn.Parent     = remotes
local vrUpdate     = Instance.new("RemoteEvent")    vrUpdate.Name     = "VRUpdate"    vrUpdate.Parent     = remotes

local VRWorlds = {
	{ id=1, name="Mundo Fantasia",  price=200, xpBonus=50,  moneyBonus=0   },
	{ id=2, name="Simulador Cidade",price=150, xpBonus=30,  moneyBonus=100 },
	{ id=3, name="Arena de Batalha",price=300, xpBonus=100, moneyBonus=200 },
	{ id=4, name="Mundo Subaquático",price=250,xpBonus=60,  moneyBonus=0   },
	{ id=5, name="Espaço Virtual",  price=500, xpBonus=150, moneyBonus=300 },
}

local inVR = {}

Players.PlayerAdded:Connect(function(p) inVR[p.UserId]=false end)
Players.PlayerRemoving:Connect(function(p) inVR[p.UserId]=nil end)

vrListFn.OnServerInvoke = function() return VRWorlds end

enterVREvent.OnServerEvent:Connect(function(player, worldId)
	local world = nil
	for _, w in ipairs(VRWorlds) do if w.id==worldId then world=w break end end
	if not world then return end
	if inVR[player.UserId] then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, world.price) end
	inVR[player.UserId] = worldId

	vrUpdate:FireClient(player, world, true)

	-- Sessão de VR dura 60 segundos
	task.delay(60, function()
		if inVR[player.UserId] == worldId then
			inVR[player.UserId] = false
			local addXP    = remotes:FindFirstChild("AddXP")
			local addMoney = remotes:FindFirstChild("AddMoney")
			if addXP    then addXP:FireServer(player, world.xpBonus) end
			if addMoney and world.moneyBonus > 0 then addMoney:FireServer(player, world.moneyBonus) end
			vrUpdate:FireClient(player, world, false)
			print(("[VR] %s saiu de %s"):format(player.Name, world.name))
		end
	end)
	print(("[VR] %s entrou em %s"):format(player.Name, world.name))
end)

exitVREvent.OnServerEvent:Connect(function(player)
	inVR[player.UserId] = false
	vrUpdate:FireClient(player, nil, false)
end)
