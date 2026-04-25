-- JobSystem.server.lua
-- Sistema de empregos

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = ReplicatedStorage:WaitForChild("Remotes")

local getJobEvent   = Instance.new("RemoteEvent") getJobEvent.Name   = "GetJob"   getJobEvent.Parent = remotes
local workEvent     = Instance.new("RemoteEvent") workEvent.Name     = "Work"     workEvent.Parent = remotes
local quitJobEvent  = Instance.new("RemoteEvent") quitJobEvent.Name  = "QuitJob"  quitJobEvent.Parent = remotes
local jobInfoRemote = Instance.new("RemoteFunction") jobInfoRemote.Name = "GetJobInfo" jobInfoRemote.Parent = remotes

local Jobs = {
	{ name = "Lixeiro",      salary = 50,  cooldown = 30 },
	{ name = "Policial",     salary = 120, cooldown = 45 },
	{ name = "Médico",       salary = 200, cooldown = 60 },
	{ name = "Mecânico",     salary = 80,  cooldown = 30 },
	{ name = "Empresário",   salary = 500, cooldown = 120 },
	{ name = "Motorista",    salary = 70,  cooldown = 30 },
}

local playerJobs = {}   -- userId → { jobIndex, lastWork }

Players.PlayerAdded:Connect(function(p)
	playerJobs[p.UserId] = { jobIndex = nil, lastWork = 0 }
end)
Players.PlayerRemoving:Connect(function(p) playerJobs[p.UserId] = nil end)

jobInfoRemote.OnServerInvoke = function()
	return Jobs
end

getJobEvent.OnServerEvent:Connect(function(player, index)
	if not Jobs[index] then return end
	playerJobs[player.UserId].jobIndex = index
	player:FindFirstChild("PlayerGui") -- só para não dar erro
	print(("[Jobs] %s agora é %s"):format(player.Name, Jobs[index].name))
end)

quitJobEvent.OnServerEvent:Connect(function(player)
	playerJobs[player.UserId].jobIndex = nil
end)

workEvent.OnServerEvent:Connect(function(player)
	local data = playerJobs[player.UserId]
	if not data or not data.jobIndex then
		warn("[Jobs] " .. player.Name .. " não tem emprego!")
		return
	end
	local job = Jobs[data.jobIndex]
	local now = tick()
	if now - data.lastWork < job.cooldown then
		local restante = math.ceil(job.cooldown - (now - data.lastWork))
		warn(("[Jobs] %s precisa esperar %ds"):format(player.Name, restante))
		return
	end
	data.lastWork = now
	-- Cidadão recebe +10% de bônus de salário
	local salary = job.salary
	if _G.GetPlayerClass and _G.GetPlayerClass(player) == "cidadao" then
		salary = math.floor(salary * 1.1)
	elseif _G.GetPlayerClass and _G.GetPlayerClass(player) == "admin" then
		salary = salary * 10
	end
	local addMoney = remotes:FindFirstChild("AddMoney")
	if addMoney then addMoney:FireServer(player, salary) end
	-- Como estamos no server, disparamos direto na tabela via evento interno
	-- (MoneySystem escuta AddMoney como RemoteEvent do cliente; aqui usamos BindableEvent)
	print(("[Jobs] %s trabalhou como %s e ganhou R$%d"):format(player.Name, job.name, job.salary))
end)
