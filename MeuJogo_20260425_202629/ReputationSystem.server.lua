local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local repUpdate  = Instance.new("RemoteEvent")    repUpdate.Name  = "ReputationUpdate" repUpdate.Parent  = remotes
local getRepFn   = Instance.new("RemoteFunction") getRepFn.Name   = "GetReputation"    getRepFn.Parent   = remotes

local playerRep = {}  -- userId → { good, evil, neutral }

local ReputationTiers = {
	{ name="Vilão Supremo",  min=-1000, max=-500, color=Color3.fromRGB(150,0,0)    },
	{ name="Criminoso",      min=-499,  max=-100, color=Color3.fromRGB(200,50,50)  },
	{ name="Suspeito",       min=-99,   max=-1,   color=Color3.fromRGB(200,100,50) },
	{ name="Neutro",         min=0,     max=0,    color=Color3.fromRGB(200,200,200)},
	{ name="Cidadão",        min=1,     max=99,   color=Color3.fromRGB(100,200,100)},
	{ name="Herói",          min=100,   max=499,  color=Color3.fromRGB(50,200,200) },
	{ name="Lendário",       min=500,   max=1000, color=Color3.fromRGB(255,200,0)  },
}

Players.PlayerAdded:Connect(function(p)
	playerRep[p.UserId] = 0
end)
Players.PlayerRemoving:Connect(function(p) playerRep[p.UserId]=nil end)

getRepFn.OnServerInvoke = function(player)
	local rep = playerRep[player.UserId] or 0
	local tier = ReputationTiers[4]  -- Neutro padrão
	for _, t in ipairs(ReputationTiers) do
		if rep >= t.min and rep <= t.max then tier=t break end
	end
	return rep, tier
end

_G.AddReputation = function(player, amount)
	if not playerRep[player.UserId] then return end
	playerRep[player.UserId] = math.clamp(playerRep[player.UserId] + amount, -1000, 1000)
	local rep = playerRep[player.UserId]
	local tier = ReputationTiers[4]
	for _, t in ipairs(ReputationTiers) do
		if rep >= t.min and rep <= t.max then tier=t break end
	end
	repUpdate:FireClient(player, rep, tier)
end
