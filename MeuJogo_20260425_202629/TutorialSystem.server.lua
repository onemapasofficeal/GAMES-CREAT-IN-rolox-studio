local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local tutorialStep  = Instance.new("RemoteEvent")    tutorialStep.Name  = "TutorialStep"    tutorialStep.Parent  = remotes
local completeTutFn = Instance.new("RemoteEvent")    completeTutFn.Name = "CompleteTutorial" completeTutFn.Parent = remotes

local TutorialSteps = {
	{ step=1, title="Bem-vindo!",         msg="Bem-vindo ao The Game Realist! Pressione M para abrir o menu principal.",  reward=100  },
	{ step=2, title="Primeiro Emprego",   msg="Vá ao menu e clique em 'Empregos' para conseguir seu primeiro emprego.",   reward=200  },
	{ step=3, title="Trabalhe!",          msg="Clique em 'Trabalhar' para ganhar seu primeiro salário.",                  reward=150  },
	{ step=4, title="Compre Comida",      msg="Vá à loja e compre algo para comer antes de ficar com fome.",              reward=100  },
	{ step=5, title="Banco",              msg="Deposite dinheiro no banco para mantê-lo seguro.",                         reward=200  },
	{ step=6, title="Explore!",           msg="Explore o mapa! Há muito para descobrir.",                                 reward=500  },
}

local playerTutorial = {}  -- userId → currentStep

Players.PlayerAdded:Connect(function(p)
	playerTutorial[p.UserId] = 1
	task.wait(3)
	-- Inicia tutorial
	tutorialStep:FireClient(p, TutorialSteps[1])
end)
Players.PlayerRemoving:Connect(function(p) playerTutorial[p.UserId]=nil end)

completeTutFn.OnServerEvent:Connect(function(player)
	local step = playerTutorial[player.UserId]
	if not step then return end

	local tutStep = TutorialSteps[step]
	if tutStep then
		local addMoney = remotes:FindFirstChild("AddMoney")
		if addMoney then addMoney:FireServer(player, tutStep.reward) end
	end

	playerTutorial[player.UserId] = step + 1
	local nextStep = TutorialSteps[step + 1]
	if nextStep then
		tutorialStep:FireClient(player, nextStep)
	else
		print(("[Tutorial] %s completou o tutorial!"):format(player.Name))
	end
end)
