local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local studyEvent  = Instance.new("RemoteEvent")    studyEvent.Name  = "Study"         studyEvent.Parent  = remotes
local courseListFn= Instance.new("RemoteFunction") courseListFn.Name= "GetCourseList" courseListFn.Parent= remotes
local enrollEvent = Instance.new("RemoteEvent")    enrollEvent.Name = "EnrollCourse"  enrollEvent.Parent = remotes

local Courses = {
	{ id=1, name="Ensino Médio",    price=500,  xpBonus=50,  salaryBonus=0.1,  duration=60  },
	{ id=2, name="Faculdade",       price=2000, xpBonus=150, salaryBonus=0.25, duration=120 },
	{ id=3, name="Pós-Graduação",   price=5000, xpBonus=300, salaryBonus=0.5,  duration=180 },
	{ id=4, name="Curso de Culinária",price=800,xpBonus=80,  salaryBonus=0.15, duration=90  },
	{ id=5, name="Curso de Mecânica",price=600, xpBonus=70,  salaryBonus=0.12, duration=75  },
	{ id=6, name="MBA",             price=8000, xpBonus=500, salaryBonus=0.8,  duration=240 },
}

local playerCourses = {}  -- userId → { courseId → completed }

Players.PlayerAdded:Connect(function(p) playerCourses[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p) playerCourses[p.UserId]=nil end)

courseListFn.OnServerInvoke = function(player)
	return Courses, playerCourses[player.UserId] or {}
end

enrollEvent.OnServerEvent:Connect(function(player, courseId)
	local course = Courses[courseId]
	if not course then return end
	if playerCourses[player.UserId][courseId] then warn("[Escola] Já concluiu") return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, course.price) end

	task.delay(course.duration, function()
		playerCourses[player.UserId][courseId] = true
		local addXP = remotes:FindFirstChild("AddXP")
		if addXP then addXP:FireServer(player, course.xpBonus) end
		print(("[Escola] %s concluiu %s"):format(player.Name, course.name))
	end)
	print(("[Escola] %s matriculou em %s"):format(player.Name, course.name))
end)

studyEvent.OnServerEvent:Connect(function(player)
	local addXP = remotes:FindFirstChild("AddXP")
	if addXP then addXP:FireServer(player, 5) end
end)
