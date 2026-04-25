local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local sg = Instance.new("ScreenGui") sg.Name="NotifGui" sg.ResetOnSpawn=false sg.Parent=playerGui

local notifEvent = Instance.new("RemoteEvent")
notifEvent.Name = "Notification"
notifEvent.Parent = ReplicatedStorage:WaitForChild("Remotes")

local queue = {}
local showing = false

local function showNext()
	if showing or #queue == 0 then return end
	showing = true
	local data = table.remove(queue, 1)

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0,300,0,50)
	frame.Position = UDim2.new(0.5,-150,-0.1,0)
	frame.BackgroundColor3 = data.color or Color3.fromRGB(30,30,30)
	frame.BackgroundTransparency = 0.1
	frame.BorderSizePixel = 0
	frame.Parent = sg
	Instance.new("UICorner",frame).CornerRadius = UDim.new(0,8)

	local lbl = Instance.new("TextLabel") lbl.Size=UDim2.new(1,-10,1,0) lbl.Position=UDim2.new(0,5,0,0) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.new(1,1,1) lbl.TextScaled=true lbl.Font=Enum.Font.Gotham lbl.Text=data.msg lbl.Parent=frame

	TweenService:Create(frame, TweenInfo.new(0.3), {Position=UDim2.new(0.5,-150,0,10)}):Play()
	task.wait(3)
	TweenService:Create(frame, TweenInfo.new(0.3), {Position=UDim2.new(0.5,-150,-0.1,0)}):Play()
	task.wait(0.3)
	frame:Destroy()
	showing = false
	showNext()
end

notifEvent.OnClientEvent:Connect(function(msg, color)
	table.insert(queue, {msg=msg, color=color})
	showNext()
end)
