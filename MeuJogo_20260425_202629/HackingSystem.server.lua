local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local hackEvent    = Instance.new("RemoteEvent")    hackEvent.Name    = "Hack"         hackEvent.Parent    = remotes
local hackResult   = Instance.new("RemoteEvent")    hackResult.Name   = "HackResult"   hackResult.Parent   = remotes
local hackListFn   = Instance.new("RemoteFunction") hackListFn.Name   = "GetHackList"  hackListFn.Parent   = remotes

local HackTargets = {
	{ name="ATM",          reward=500,  difficulty=0.3, wanted=1, cooldown=60  },
	{ name="Banco",        reward=2000, difficulty=0.15,wanted=3, cooldown=180 },
	{ name="Câmeras",      reward=0,    difficulty=0.5, wanted=0, cooldown=30  },
	{ name="Semáforos",    reward=0,    difficulty=0.6, wanted=1, cooldown=45  },
	{ name="Sistema Policial",reward=0, difficulty=0.2, wanted=2, cooldown=120 },
}

local playerHacks = {}

Players.PlayerAdded:Connect(function(p) playerHacks[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p) playerHacks[p.UserId]=nil end)

hackListFn.OnServerInvoke = function() return HackTargets end

hackEvent.OnServerEvent:Connect(function(player, targetIndex)
	local target = HackTargets[targetIndex]
	if not target then return end

	local now = tick()
	if playerHacks[player.UserId][targetIndex] and now - playerHacks[player.UserId][targetIndex] < target.cooldown then
		hackResult:FireClient(player, false, "Cooldown ativo")
		return
	end

	playerHacks[player.UserId][targetIndex] = now

	-- Simula hacking com delay
	task.delay(math.random(3,8), function()
		local success = math.random() < target.difficulty
		if success then
			if target.reward > 0 then
				local addMoney = remotes:FindFirstChild("AddMoney")
				if addMoney then addMoney:FireServer(player, target.reward) end
			end
			hackResult:FireClient(player, true, target.name)
			print(("[Hack] %s hackeou %s"):format(player.Name, target.name))
		else
			if target.wanted > 0 then
				print(("[Hack] %s falhou e ficou procurado"):format(player.Name))
			end
			hackResult:FireClient(player, false, target.name)
		end
	end)
end)
