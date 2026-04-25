local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local shootEvent   = Instance.new("RemoteEvent")    shootEvent.Name   = "Shoot"        shootEvent.Parent   = remotes
local reloadEvent  = Instance.new("RemoteEvent")    reloadEvent.Name  = "Reload"       reloadEvent.Parent  = remotes
local buyGunEvent  = Instance.new("RemoteEvent")    buyGunEvent.Name  = "BuyGun"       buyGunEvent.Parent  = remotes
local gunListFn    = Instance.new("RemoteFunction") gunListFn.Name    = "GetGunList"   gunListFn.Parent    = remotes
local hitEvent     = Instance.new("RemoteEvent")    hitEvent.Name     = "GunHit"       hitEvent.Parent     = remotes

local Guns = {
	{ id=1, name="Pistola",    price=500,  damage=25, ammo=12, reload=2 },
	{ id=2, name="Espingarda", price=1200, damage=60, ammo=6,  reload=3 },
	{ id=3, name="Rifle",      price=3000, damage=45, ammo=30, reload=2.5 },
	{ id=4, name="Sniper",     price=8000, damage=120,ammo=5,  reload=4 },
	{ id=5, name="Metralhadora",price=5000,damage=20, ammo=60, reload=3 },
}

local playerGuns  = {}  -- userId → { gunId, currentAmmo }

gunListFn.OnServerInvoke = function() return Guns end

Players.PlayerAdded:Connect(function(p) playerGuns[p.UserId]=nil end)
Players.PlayerRemoving:Connect(function(p) playerGuns[p.UserId]=nil end)

buyGunEvent.OnServerEvent:Connect(function(player, gunId)
	-- Apenas criminosos e admins podem comprar armas ilegais
	if _G.GetPlayerClass and _G.GetPlayerClass(player) == "cidadao" then
		warn("[Arma] Cidadão não pode comprar armas!")
		return
	end
	local gun = nil
	for _, g in ipairs(Guns) do if g.id==gunId then gun=g break end end
	if not gun then return end
	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, gun.price) end
	playerGuns[player.UserId] = { gunId=gunId, ammo=gun.ammo }
	print(("[Arma] %s comprou %s"):format(player.Name, gun.name))
end)

shootEvent.OnServerEvent:Connect(function(player, targetName)
	local data = playerGuns[player.UserId]
	if not data or data.ammo<=0 then return end

	local gun = nil
	for _, g in ipairs(Guns) do if g.id==data.gunId then gun=g break end end
	if not gun then return end

	data.ammo -= 1

	local target = Players:FindFirstChild(targetName)
	if target and target.Character then
		local hum = target.Character:FindFirstChild("Humanoid")
		if hum then
			hum.Health = math.max(0, hum.Health - gun.damage)
			hitEvent:FireClient(target, player.Name, gun.damage)
		end
	end

	-- Adiciona wanted ao atirador
	local wantedUpdate = remotes:FindFirstChild("WantedUpdate")
	print(("[Arma] %s atirou com %s (ammo: %d)"):format(player.Name, gun.name, data.ammo))
end)

reloadEvent.OnServerEvent:Connect(function(player)
	local data = playerGuns[player.UserId]
	if not data then return end
	local gun = nil
	for _, g in ipairs(Guns) do if g.id==data.gunId then gun=g break end end
	if not gun then return end
	task.wait(gun.reload)
	data.ammo = gun.ammo
	print(("[Arma] %s recarregou"):format(player.Name))
end)
