-- WeatherSystem.server.lua
-- Clima dinâmico: sol, chuva, tempestade, neve

local Lighting = game:GetService("Lighting")
local Players  = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local weatherUpdate = Instance.new("RemoteEvent")
weatherUpdate.Name  = "WeatherUpdate"
weatherUpdate.Parent = remotes

local Weathers = {
	{
		name = "Ensolarado",
		fogEnd = 2000, fogColor = Color3.fromRGB(200,200,200),
		ambient = Color3.fromRGB(180,180,180), brightness = 3,
		rainRate = 0,
	},
	{
		name = "Nublado",
		fogEnd = 800, fogColor = Color3.fromRGB(150,150,150),
		ambient = Color3.fromRGB(120,120,120), brightness = 1.5,
		rainRate = 0,
	},
	{
		name = "Chuva",
		fogEnd = 400, fogColor = Color3.fromRGB(100,100,120),
		ambient = Color3.fromRGB(80,80,100), brightness = 0.8,
		rainRate = 100,
	},
	{
		name = "Tempestade",
		fogEnd = 200, fogColor = Color3.fromRGB(60,60,80),
		ambient = Color3.fromRGB(50,50,70), brightness = 0.4,
		rainRate = 300,
	},
}

local currentWeather = Weathers[1]

local function applyWeather(w)
	currentWeather = w
	Lighting.FogEnd        = w.fogEnd
	Lighting.FogColor      = w.fogColor
	Lighting.Ambient       = w.ambient
	Lighting.Brightness    = w.brightness

	-- Notifica todos os clientes
	for _, p in ipairs(Players:GetPlayers()) do
		weatherUpdate:FireClient(p, w.name, w.rainRate)
	end
	print(("[Clima] Tempo: " .. w.name))
end

-- Muda o clima a cada 3-7 minutos
task.spawn(function()
	while true do
		task.wait(math.random(180, 420))
		local next = Weathers[math.random(1, #Weathers)]
		applyWeather(next)
	end
end)

-- Ciclo dia/noite
task.spawn(function()
	local hour = 8
	while true do
		task.wait(10)
		hour = (hour + 0.1) % 24
		Lighting.TimeOfDay = ("%02d:%02d:00"):format(math.floor(hour), math.floor((hour % 1) * 60))
	end
end)

applyWeather(Weathers[1])
