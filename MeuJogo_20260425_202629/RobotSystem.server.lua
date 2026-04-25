local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local buildRobotEvent  = Instance.new("RemoteEvent")    buildRobotEvent.Name  = "BuildRobot"   buildRobotEvent.Parent  = remotes
local commandRobotEvent= Instance.new("RemoteEvent")    commandRobotEvent.Name= "CommandRobot" commandRobotEvent.Parent= remotes
local robotListFn      = Instance.new("RemoteFunction") robotListFn.Name      = "GetRobotList" robotListFn.Parent      = remotes

local Robots = {
	{ id=1, name="Robô Trabalhador", price=100000000, task="work",   income=100 },
	{ id=2, name="Robô Guarda",      price=20000000000000000000000000000000000, task="guard",  damage=30  },
	{ id=3, name="Robô Minerador",   price=1500, task="mine",   income=200 },
	{ id=4, name="Robô Médico",      price=250000000000000000000000000000000000000000000000000, task="heal",   heal=50    },
}

local playerRobots = {}
local robotModels  = {}

Players.PlayerAdded:Connect(function(p) playerRobots[p.UserId]={} robotModels[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p)
	for _, m in ipairs(robotModels[p.UserId] or {}) do if m.Parent then m:Destroy() end end
	playerRobots[p.UserId]=nil robotModels[p.UserId]=nil
end)

robotListFn.OnServerInvoke = function(player)
	return Robots, playerRobots[player.UserId] or {}
end

buildRobotEvent.OnServerEvent:Connect(function(player, robotId)
	local robot = nil
	for _, r in ipairs(Robots) do if r.id==robotId then robot=r break end end
	if not robot then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, robot.price) end
	table.insert(playerRobots[player.UserId], robotId)

	-- Cria modelo do robô
	local char = player.Character
	if not char then return end
	local pos = char.HumanoidRootPart.Position + Vector3.new(5,0,0)

	local model = Instance.new("Model") model.Name="Robot_"..player.Name
	local body = Instance.new("Part") body.Size=Vector3.new(2,3,1) body.Position=pos+Vector3.new(0,1.5,0) body.Color=Color3.fromRGB(150,150,200) body.Material=Enum.Material.Metal body.Anchored=false body.Parent=model
	local head = Instance.new("Part") head.Size=Vector3.new(1.5,1.5,1.5) head.Position=pos+Vector3.new(0,3.5,0) head.Color=Color3.fromRGB(100,100,180) head.Material=Enum.Material.Neon head.Anchored=false head.Parent=model
	model.PrimaryPart = body
	model.Parent = Workspace
	table.insert(robotModels[player.UserId], model)

	-- Robô gera renda passiva
	if robot.income then
		task.spawn(function()
			while model.Parent do
				task.wait(60)
				local addMoney = remotes:FindFirstChild("AddMoney")
				if addMoney then addMoney:FireServer(player, robot.income) end
			end
		end)
	end

	print(("[Robô] %s construiu %s"):format(player.Name, robot.name))
end)
