-- GameConfig.lua
-- Configurações globais do jogo

local GameConfig = {
	GameName = "The Game Realist",
	StartingMoney = 1000,
	MoneyName = "R$",
	
	-- Configurações do mapa
	Map = {
		SpawnLocation = Vector3.new(0, 5, 0),
		AmbientColor = Color3.fromRGB(180, 180, 180),
		OutdoorAmbient = Color3.fromRGB(100, 100, 100),
		TimeOfDay = "12:00:00",
		FogEnd = 1000,
		FogColor = Color3.fromRGB(200, 200, 200),
	},
	
	-- Itens compráveis
	Shop = {
		{ name = "Pão",       price = 100  },
		{ name = "Água",      price = 50   },
		{ name = "Carro",     price = 50000000000000000 },
		{ name = "Casa",      price = 200 },
	},
}

return GameConfig
