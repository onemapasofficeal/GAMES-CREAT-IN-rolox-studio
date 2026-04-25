-- MapGenerator.server.lua
-- Gera o mapa completo via código usando Parts nativas

local Workspace = game:GetService("Workspace")
local Map = Instance.new("Folder")
Map.Name = "Map"
Map.Parent = Workspace

local function part(name, size, pos, color, parent, anchor)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Position = pos
	p.BrickColor = BrickColor.new(color)
	p.Material = Enum.Material.SmoothPlastic
	p.Anchored = anchor ~= false
	p.Parent = parent or Map
	return p
end

local function wedge(name, size, pos, color, rot, parent)
	local w = Instance.new("WedgePart")
	w.Name = name
	w.Size = size
	w.CFrame = CFrame.new(pos) * CFrame.Angles(0, math.rad(rot or 0), 0)
	w.BrickColor = BrickColor.new(color)
	w.Material = Enum.Material.SmoothPlastic
	w.Anchored = true
	w.Parent = parent or Map
	return w
end

local function label(text, pos, parent)
	local p = Instance.new("Part")
	p.Size = Vector3.new(0.1, 0.1, 0.1)
	p.Position = pos
	p.Anchored = true
	p.CanCollide = false
	p.Transparency = 1
	p.Parent = parent or Map
	local b = Instance.new("BillboardGui", p)
	b.Size = UDim2.new(0, 120, 0, 40)
	b.AlwaysOnTop = false
	local t = Instance.new("TextLabel", b)
	t.Size = UDim2.new(1,0,1,0)
	t.Text = text
	t.TextColor3 = Color3.new(1,1,1)
	t.BackgroundTransparency = 1
	t.TextScaled = true
	t.Font = Enum.Font.GothamBold
end

-- ========================
-- TERRENO BASE
-- ========================
local terrain = Workspace:FindFirstChildOfClass("Terrain")
if terrain then
	terrain:FillBlock(CFrame.new(0, -3, 0), Vector3.new(1200, 6, 1200), Enum.Material.Grass)
	terrain:FillBlock(CFrame.new(0, -3, 0), Vector3.new(1200, 2, 1200), Enum.Material.Ground)
	-- Oceano ao redor
	terrain:FillBlock(CFrame.new(700, -10, 0), Vector3.new(400, 20, 1600), Enum.Material.Water)
	terrain:FillBlock(CFrame.new(-700, -10, 0), Vector3.new(400, 20, 1600), Enum.Material.Water)
	terrain:FillBlock(CFrame.new(0, -10, 700), Vector3.new(1600, 20, 400), Enum.Material.Water)
	terrain:FillBlock(CFrame.new(0, -10, -700), Vector3.new(1600, 20, 400), Enum.Material.Water)
	-- Montanha
	terrain:FillBlock(CFrame.new(-200, 30, -200), Vector3.new(150, 80, 150), Enum.Material.Rock)
	terrain:FillBlock(CFrame.new(-200, 60, -200), Vector3.new(80, 40, 80), Enum.Material.Snow)
end

-- ========================
-- ESTRADAS PRINCIPAIS
-- ========================
local Roads = Instance.new("Folder", Map); Roads.Name = "Roads"
-- Avenida horizontal principal
for i = -5, 5 do
	local r = part("Road_H_"..i, Vector3.new(100, 0.5, 20), Vector3.new(i*100, 0.3, 0), "Dark grey", Roads)
	r.Material = Enum.Material.SmoothPlastic
	-- Faixa amarela central
	local line = part("Line_H_"..i, Vector3.new(80, 0.6, 1), Vector3.new(i*100, 0.4, 0), "Bright yellow", Roads)
end
-- Avenida vertical principal
for i = -5, 5 do
	local r = part("Road_V_"..i, Vector3.new(20, 0.5, 100), Vector3.new(0, 0.3, i*100), "Dark grey", Roads)
	r.Material = Enum.Material.SmoothPlastic
	local line = part("Line_V_"..i, Vector3.new(1, 0.6, 80), Vector3.new(0, 0.4, i*100), "Bright yellow", Roads)
end
-- Ruas secundárias
for i = -2, 2 do
	part("Road_SH_"..i, Vector3.new(500, 0.5, 12), Vector3.new(0, 0.3, i*80+40), "Dark grey", Roads)
	part("Road_SV_"..i, Vector3.new(12, 0.5, 500), Vector3.new(i*80+40, 0.3, 0), "Dark grey", Roads)
end

-- ========================
-- CASAS MODERNAS
-- ========================
local Houses = Instance.new("Folder", Map); Houses.Name = "Houses"

local function buildHouse(pos, folder)
	local f = Instance.new("Folder", folder)
	f.Name = "House_"..pos.X.."_"..pos.Z
	-- Base
	part("Base", Vector3.new(20, 1, 20), pos + Vector3.new(0, 0.5, 0), "Light grey", f)
	-- Paredes
	part("Wall_F", Vector3.new(20, 8, 1), pos + Vector3.new(0, 5, -10), "White", f)
	part("Wall_B", Vector3.new(20, 8, 1), pos + Vector3.new(0, 5, 10), "White", f)
	part("Wall_L", Vector3.new(1, 8, 20), pos + Vector3.new(-10, 5, 0), "White", f)
	part("Wall_R", Vector3.new(1, 8, 20), pos + Vector3.new(10, 5, 0), "White", f)
	-- Teto plano moderno
	part("Roof", Vector3.new(22, 1, 22), pos + Vector3.new(0, 9.5, 0), "Dark grey", f)
	-- Janelas
	local win = part("Window_F", Vector3.new(6, 4, 0.2), pos + Vector3.new(4, 5, -10.1), "Cyan", f)
	win.Material = Enum.Material.Glass
	win.Transparency = 0.5
	local win2 = part("Window_F2", Vector3.new(6, 4, 0.2), pos + Vector3.new(-4, 5, -10.1), "Cyan", f)
	win2.Material = Enum.Material.Glass
	win2.Transparency = 0.5
	-- Porta
	part("Door", Vector3.new(3, 5, 0.3), pos + Vector3.new(0, 3, -10.2), "Dark orange", f)
	-- Garagem
	part("Garage", Vector3.new(8, 5, 6), pos + Vector3.new(6, 3, 13), "Light grey", f)
	part("GarageDoor", Vector3.new(7, 4, 0.3), pos + Vector3.new(6, 3, 10.1), "Dark grey", f)
	-- Piscina
	local pool = part("Pool", Vector3.new(8, 0.5, 5), pos + Vector3.new(-5, 0.5, 13), "Cyan", f)
	pool.Material = Enum.Material.Neon
	pool.Transparency = 0.4
	label(f.Name, pos + Vector3.new(0, 12, 0), f)
end

local housePositions = {
	Vector3.new(80, 0, 80), Vector3.new(130, 0, 80), Vector3.new(180, 0, 80),
	Vector3.new(80, 0, 130), Vector3.new(130, 0, 130), Vector3.new(180, 0, 130),
	Vector3.new(80, 0, 180), Vector3.new(130, 0, 180), Vector3.new(180, 0, 180),
	Vector3.new(-80, 0, 80), Vector3.new(-130, 0, 80), Vector3.new(-180, 0, 80),
	Vector3.new(-80, 0, 130), Vector3.new(-130, 0, 130), Vector3.new(-180, 0, 130),
}
for _, pos in ipairs(housePositions) do buildHouse(pos, Houses) end

-- ========================
-- PRÉDIOS COMERCIAIS
-- ========================
local Buildings = Instance.new("Folder", Map); Buildings.Name = "Buildings"

local function buildBuilding(pos, height, color, name, folder)
	local f = Instance.new("Folder", folder)
	f.Name = name
	part("Base", Vector3.new(24, height, 24), pos + Vector3.new(0, height/2, 0), color, f)
	-- Janelas em grade
	for row = 1, math.floor(height/6) do
		for col = -1, 1 do
			local w = part("Win_"..row.."_"..col, Vector3.new(4, 3, 0.2),
				pos + Vector3.new(col*7, row*6-2, -12.1), "Cyan", f)
			w.Material = Enum.Material.Glass
			w.Transparency = 0.4
		end
	end
	part("Roof", Vector3.new(26, 1, 26), pos + Vector3.new(0, height+0.5, 0), "Dark grey", f)
	label(name, pos + Vector3.new(0, height+4, 0), f)
end

buildBuilding(Vector3.new(-80, 0, -80), 30, "Medium grey", "ShoppingCenter", Buildings)
buildBuilding(Vector3.new(-130, 0, -80), 20, "White", "OfficeBuilding", Buildings)
buildBuilding(Vector3.new(-80, 0, -140), 25, "Light blue grey", "Apartments", Buildings)
buildBuilding(Vector3.new(80, 0, -80), 15, "White", "Hotel", Buildings)
buildBuilding(Vector3.new(130, 0, -80), 12, "Bright red", "Restaurant", Buildings)

-- ========================
-- HOSPITAL
-- ========================
local Hosp = Instance.new("Folder", Map); Hosp.Name = "Hospital"
part("HospBase", Vector3.new(40, 15, 30), Vector3.new(200, 7.5, -80), "White", Hosp)
part("HospRoof", Vector3.new(42, 1, 32), Vector3.new(200, 15.5, -80), "Light grey", Hosp)
part("HospCross_H", Vector3.new(12, 0.5, 3), Vector3.new(200, 16, -80), "Bright red", Hosp)
part("HospCross_V", Vector3.new(3, 0.5, 12), Vector3.new(200, 16, -80), "Bright red", Hosp)
part("HospSign", Vector3.new(10, 4, 0.5), Vector3.new(200, 10, -95.5), "Bright red", Hosp)
label("🏥 Hospital", Vector3.new(200, 20, -80), Hosp)

-- ========================
-- DELEGACIA
-- ========================
local Police = Instance.new("Folder", Map); Police.Name = "PoliceStation"
part("PolBase", Vector3.new(35, 12, 25), Vector3.new(-200, 6, -80), "Medium blue", Police)
part("PolRoof", Vector3.new(37, 1, 27), Vector3.new(-200, 12.5, -80), "Dark grey", Police)
part("PolSign", Vector3.new(10, 4, 0.5), Vector3.new(-200, 8, -92.5), "Dark blue", Police)
label("🚔 Delegacia", Vector3.new(-200, 16, -80), Police)

-- ========================
-- AEROPORTO
-- ========================
local Airport = Instance.new("Folder", Map); Airport.Name = "Airport"
-- Pista
part("Runway", Vector3.new(20, 0.5, 300), Vector3.new(350, 0.3, 0), "Dark grey", Airport)
-- Linhas da pista
for i = -6, 6 do
	part("RunwayLine_"..i, Vector3.new(2, 0.6, 15), Vector3.new(350, 0.4, i*20), "White", Airport)
end
-- Terminal
part("Terminal", Vector3.new(80, 15, 40), Vector3.new(350, 7.5, -180), "White", Airport)
part("TerminalRoof", Vector3.new(82, 2, 42), Vector3.new(350, 16, -180), "Light grey", Airport)
-- Torre de controle
part("Tower", Vector3.new(8, 40, 8), Vector3.new(320, 20, -160), "White", Airport)
part("TowerTop", Vector3.new(14, 5, 14), Vector3.new(320, 42.5, -160), "Cyan", Airport)
label("✈ Aeroporto", Vector3.new(350, 20, -180), Airport)

-- ========================
-- PARQUE
-- ========================
local Park = Instance.new("Folder", Map); Park.Name = "Park"
part("ParkGround", Vector3.new(120, 0.5, 120), Vector3.new(0, 0.3, 250), "Bright green", Park)
-- Lago
local lake = part("Lake", Vector3.new(40, 1, 30), Vector3.new(-20, 0.6, 250), "Cyan", Park)
lake.Material = Enum.Material.Neon
lake.Transparency = 0.5
-- Árvores
local function tree(pos, folder)
	part("Trunk_"..pos.X, Vector3.new(2, 8, 2), pos + Vector3.new(0, 4, 0), "Reddish brown", folder)
	local top = part("Top_"..pos.X, Vector3.new(8, 10, 8), pos + Vector3.new(0, 12, 0), "Bright green", folder)
	top.Shape = Enum.PartType.Ball
end
local treePos = {
	Vector3.new(-40,0,220), Vector3.new(-30,0,240), Vector3.new(-50,0,260),
	Vector3.new(30,0,230), Vector3.new(40,0,250), Vector3.new(20,0,270),
	Vector3.new(50,0,220), Vector3.new(-10,0,280), Vector3.new(10,0,230),
}
for _, p in ipairs(treePos) do tree(p, Park) end
-- Banco do parque
part("Bench1", Vector3.new(6, 1, 2), Vector3.new(10, 1, 250), "Reddish brown", Park)
part("Bench2", Vector3.new(6, 1, 2), Vector3.new(-10, 1, 260), "Reddish brown", Park)
label("🌳 Parque", Vector3.new(0, 8, 250), Park)

-- ========================
-- ARCO DECORATIVO
-- ========================
local Arch = Instance.new("Folder", Map); Arch.Name = "Arch"
part("ArchLeft",  Vector3.new(4, 30, 4), Vector3.new(-15, 15, -30), "White", Arch)
part("ArchRight", Vector3.new(4, 30, 4), Vector3.new(15, 15, -30), "White", Arch)
part("ArchTop",   Vector3.new(34, 4, 4), Vector3.new(0, 30, -30), "White", Arch)

-- ========================
-- PAINÉIS SOLARES
-- ========================
local Solar = Instance.new("Folder", Map); Solar.Name = "SolarPanels"
for i = 0, 3 do
	local p = part("Panel_"..i, Vector3.new(10, 0.3, 6), Vector3.new(280+i*12, 3, 100), "Dark blue", Solar)
	p.Material = Enum.Material.SmoothPlastic
	p.CFrame = CFrame.new(280+i*12, 3, 100) * CFrame.Angles(math.rad(-20), 0, 0)
end

-- ========================
-- HELIPONTO
-- ========================
local Heli = Instance.new("Folder", Map); Heli.Name = "Helipad"
local hpad = part("Pad", Vector3.new(20, 0.5, 20), Vector3.new(200, 16.5, -80), "Dark grey", Heli)
part("H_Mark", Vector3.new(8, 0.6, 2), Vector3.new(200, 17, -80), "White", Heli)
part("H_Mark2", Vector3.new(2, 0.6, 8), Vector3.new(200, 17, -80), "White", Heli)
part("H_Circle", Vector3.new(18, 0.6, 18), Vector3.new(200, 17, -80), "Bright yellow", Heli)

-- ========================
-- PRAIA
-- ========================
if terrain then
	terrain:FillBlock(CFrame.new(490, 0, 0), Vector3.new(40, 2, 400), Enum.Material.Sand)
end

-- ========================
-- SUPERMERCADO
-- ========================
local Super = Instance.new("Folder", Map); Super.Name = "Supermarket"
part("SuperBase", Vector3.new(50, 10, 35), Vector3.new(-200, 5, 80), "White", Super)
part("SuperSign", Vector3.new(30, 5, 0.5), Vector3.new(-200, 12, 62.5), "Bright green", Super)
label("🛒 Supermercado", Vector3.new(-200, 16, 80), Super)

-- ========================
-- POSTO DE GASOLINA
-- ========================
local Gas = Instance.new("Folder", Map); Gas.Name = "GasStation"
part("GasBase", Vector3.new(30, 0.5, 25), Vector3.new(200, 0.3, 80), "Light grey", Gas)
part("GasRoof", Vector3.new(35, 1, 30), Vector3.new(200, 8, 80), "Dark grey", Gas)
part("GasPole1", Vector3.new(2, 8, 2), Vector3.new(190, 4, 75), "White", Gas)
part("GasPole2", Vector3.new(2, 8, 2), Vector3.new(210, 4, 75), "White", Gas)
part("GasPump1", Vector3.new(2, 4, 1), Vector3.new(195, 2, 80), "Bright red", Gas)
part("GasPump2", Vector3.new(2, 4, 1), Vector3.new(205, 2, 80), "Bright red", Gas)
label("⛽ Posto", Vector3.new(200, 12, 80), Gas)

print("✅ Mapa gerado com sucesso!")
