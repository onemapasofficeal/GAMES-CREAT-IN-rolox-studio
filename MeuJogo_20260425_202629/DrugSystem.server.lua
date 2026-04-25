-- Sistema de drogas ilegais (jogo de roleplay, sem apologia)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local makeDrugEvent  = Instance.new("RemoteEvent")    makeDrugEvent.Name  = "MakeDrug"    makeDrugEvent.Parent  = remotes
local sellDrugEvent  = Instance.new("RemoteEvent")    sellDrugEvent.Name  = "SellDrug"    sellDrugEvent.Parent  = remotes
local drugListFn     = Instance.new("RemoteFunction") drugListFn.Name     = "GetDrugList" drugListFn.Parent     = remotes

local Drugs = {
	{ id=1, name="Erva Seca",    ingredients={{"Erva",3}},          sellPrice=100, wantedRisk=1 },
	{ id=2, name="Pó Branco",    ingredients={{"Químico",4},{"Erva",2}}, sellPrice=300, wantedRisk=2 },
	{ id=3, name="Cristal",      ingredients={{"Químico",6},{"Sal",2}},  sellPrice=500, wantedRisk=3 },
}

local playerDrugs = {}

Players.PlayerAdded:Connect(function(p) playerDrugs[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p) playerDrugs[p.UserId]=nil end)

drugListFn.OnServerInvoke = function() return Drugs end

makeDrugEvent.OnServerEvent:Connect(function(player, drugId)
	if _G.GetPlayerClass and _G.GetPlayerClass(player) == "cidadao" then
		warn("[Drug] Cidadão não pode fabricar drogas!")
		return
	end
	local drug = nil
	for _, d in ipairs(Drugs) do if d.id==drugId then drug=d break end end
	if not drug then return end

	local removeItem = remotes:FindFirstChild("RemoveItem")
	for _, ing in ipairs(drug.ingredients) do
		if removeItem then removeItem:FireServer(player, ing[1], ing[2]) end
	end

	playerDrugs[player.UserId][drugId] = (playerDrugs[player.UserId][drugId] or 0) + 1
	print(("[Crime] %s fabricou %s"):format(player.Name, drug.name))
end)

sellDrugEvent.OnServerEvent:Connect(function(player, drugId)
	local drug = nil
	for _, d in ipairs(Drugs) do if d.id==drugId then drug=d break end end
	if not drug then return end
	if not playerDrugs[player.UserId][drugId] or playerDrugs[player.UserId][drugId] <= 0 then return end

	playerDrugs[player.UserId][drugId] -= 1
	local addMoney = remotes:FindFirstChild("AddMoney")
	if addMoney then addMoney:FireServer(player, drug.sellPrice) end

	-- Risco de ser pego
	if math.random() < drug.wantedRisk * 0.1 then
		local wantedUpdate = remotes:FindFirstChild("WantedUpdate")
		print(("[Crime] %s foi flagrado vendendo %s!"):format(player.Name, drug.name))
	end
end)
