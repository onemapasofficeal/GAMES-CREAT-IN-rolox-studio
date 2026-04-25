-- PhoneSystem.server.lua
-- Celular: ligar para jogadores, enviar mensagens

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local callEvent    = Instance.new("RemoteEvent") callEvent.Name    = "PhoneCall"    callEvent.Parent = remotes
local msgEvent     = Instance.new("RemoteEvent") msgEvent.Name     = "PhoneMessage" msgEvent.Parent  = remotes
local receiveCall  = Instance.new("RemoteEvent") receiveCall.Name  = "ReceiveCall"  receiveCall.Parent = remotes
local receiveMsg   = Instance.new("RemoteEvent") receiveMsg.Name   = "ReceiveMessage" receiveMsg.Parent = remotes

-- Ligar para outro jogador
callEvent.OnServerEvent:Connect(function(caller, targetName)
	local target = Players:FindFirstChild(targetName)
	if not target then
		warn("[Celular] Jogador não encontrado: " .. tostring(targetName))
		return
	end
	receiveCall:FireClient(target, caller.Name)
	print(("[Celular] %s ligou para %s"):format(caller.Name, target.Name))
end)

-- Enviar mensagem
msgEvent.OnServerEvent:Connect(function(sender, targetName, message)
	if type(message) ~= "string" or #message > 200 then return end
	local target = Players:FindFirstChild(targetName)
	if not target then return end
	receiveMsg:FireClient(target, sender.Name, message)
	print(("[Celular] %s → %s: %s"):format(sender.Name, target.Name, message))
end)
