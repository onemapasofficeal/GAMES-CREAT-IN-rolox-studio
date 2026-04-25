-- GameSetup.server.lua
-- Configura o mapa e ambiente do jogo

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(ReplicatedStorage:WaitForChild("GameConfig"))
local map = GameConfig.Map

-- Configura iluminação realista
Lighting.Ambient = map.AmbientColor
Lighting.OutdoorAmbient = map.OutdoorAmbient
Lighting.TimeOfDay = map.TimeOfDay
Lighting.FogEnd = map.FogEnd
Lighting.FogColor = map.FogColor
Lighting.GlobalShadows = true
Lighting.Brightness = 2

-- Adiciona efeitos de iluminação
local atmosphere = Instance.new("Atmosphere")
atmosphere.Density = 0.3
atmosphere.Offset = 0.1
atmosphere.Color = Color3.fromRGB(199, 170, 140)
atmosphere.Decay = Color3.fromRGB(100, 100, 100)
atmosphere.Glare = 0.1
atmosphere.Haze = 1.5
atmosphere.Parent = Lighting

local colorCorrection = Instance.new("ColorCorrectionEffect")
colorCorrection.Brightness = 0
colorCorrection.Contrast = 0.1
colorCorrection.Saturation = -0.1
colorCorrection.TintColor = Color3.fromRGB(255, 245, 235)
colorCorrection.Parent = Lighting

-- Cria o chão (baseplate realista)
local ground = Instance.new("Part")
ground.Name = "Ground"
ground.Size = Vector3.new(500, 1, 500)
ground.Position = Vector3.new(0, 0, 0)
ground.Anchored = true
ground.Material = Enum.Material.Grass
ground.Color = Color3.fromRGB(106, 127, 63)
ground.Parent = Workspace

-- Cria estrada principal
local road = Instance.new("Part")
road.Name = "MainRoad"
road.Size = Vector3.new(20, 0.2, 500)
road.Position = Vector3.new(0, 0.6, 0)
road.Anchored = true
road.Material = Enum.Material.SmoothPlastic
road.Color = Color3.fromRGB(50, 50, 50)
road.Parent = Workspace

-- Cria alguns prédios simples
local function criarPredio(pos, tamanho, cor)
	local predio = Instance.new("Part")
	predio.Size = tamanho
	predio.Position = pos
	predio.Anchored = true
	predio.Material = Enum.Material.SmoothPlastic
	predio.Color = cor
	predio.Parent = Workspace
	return predio
end

criarPredio(Vector3.new(60, 15, 0),  Vector3.new(20, 30, 20), Color3.fromRGB(180, 180, 180))
criarPredio(Vector3.new(-60, 10, 0), Vector3.new(20, 20, 20), Color3.fromRGB(200, 190, 170))
criarPredio(Vector3.new(60, 8, 50),  Vector3.new(15, 16, 15), Color3.fromRGB(160, 160, 160))
criarPredio(Vector3.new(-60, 8, 50), Vector3.new(15, 16, 15), Color3.fromRGB(190, 180, 160))

-- Spawn
local spawnPart = Instance.new("SpawnLocation")
spawnPart.Position = map.SpawnLocation
spawnPart.Size = Vector3.new(6, 1, 6)
spawnPart.Anchored = true
spawnPart.Material = Enum.Material.SmoothPlastic
spawnPart.Color = Color3.fromRGB(255, 255, 255)
spawnPart.Parent = Workspace

print("[TheGameRealist] Mapa configurado com sucesso!")
