local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local sendGiftEvent   = Instance.new("RemoteEvent") sendGiftEvent.Name   = "SendGift"    sendGiftEvent.Parent   = remotes
local receiveGiftEvent= Instance.new("RemoteEvent") receiveGiftEvent.Name= "ReceiveGift" receiveGiftEvent.Parent= remotes

local GiftItems = {
	{ name="Buquê de Flores", price=100  },
	{ name="Caixa de Chocolates", price=150 },
	{ name="Anel de Ouro",    price=500  },
	{ name="Perfume",         price=300  },
	{ name="Livro",           price=80   },
	{ name="Bolo de Aniversário", price=200 },
	{ name="Dinheiro",        price=0    },  -- envia dinheiro diretamente
}

sendGiftEvent.OnServerEvent:Connect(function(player, targetName, giftIndex, amount)
	local target = Players:FindFirstChild(targetName)
	if not target then return end
	if target == player then return end

	local gift = GiftItems[giftIndex]
	if not gift then return end

	if gift.name == "Dinheiro" then
		if type(amount)~="number" or amount<=0 then return end
		local removeMoney = remotes:FindFirstChild("RemoveMoney")
		local addMoney    = remotes:FindFirstChild("AddMoney")
		if removeMoney then removeMoney:FireServer(player, amount) end
		if addMoney    then addMoney:FireServer(target, amount) end
		receiveGiftEvent:FireClient(target, player.Name, "Dinheiro R$"..amount)
	else
		local removeMoney = remotes:FindFirstChild("RemoveMoney")
		if removeMoney then removeMoney:FireServer(player, gift.price) end
		local addItem = remotes:FindFirstChild("AddItem")
		if addItem then addItem:FireServer(target, gift.name, 1) end
		receiveGiftEvent:FireClient(target, player.Name, gift.name)
	end

	print(("[Presente] %s enviou %s para %s"):format(player.Name, gift.name, target.Name))
end)
