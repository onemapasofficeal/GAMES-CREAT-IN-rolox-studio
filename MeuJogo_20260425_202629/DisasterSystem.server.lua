local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local disasterAlert = Instance.new("RemoteEvent") disasterAlert.Name="DisasterAlert" disasterAlert.Parent=remotes

local Disasters = {
	{
		name = "Terremoto",
		duration = 15,
		damage = 20,
		onStart = function()
			-- Simula tremor movendo partes
			for _, p in ipairs(Workspace:GetDescendants()) do
				if p:IsA("BasePart") and not p.Anchored then
					p.Velocity = Vector3.new(math.random(-10,10), math.random(5,15), math.random(-10,10))
				end
			end
		end
	},
	{
		name = "Tornado",
		duration = 20,
		damage = 15,
		onStart = function()
			for _, player in ipairs(Players:GetPlayers()) do
				local char = player.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					char.HumanoidRootPart.Velocity = Vector3.new(math.random(-30,30), 20, math.random(-30,30))
				end
			end
		end
	},
	{
		name = "Inundação",
		duration = 30,
		damage = 5,
		onStart = function()
			local flood = Instance.new("Part") flood.Size=Vector3.new(500,2,500) flood.Position=Vector3.new(0,2,0) flood.Anchored=true flood.Color=Color3.fromRGB(30,80,200) flood.Material=Enum.Material.Water flood.Transparency=0.5 flood.CanCollide=false flood.Name="Flood" flood.Parent=Workspace
			task.delay(30, function() if flood.Parent then flood:Destroy() end end)
		end
	},
}

task.spawn(function()
	while true do
		task.wait(math.random(600, 1200))
		local disaster = Disasters[math.random(1,#Disasters)]

		for _, p in ipairs(Players:GetPlayers()) do
			disasterAlert:FireClient(p, disaster.name, disaster.duration)
		end
		print(("[Desastre] "..disaster.name.." começou!"))

		disaster.onStart()

		-- Dano durante o desastre
		for i = 1, disaster.duration do
			task.wait(1)
			for _, p in ipairs(Players:GetPlayers()) do
				local char = p.Character
				if char then
					local hum = char:FindFirstChild("Humanoid")
					if hum then hum.Health = math.max(1, hum.Health - disaster.damage/disaster.duration) end
				end
			end
		end

		print(("[Desastre] "..disaster.name.." terminou"))
	end
end)
