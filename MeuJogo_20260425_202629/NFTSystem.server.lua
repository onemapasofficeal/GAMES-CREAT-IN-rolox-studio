local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local mintNFTEvent  = Instance.new("RemoteEvent")    mintNFTEvent.Name  = "MintNFT"     mintNFTEvent.Parent  = remotes
local sellNFTEvent  = Instance.new("RemoteEvent")    sellNFTEvent.Name  = "SellNFT"     sellNFTEvent.Parent  = remotes
local nftListFn     = Instance.new("RemoteFunction") nftListFn.Name     = "GetNFTList"  nftListFn.Parent     = remotes
local nftUpdate     = Instance.new("RemoteEvent")    nftUpdate.Name     = "NFTUpdate"   nftUpdate.Parent     = remotes

local nftMarket = {}
local playerNFTs = {}
local nextNFTId = 1

local NFTTypes = {
	{ name="Arte Digital",   basePrice=500000  },
	{ name="Personagem Raro",basePrice=20000000000 },
	{ name="Terreno Virtual",basePrice=50000000000000000 },
	{ name="Música NFT",     basePrice=10000000000000000000000000000000000000000 },
}

Players.PlayerAdded:Connect(function(p) playerNFTs[p.UserId]={} end)
Players.PlayerRemoving:Connect(function(p) playerNFTs[p.UserId]=nil end)

nftListFn.OnServerInvoke = function(player)
	return nftMarket, playerNFTs[player.UserId] or {}
end

mintNFTEvent.OnServerEvent:Connect(function(player, nftTypeIndex, name)
	local nftType = NFTTypes[nftTypeIndex]
	if not nftType then return end

	local removeMoney = remotes:FindFirstChild("RemoveMoney")
	if removeMoney then removeMoney:FireServer(player, nftType.basePrice) end

	local nft = {
		id = nextNFTId,
		name = name or nftType.name,
		type = nftType.name,
		owner = player.Name,
		ownerUserId = player.UserId,
		price = nftType.basePrice,
		minted = os.time()
	}
	nextNFTId += 1
	table.insert(playerNFTs[player.UserId], nft)
	print(("[NFT] %s mintou: %s"):format(player.Name, nft.name))
end)

sellNFTEvent.OnServerEvent:Connect(function(player, nftId, price)
	for i, nft in ipairs(playerNFTs[player.UserId]) do
		if nft.id == nftId then
			nft.price = price
			table.insert(nftMarket, nft)
			table.remove(playerNFTs[player.UserId], i)
			for _, p in ipairs(Players:GetPlayers()) do nftUpdate:FireClient(p, nftMarket) end
			print(("[NFT] %s listou %s por R$%d"):format(player.Name, nft.name, price))
			return
		end
	end
end)
