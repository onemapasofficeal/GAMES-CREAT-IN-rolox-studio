local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sg = Instance.new("ScreenGui") sg.Name="ChatGui" sg.ResetOnSpawn=false sg.Parent=playerGui

local panel = Instance.new("Frame") panel.Size=UDim2.new(0,340,0,260) panel.Position=UDim2.new(0,10,1,-280) panel.BackgroundColor3=Color3.fromRGB(10,10,10) panel.BackgroundTransparency=0.3 panel.BorderSizePixel=0 panel.Parent=sg
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,8)

local msgFrame = Instance.new("ScrollingFrame") msgFrame.Size=UDim2.new(1,-10,1,-50) msgFrame.Position=UDim2.new(0,5,0,5) msgFrame.BackgroundTransparency=1 msgFrame.ScrollBarThickness=3 msgFrame.CanvasSize=UDim2.new(0,0,0,0) msgFrame.Parent=panel
local layout = Instance.new("UIListLayout") layout.VerticalAlignment=Enum.VerticalAlignment.Bottom layout.Parent=msgFrame

local inputBox = Instance.new("TextBox") inputBox.Size=UDim2.new(0.75,0,0,36) inputBox.Position=UDim2.new(0,5,1,-42) inputBox.BackgroundColor3=Color3.fromRGB(30,30,30) inputBox.TextColor3=Color3.new(1,1,1) inputBox.PlaceholderText="Mensagem..." inputBox.TextScaled=true inputBox.Font=Enum.Font.Gotham inputBox.Text="" inputBox.ClearTextOnFocus=false inputBox.Parent=panel
Instance.new("UICorner",inputBox).CornerRadius=UDim.new(0,6)

local sendBtn = Instance.new("TextButton") sendBtn.Size=UDim2.new(0.22,0,0,36) sendBtn.Position=UDim2.new(0.78,0,1,-42) sendBtn.BackgroundColor3=Color3.fromRGB(40,80,160) sendBtn.TextColor3=Color3.new(1,1,1) sendBtn.TextScaled=true sendBtn.Font=Enum.Font.GothamBold sendBtn.Text="Enviar" sendBtn.Parent=panel
Instance.new("UICorner",sendBtn).CornerRadius=UDim.new(0,6)

local channelColors = { Global=Color3.fromRGB(200,200,200), Local=Color3.fromRGB(100,220,100), Trabalho=Color3.fromRGB(100,150,255), Crime=Color3.fromRGB(255,100,100) }
local currentChannel = "Global"

local function addMessage(playerName, msg, channel)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1,0,0,20)
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = channelColors[channel] or Color3.new(1,1,1)
	lbl.TextScaled = true
	lbl.Font = Enum.Font.Gotham
	lbl.Text = "["..channel.."] "..playerName..": "..msg
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = msgFrame
	msgFrame.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
	msgFrame.CanvasPosition = Vector2.new(0, layout.AbsoluteContentSize.Y)
end

local function sendMessage()
	local msg = inputBox.Text
	if msg=="" then return end
	remotes:WaitForChild("SendChat"):FireServer(msg, currentChannel)
	inputBox.Text = ""
end

sendBtn.MouseButton1Click:Connect(sendMessage)
inputBox.FocusLost:Connect(function(enter) if enter then sendMessage() end end)

remotes:WaitForChild("ReceiveChat").OnClientEvent:Connect(addMessage)
