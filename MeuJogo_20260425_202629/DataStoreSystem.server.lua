-- Salva e carrega dados dos jogadores com DataStore
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local playerDataStore = DataStoreService:GetDataStore("TheGameRealist_v1")

local defaultData = {
	money   = 500,
	level   = 1,
	xp      = 0,
	hunger  = 100,
	thirst  = 100,
	energy  = 100,
	house   = nil,
	cars    = {},
	pets    = nil,
	playtime= 0,
}

local loadedData = {}

local function deepCopy(t)
	local copy = {}
	for k, v in pairs(t) do
		copy[k] = type(v)=="table" and deepCopy(v) or v
	end
	return copy
end

Players.PlayerAdded:Connect(function(player)
	local success, data = pcall(function()
		return playerDataStore:GetAsync("player_"..player.UserId)
	end)

	if success and data then
		loadedData[player.UserId] = data
		print(("[DataStore] Dados carregados para %s"):format(player.Name))
	else
		loadedData[player.UserId] = deepCopy(defaultData)
		print(("[DataStore] Dados padrão para %s"):format(player.Name))
	end
end)

Players.PlayerRemoving:Connect(function(player)
	local data = loadedData[player.UserId]
	if not data then return end

	local success, err = pcall(function()
		playerDataStore:SetAsync("player_"..player.UserId, data)
	end)

	if success then
		print(("[DataStore] Dados salvos para %s"):format(player.Name))
	else
		warn(("[DataStore] Erro ao salvar %s: %s"):format(player.Name, err))
	end
	loadedData[player.UserId] = nil
end)

-- Auto-save a cada 5 minutos
task.spawn(function()
	while true do
		task.wait(300)
		for _, player in ipairs(Players:GetPlayers()) do
			local data = loadedData[player.UserId]
			if data then
				pcall(function()
					playerDataStore:SetAsync("player_"..player.UserId, data)
				end)
			end
		end
		print("[DataStore] Auto-save concluído")
	end
end)

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		local data = loadedData[player.UserId]
		if data then
			pcall(function()
				playerDataStore:SetAsync("player_"..player.UserId, data)
			end)
		end
	end
end)

_G.GetPlayerData = function(player)
	return loadedData[player.UserId]
end

_G.SetPlayerData = function(player, key, value)
	if loadedData[player.UserId] then
		loadedData[player.UserId][key] = value
	end
end
