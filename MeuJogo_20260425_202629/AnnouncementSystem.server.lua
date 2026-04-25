local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local announceEvent = Instance.new("RemoteEvent") announceEvent.Name="Announcement" announceEvent.Parent=remotes

local AutoAnnouncements = {
	"🎮 Bem-vindo ao The Game Realist! Divirta-se!",
	"💡 Dica: Use o táxi para se mover rapidamente pela cidade!",
	"💡 Dica: Plante e colha para ganhar dinheiro extra!",
	"💡 Dica: Deposite dinheiro no banco para ficar seguro!",
	"💡 Dica: Complete missões para ganhar recompensas!",
	"🏆 Quem será o próximo milionário?",
	"⚠ Cuidado com criminosos na área!",
	"🎰 O cassino está aberto! Tente sua sorte!",
	"🌟 Novos eventos em breve!",
	"💼 Procurando emprego? Visite o menu de empregos!",
}

-- Anúncios automáticos
task.spawn(function()
	while true do
		task.wait(math.random(120, 300))
		local msg = AutoAnnouncements[math.random(1,#AutoAnnouncements)]
		for _, p in ipairs(Players:GetPlayers()) do
			announceEvent:FireClient(p, msg, Color3.fromRGB(255,220,50))
		end
	end
end)

-- Anúncio de boas-vindas
Players.PlayerAdded:Connect(function(player)
	task.wait(2)
	announceEvent:FireClient(player, "👋 Bem-vindo, "..player.Name.."! Aproveite o jogo!", Color3.fromRGB(100,220,100))

	-- Avisa outros jogadores
	task.wait(1)
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			announceEvent:FireClient(p, "🟢 "..player.Name.." entrou no servidor!", Color3.fromRGB(100,200,100))
		end
	end
end)

Players.PlayerRemoving:Connect(function(player)
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			announceEvent:FireClient(p, "🔴 "..player.Name.." saiu do servidor.", Color3.fromRGB(200,100,100))
		end
	end
end)
