-- ClassSystem.server.lua
-- 3 classes: Cidadão, Criminoso, Admin

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

-- Admins por username
local ADMIN_NAMES = { "0p_409" }

local chooseClassEvent = Instance.new("RemoteEvent")    chooseClassEvent.Name = "ChooseClass"   chooseClassEvent.Parent = remotes
local getClassFn       = Instance.new("RemoteFunction") getClassFn.Name       = "GetClass"      getClassFn.Parent       = remotes
local classUpdate      = Instance.new("RemoteEvent")    classUpdate.Name      = "ClassUpdate"   classUpdate.Parent      = remotes

local Classes = {
	cidadao = {
		name        = "Cidadão",
		icon        = "👤",
		color       = Color3.fromRGB(100, 180, 255),
		walkSpeed   = 16,
		maxHealth   = 100,
		startMoney  = 500,
		description = "Pessoa comum. Trabalha, compra, vive.",
		perks = {
			"Acesso a todos os empregos",
			"Pode comprar casa e carro",
			"Recebe salário normal",
		},
		restrictions = {
			"Não pode roubar",
			"Não pode usar armas ilegais",
		}
	},
	criminoso = {
		name        = "Criminoso",
		icon        = "💀",
		color       = Color3.fromRGB(220, 50, 50),
		walkSpeed   = 20,
		maxHealth   = 120,
		startMoney  = 200,
		description = "Vive fora da lei. Foge da polícia.",
		perks = {
			"Velocidade maior (+4)",
			"Pode roubar jogadores",
			"Acesso a armas ilegais",
			"Pode fabricar drogas",
			"Pode hackear sistemas",
			"Bônus de 50% ao roubar",
		},
		restrictions = {
			"Sempre procurado (wanted mínimo 1)",
			"Não pode ser policial",
			"Multas maiores se preso",
		}
	},
	admin = {
		name        = "Admin",
		icon        = "⭐",
		color       = Color3.fromRGB(255, 200, 0),
		walkSpeed   = 24,
		maxHealth   = 999,
		startMoney  = 999999,
		description = "Administrador. Pode fazer qualquer coisa.",
		perks = {
			"Dinheiro ilimitado",
			"Imortal",
			"Velocidade máxima",
			"Acesso a todos os sistemas",
			"Comandos de admin",
			"Pode banir jogadores",
		},
		restrictions = {}
	}
}

local playerClasses = {}  -- userId → classKey

local function isAdmin(player)
	for _, name in ipairs(ADMIN_NAMES) do
		if player.Name == name then return true end
	end
	return false
end

local function applyClass(player, classKey)
	local class = Classes[classKey]
	if not class then return end

	playerClasses[player.UserId] = classKey

	-- Aplica atributos ao personagem
	local char = player.Character or player.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")
	hum.WalkSpeed = class.walkSpeed
	hum.MaxHealth = class.maxHealth
	hum.Health    = class.maxHealth

	-- Cor do nome no billboard
	local head = char:FindFirstChild("Head")
	if head then
		local existing = head:FindFirstChild("ClassGui")
		if existing then existing:Destroy() end

		local bb = Instance.new("BillboardGui") bb.Name="ClassGui" bb.Size=UDim2.new(0,120,0,22) bb.StudsOffset=Vector3.new(0,2.5,0) bb.Parent=head
		local lbl = Instance.new("TextLabel") lbl.Size=UDim2.new(1,0,1,0) lbl.BackgroundTransparency=1 lbl.TextColor3=class.color lbl.TextScaled=true lbl.Font=Enum.Font.GothamBold lbl.Text=class.icon.." "..class.name lbl.Parent=bb
	end

	-- Dinheiro inicial
	local ls = player:FindFirstChild("leaderstats")
	if ls and ls:FindFirstChild("Dinheiro") then
		ls.Dinheiro.Value = class.startMoney
	end

	-- Wanted mínimo para criminoso
	if classKey == "criminoso" then
		local wantedUpdate = remotes:FindFirstChild("WantedUpdate")
		if wantedUpdate then wantedUpdate:FireClient(player, 1) end
	end

	classUpdate:FireClient(player, classKey, class)
	print(("[Classe] %s escolheu: %s"):format(player.Name, class.name))
end

Players.PlayerAdded:Connect(function(player)
	-- Admin automático
	if isAdmin(player) then
		playerClasses[player.UserId] = "admin"
		player.CharacterAdded:Connect(function()
			task.wait(1)
			applyClass(player, "admin")
		end)
		return
	end

	-- Aguarda escolha de classe
	playerClasses[player.UserId] = nil

	player.CharacterAdded:Connect(function()
		task.wait(1)
		-- Se ainda não escolheu, aplica cidadão por padrão após 10s
		task.delay(10, function()
			if not playerClasses[player.UserId] then
				applyClass(player, "cidadao")
			end
		end)
	end)
end)

Players.PlayerRemoving:Connect(function(p) playerClasses[p.UserId] = nil end)

getClassFn.OnServerInvoke = function(player)
	local classKey = playerClasses[player.UserId] or "cidadao"
	return classKey, Classes[classKey], Classes
end

chooseClassEvent.OnServerEvent:Connect(function(player, classKey)
	-- Admin só pode ser definido pelo servidor
	if classKey == "admin" and not isAdmin(player) then
		warn("[Classe] "..player.Name.." tentou ser admin sem permissão!")
		return
	end
	if not Classes[classKey] then return end
	-- Só pode escolher uma vez (ou trocar pagando)
	if playerClasses[player.UserId] and playerClasses[player.UserId] ~= classKey then
		local removeMoney = remotes:FindFirstChild("RemoveMoney")
		if removeMoney then removeMoney:FireServer(player, 1000) end
	end
	applyClass(player, classKey)
end)

-- Verifica permissões de ação por classe
_G.HasClassPermission = function(player, action)
	local classKey = playerClasses[player.UserId] or "cidadao"
	if classKey == "admin" then return true end

	local criminalOnly = { "Rob", "MakeDrug", "SellDrug", "Hack", "BuyGun", "MeleeAttack" }
	local citizenBlocked = { "Rob", "MakeDrug", "SellDrug", "Hack" }

	if classKey == "cidadao" then
		for _, a in ipairs(citizenBlocked) do
			if a == action then return false end
		end
	end

	return true
end

_G.GetPlayerClass = function(player)
	return playerClasses[player.UserId] or "cidadao"
end
