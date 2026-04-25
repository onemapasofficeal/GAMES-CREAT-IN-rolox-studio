-- Sistema de admin: comandos via chat
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

-- Lista de admins por username
local ADMINS = { "0p_409" }

local function isAdmin(player)
	for _, name in ipairs(ADMINS) do
		if player.Name == name then return true end
	end
	return false
end

local Commands = {
	[":give"] = function(admin, args)
		local targetName, amount = args[1], tonumber(args[2])
		if not targetName or not amount then return end
		local target = Players:FindFirstChild(targetName)
		if not target then return end
		local addMoney = remotes:FindFirstChild("AddMoney")
		if addMoney then addMoney:FireServer(target, amount) end
		print(("[Admin] %s deu R$%d para %s"):format(admin.Name, amount, targetName))
	end,
	[":kick"] = function(admin, args)
		local target = Players:FindFirstChild(args[1])
		if target then target:Kick("Expulso por admin") end
	end,
	[":heal"] = function(admin, args)
		local target = Players:FindFirstChild(args[1]) or admin
		if target.Character then
			local hum = target.Character:FindFirstChild("Humanoid")
			if hum then hum.Health = hum.MaxHealth end
		end
	end,
	[":tp"] = function(admin, args)
		local target = Players:FindFirstChild(args[1])
		if not target then return end
		local char = target.Character
		local adminChar = admin.Character
		if char and adminChar and adminChar:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = adminChar.HumanoidRootPart.CFrame
		end
	end,
	[":speed"] = function(admin, args)
		local speed = tonumber(args[1]) or 16
		local char = admin.Character
		if char then
			local hum = char:FindFirstChild("Humanoid")
			if hum then hum.WalkSpeed = speed end
		end
	end,
	[":xp"] = function(admin, args)
		local targetName, amount = args[1], tonumber(args[2])
		local target = Players:FindFirstChild(targetName)
		if not target then return end
		local addXP = remotes:FindFirstChild("AddXP")
		if addXP then addXP:FireServer(target, amount) end
	end,
}

Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(msg)
		if not isAdmin(player) then return end
		local parts = msg:split(" ")
		local cmd = parts[1]:lower()
		local args = {}
		for i = 2, #parts do table.insert(args, parts[i]) end
		if Commands[cmd] then
			Commands[cmd](player, args)
		end
	end)
end)
