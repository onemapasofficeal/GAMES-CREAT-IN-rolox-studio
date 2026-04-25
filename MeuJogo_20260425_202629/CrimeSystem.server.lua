-- CrimeSystem.server.lua
-- Sistema de crime: roubar, ser preso, ficar procurado

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local robEvent      = Instance.new("RemoteEvent")    robEvent.Name      = "Rob"          robEvent.Parent      = remotes
local arrestEvent   = Instance.new("RemoteEvent")    arrestEvent.Name   = "Arrest"       arrestEvent.Parent   = remotes
local wantedUpdate  = Instance.new("RemoteEvent")    wantedUpdate.Name  = "WantedUpdate" wantedUpdate.Parent  = remotes
local getWantedFn   = Instance.new("RemoteFunction") getWantedFn.Name   = "GetWanted"    getWantedFn.Parent   = remotes

local wantedLevel = {}  -- userId → 0-5
local inJail      = {}  -- userId → bool

Players.PlayerAdded:Connect(function(p)
	wantedLevel[p.UserId] = 0
	inJail[p.UserId] = false
end)
Players.PlayerRemoving:Connect(function(p)
	wantedLevel[p.UserId] = nil
	inJail[p.UserId] = nil
end)

getWantedFn.OnServerInvoke = function(player)
	return wantedLevel[player.UserId] or 0
end

local function addWanted(player, amount)
	wantedLevel[player.UserId] = math.min(5, (wantedLevel[player.UserId] or 0) + amount)
	wantedUpdate:FireClient(player, wantedLevel[player.UserId])
end

local function reduceWanted(player)
	-- Reduz wanted com o tempo
	task.spawn(function()
		while wantedLevel[player.UserId] and wantedLevel[player.UserId] > 0 do
			task.wait(60)
			wantedLevel[player.UserId] = math.max(0, wantedLevel[player.UserId] - 1)
			wantedUpdate:FireClient(player, wantedLevel[player.UserId])
		end
	end)
end

robEvent.OnServerEvent:Connect(function(player, targetName)
	-- Apenas criminosos e admins podem roubar
	if _G.GetPlayerClass and _G.GetPlayerClass(player) == "cidadao" then
		warn("[Crime] Cidadão não pode roubar!")
		return
	end
	local target = Players:FindFirstChild(targetName)
	if not target then return end

	local addMoney    = remotes:FindFirstChild("AddMoney")
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	local roubado = math.random(50, 300)

	if removeMoney then removeMoney:FireServer(target, roubado) end
	if addMoney    then addMoney:FireServer(player, roubado)    end

	addWanted(player, 2)
	reduceWanted(player)
	print(("[Crime] %s roubou R$%d de %s"):format(player.Name, roubado, target.Name))
end)

arrestEvent.OnServerEvent:Connect(function(cop, criminalName)
	local criminal = Players:FindFirstChild(criminalName)
	if not criminal then return end
	if (wantedLevel[criminal.UserId] or 0) == 0 then return end

	-- Teleporta para a cadeia
	local char = criminal.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(200, 5, 200)
	end

	-- Multa
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	local multa = wantedLevel[criminal.UserId] * 500
	if removeMoney then removeMoney:FireServer(criminal, multa) end

	wantedLevel[criminal.UserId] = 0
	wantedUpdate:FireClient(criminal, 0)
	inJail[criminal.UserId] = true

	-- Sai da cadeia após 60s
	task.delay(60, function()
		if inJail[criminal.UserId] then
			inJail[criminal.UserId] = false
			local c = criminal.Character
			if c and c:FindFirstChild("HumanoidRootPart") then
				c.HumanoidRootPart.CFrame = CFrame.new(0, 5, 0)
			end
		end
	end)

	print(("[Crime] %s prendeu %s (multa R$%d)"):format(cop.Name, criminal.Name, multa))
end)
