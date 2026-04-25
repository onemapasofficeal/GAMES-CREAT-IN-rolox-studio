local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local equipTitleEvent = Instance.new("RemoteEvent")    equipTitleEvent.Name = "EquipTitle"    equipTitleEvent.Parent = remotes
local titleListFn     = Instance.new("RemoteFunction") titleListFn.Name     = "GetTitleList"  titleListFn.Parent     = remotes
local titleUpdate     = Instance.new("RemoteEvent")    titleUpdate.Name     = "TitleUpdate"   titleUpdate.Parent     = remotes

local Titles = {
	{ id=1,  name="Novato",        requirement="level_1",   color=Color3.fromRGB(200,200,200) },
	{ id=2,  name="Trabalhador",   requirement="level_10",  color=Color3.fromRGB(100,200,100) },
	{ id=3,  name="Empresário",    requirement="level_25",  color=Color3.fromRGB(100,150,255) },
	{ id=4,  name="Milionário",    requirement="money_1m",  color=Color3.fromRGB(255,200,0)   },
	{ id=5,  name="Criminoso",     requirement="wanted_5",  color=Color3.fromRGB(255,50,50)   },
	{ id=6,  name="Herói",         requirement="arrest_10", color=Color3.fromRGB(50,200,255)  },
	{ id=7,  name="Lendário",      requirement="level_50",  color=Color3.fromRGB(255,100,255) },
	{ id=8,  name="Prefeito",      requirement="mayor",     color=Color3.fromRGB(255,180,0)   },
	{ id=9,  name="Mestre Pescador",requirement="fish_100", color=Color3.fromRGB(50,150,255)  },
	{ id=10, name="Chef Estrela",  requirement="cook_50",   color=Color3.fromRGB(255,150,50)  },
}

local playerTitles   = {}  -- userId → set of titleIds
local equippedTitles = {}  -- userId → titleId

Players.PlayerAdded:Connect(function(p)
	playerTitles[p.UserId] = {[1]=true}  -- Novato por padrão
	equippedTitles[p.UserId] = 1
end)
Players.PlayerRemoving:Connect(function(p) playerTitles[p.UserId]=nil equippedTitles[p.UserId]=nil end)

titleListFn.OnServerInvoke = function(player)
	return Titles, playerTitles[player.UserId] or {}, equippedTitles[player.UserId]
end

equipTitleEvent.OnServerEvent:Connect(function(player, titleId)
	if not playerTitles[player.UserId][titleId] then return end
	equippedTitles[player.UserId] = titleId

	local title = nil
	for _, t in ipairs(Titles) do if t.id==titleId then title=t break end end
	if not title then return end

	-- Atualiza billboard do personagem
	local char = player.Character
	if char then
		local head = char:FindFirstChild("Head")
		if head then
			local bb = head:FindFirstChild("TitleGui") or Instance.new("BillboardGui", head)
			bb.Name = "TitleGui"
			bb.Size = UDim2.new(0,120,0,24)
			bb.StudsOffset = Vector3.new(0,3,0)
			local lbl = bb:FindFirstChild("TitleLabel") or Instance.new("TextLabel", bb)
			lbl.Name = "TitleLabel"
			lbl.Size = UDim2.new(1,0,1,0)
			lbl.BackgroundTransparency = 1
			lbl.TextColor3 = title.color
			lbl.TextScaled = true
			lbl.Font = Enum.Font.GothamBold
			lbl.Text = "【"..title.name.."】"
		end
	end

	titleUpdate:FireClient(player, title)
	print(("[Título] %s equipou: %s"):format(player.Name, title.name))
end)

_G.UnlockTitle = function(player, titleId)
	if playerTitles[player.UserId] then
		playerTitles[player.UserId][titleId] = true
	end
end
