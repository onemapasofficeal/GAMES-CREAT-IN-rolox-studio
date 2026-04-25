local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local talkNPCEvent = Instance.new("RemoteEvent")    talkNPCEvent.Name = "TalkNPC"    talkNPCEvent.Parent = remotes
local npcDialogue  = Instance.new("RemoteEvent")    npcDialogue.Name  = "NPCDialogue" npcDialogue.Parent  = remotes

local NPCData = {
	{ name="João (Lojista)",   pos=Vector3.new(30,1,30),   color=Color3.fromRGB(200,150,100), dialogue={"Bem-vindo à loja!","Temos os melhores preços!","Volte sempre!"} },
	{ name="Maria (Banqueira)",pos=Vector3.new(-30,1,30),  color=Color3.fromRGB(220,180,140), dialogue={"Posso ajudar com sua conta?","Temos ótimas taxas de juros!","Seu dinheiro está seguro aqui."} },
	{ name="Dr. Silva",        pos=Vector3.new(100,1,100), color=Color3.fromRGB(240,220,200), dialogue={"Como posso ajudar?","Cuide da sua saúde!","Temos planos acessíveis."} },
	{ name="Delegado Costa",   pos=Vector3.new(-80,1,-80), color=Color3.fromRGB(50,50,150),   dialogue={"Mantenha a ordem!","Viu algo suspeito? Me avise.","A lei é para todos."} },
	{ name="Fazendeiro Pedro", pos=Vector3.new(150,1,150), color=Color3.fromRGB(150,100,50),  dialogue={"Boa colheita hoje!","Precisa de sementes?","A terra não mente."} },
}

local npcFolder = Instance.new("Folder") npcFolder.Name="NPCs" npcFolder.Parent=Workspace

for _, data in ipairs(NPCData) do
	local model = Instance.new("Model") model.Name=data.name

	local torso = Instance.new("Part") torso.Size=Vector3.new(2,2,1) torso.Position=data.pos+Vector3.new(0,2,0) torso.Anchored=true torso.Color=data.color torso.Material=Enum.Material.SmoothPlastic torso.Parent=model
	local head  = Instance.new("Part") head.Size=Vector3.new(1.5,1.5,1.5) head.Position=data.pos+Vector3.new(0,3.5,0) head.Anchored=true head.Color=Color3.fromRGB(255,220,185) head.Material=Enum.Material.SmoothPlastic head.Parent=model

	local bb = Instance.new("BillboardGui",head) bb.Size=UDim2.new(0,120,0,30) bb.StudsOffset=Vector3.new(0,2,0)
	local lbl = Instance.new("TextLabel",bb) lbl.Size=UDim2.new(1,0,1,0) lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.new(1,1,1) lbl.TextScaled=true lbl.Font=Enum.Font.GothamBold lbl.Text=data.name

	local interact = Instance.new("StringValue") interact.Name="Interactable" interact.Value="Falar com "..data.name interact.Parent=torso

	model.PrimaryPart = torso
	model.Parent = npcFolder
end

talkNPCEvent.OnServerEvent:Connect(function(player, npcName)
	for _, data in ipairs(NPCData) do
		if data.name == npcName then
			local line = data.dialogue[math.random(1,#data.dialogue)]
			npcDialogue:FireClient(player, npcName, line)
			return
		end
	end
end)
