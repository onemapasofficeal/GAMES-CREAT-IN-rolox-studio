-- ClassHUD.client.lua
-- Mostra a classe atual e habilidades especiais no HUD

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui")
sg.Name = "ClassHudGui"
sg.ResetOnSpawn = false
sg.Parent = playerGui

-- Badge de classe (canto superior esquerdo)
local badge = Instance.new("Frame")
badge.Size = UDim2.new(0,160,0,36)
badge.Position = UDim2.new(0,10,0,10)
badge.BackgroundColor3 = Color3.fromRGB(20,20,20)
badge.BackgroundTransparency = 0.3
badge.BorderSizePixel = 0
badge.Parent = sg
Instance.new("UICorner",badge).CornerRadius = UDim.new(0,8)

local classLbl = Instance.new("TextLabel")
classLbl.Size = UDim2.new(1,0,1,0)
classLbl.BackgroundTransparency = 1
classLbl.TextColor3 = Color3.fromRGB(255,220,50)
classLbl.TextScaled = true
classLbl.Font = Enum.Font.GothamBold
classLbl.Text = "👤 Cidadão"
classLbl.Parent = badge

-- Painel de habilidades especiais (visível por classe)
local abilitiesFrame = Instance.new("Frame")
abilitiesFrame.Size = UDim2.new(0,200,0,0)
abilitiesFrame.Position = UDim2.new(0,10,0,52)
abilitiesFrame.BackgroundTransparency = 1
abilitiesFrame.Parent = sg

local abilitiesLayout = Instance.new("UIListLayout")
abilitiesLayout.Padding = UDim.new(0,4)
abilitiesLayout.Parent = abilitiesFrame

local currentClass = "cidadao"

local ClassAbilities = {
	cidadao = {
		{ name="Trabalhar",   key=Enum.KeyCode.F1, color=Color3.fromRGB(100,200,100) },
		{ name="Ligar 190",   key=Enum.KeyCode.F2, color=Color3.fromRGB(100,150,255) },
	},
	criminoso = {
		{ name="Roubar",      key=Enum.KeyCode.F1, color=Color3.fromRGB(220,50,50)   },
		{ name="Fugir",       key=Enum.KeyCode.F2, color=Color3.fromRGB(200,100,50)  },
		{ name="Hackear",     key=Enum.KeyCode.F3, color=Color3.fromRGB(50,200,100)  },
		{ name="Disfarce",    key=Enum.KeyCode.F4, color=Color3.fromRGB(150,50,200)  },
	},
	admin = {
		{ name="Dar Dinheiro",key=Enum.KeyCode.F1, color=Color3.fromRGB(255,200,0)   },
		{ name="Teleportar",  key=Enum.KeyCode.F2, color=Color3.fromRGB(255,200,0)   },
		{ name="Curar Todos", key=Enum.KeyCode.F3, color=Color3.fromRGB(255,200,0)   },
		{ name="Banir",       key=Enum.KeyCode.F4, color=Color3.fromRGB(255,200,0)   },
	},
}

local ClassColors = {
	cidadao   = Color3.fromRGB(100,180,255),
	criminoso = Color3.fromRGB(220,50,50),
	admin     = Color3.fromRGB(255,200,0),
}

local ClassIcons = {
	cidadao   = "👤",
	criminoso = "💀",
	admin     = "⭐",
}

local ClassNames = {
	cidadao   = "Cidadão",
	criminoso = "Criminoso",
	admin     = "Admin",
}

local function buildAbilities(classKey)
	-- Limpa
	for _, c in ipairs(abilitiesFrame:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end

	local abilities = ClassAbilities[classKey] or {}
	for _, ab in ipairs(abilities) do
		local row = Instance.new("Frame")
		row.Size = UDim2.new(0,160,0,28)
		row.BackgroundColor3 = Color3.fromRGB(15,15,15)
		row.BackgroundTransparency = 0.3
		row.BorderSizePixel = 0
		row.Parent = abilitiesFrame
		Instance.new("UICorner",row).CornerRadius = UDim.new(0,6)

		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1,0,1,0)
		lbl.BackgroundTransparency = 1
		lbl.TextColor3 = ab.color
		lbl.TextScaled = true
		lbl.Font = Enum.Font.Gotham
		lbl.Text = "["..ab.key.Name.."] "..ab.name
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.Position = UDim2.new(0,6,0,0)
		lbl.Parent = row
	end

	abilitiesFrame.Size = UDim2.new(0,200,0,#abilities*32)
end

local function updateClass(classKey, classData)
	currentClass = classKey
	local color = ClassColors[classKey] or Color3.fromRGB(255,255,255)
	local icon  = ClassIcons[classKey] or "👤"
	local name  = ClassNames[classKey] or classKey

	classLbl.Text = icon.." "..name
	classLbl.TextColor3 = color
	badge.BackgroundColor3 = Color3.fromRGB(20,20,20)

	buildAbilities(classKey)
end

-- Recebe atualização de classe do servidor
remotes:WaitForChild("ClassUpdate").OnClientEvent:Connect(function(classKey, classData)
	updateClass(classKey, classData)
end)

-- Pede classe atual ao entrar
task.spawn(function()
	task.wait(2)
	local classKey, classData = remotes:WaitForChild("GetClass"):InvokeServer()
	if classKey then updateClass(classKey, classData) end
end)
