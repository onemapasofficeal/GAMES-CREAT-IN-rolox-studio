local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buyWeaponEvent = Instance.new("RemoteEvent")    buyWeaponEvent.Name = "BuyWeapon"    buyWeaponEvent.Parent = remotes
local weaponListFn   = Instance.new("RemoteFunction") weaponListFn.Name   = "GetWeaponList" weaponListFn.Parent   = remotes

local Weapons = {
	{ id=1,  name="Faca",         price=100,   damage=15, type="melee"  },
	{ id=2,  name="Bastão",       price=80,    damage=20, type="melee"  },
	{ id=3,  name="Espada",       price=500,   damage=40, type="melee"  },
	{ id=4,  name="Machado",      price=400,   damage=35, type="melee"  },
	{ id=5,  name="Pistola",      price=500,   damage=25, type="ranged" },
	{ id=6,  name="Espingarda",   price=1200,  damage=60, type="ranged" },
	{ id=7,  name="Rifle",        price=3000,  damage=45, type="ranged" },
	{ id=8,  name="Sniper",       price=8000,  damage=120,type="ranged" },
	{ id=9,  name="Granada",      price=2000,  damage=150,type="explosive"},
	{ id=10, name="Lança-Chamas", price=15000, damage=80, type="special"},
}

local playerWeapons = {}

Players.PlayerAdded:Connect(function(p) playerWeapons[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p) playerWeapons[p.UserId]=nil end)

weaponListFn.OnServerInvoke = function(player)
	return Weapons, playerWeapons[player.UserId] or {}
end

buyWeaponEvent.OnServerEvent:Connect(function(player, weaponId)
	local weapon = nil
	for _, w in ipairs(Weapons) do if w.id==weaponId then weapon=w break end end
	if not weapon then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, weapon.price) end
	playerWeapons[player.UserId][weaponId] = true

	local addItem = remotes:FindFirstChild("AddItem")
	if addItem then addItem:FireServer(player, weapon.name, 1) end

	print(("[Armaria] %s comprou %s"):format(player.Name, weapon.name))
end)
