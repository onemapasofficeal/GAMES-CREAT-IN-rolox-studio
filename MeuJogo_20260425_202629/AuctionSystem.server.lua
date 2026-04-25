local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local createAuctionEvent = Instance.new("RemoteEvent")    createAuctionEvent.Name = "CreateAuction"  createAuctionEvent.Parent = remotes
local bidEvent           = Instance.new("RemoteEvent")    bidEvent.Name           = "Bid"            bidEvent.Parent           = remotes
local auctionListFn      = Instance.new("RemoteFunction") auctionListFn.Name      = "GetAuctions"    auctionListFn.Parent      = remotes
local auctionUpdate      = Instance.new("RemoteEvent")    auctionUpdate.Name      = "AuctionUpdate"  auctionUpdate.Parent      = remotes

local auctions = {}
local nextAuctionId = 1

auctionListFn.OnServerInvoke = function() return auctions end

createAuctionEvent.OnServerEvent:Connect(function(player, itemName, startPrice, duration)
	duration = math.min(duration or 120, 300)
	local auction = {
		id = nextAuctionId,
		seller = player.Name,
		sellerUserId = player.UserId,
		item = itemName,
		currentBid = startPrice,
		highestBidder = nil,
		highestBidderUserId = nil,
		endsAt = tick() + duration,
		active = true
	}
	nextAuctionId += 1
	table.insert(auctions, auction)

	for _, p in ipairs(Players:GetPlayers()) do auctionUpdate:FireClient(p, auctions) end

	-- Finaliza leilão
	task.delay(duration, function()
		auction.active = false
		if auction.highestBidderUserId then
			local winner = Players:GetPlayerByUserId(auction.highestBidderUserId)
			local seller = Players:GetPlayerByUserId(auction.sellerUserId)
			if winner then
				local addItem = remotes:FindFirstChild("AddItem")
				if addItem then addItem:FireServer(winner, auction.item, 1) end
			end
			if seller then
				local addMoney = remotes:FindFirstChild("AddMoney")
				if addMoney then addMoney:FireServer(seller, auction.currentBid) end
			end
			print(("[Leilão] %s ganhou %s por R$%d"):format(auction.highestBidder, auction.item, auction.currentBid))
		end
		for _, p in ipairs(Players:GetPlayers()) do auctionUpdate:FireClient(p, auctions) end
	end)
	print(("[Leilão] %s leiloou %s"):format(player.Name, itemName))
end)

bidEvent.OnServerEvent:Connect(function(player, auctionId, amount)
	for _, auction in ipairs(auctions) do
		if auction.id == auctionId and auction.active then
			if amount <= auction.currentBid then return end
			-- Devolve lance anterior
			if auction.highestBidderUserId then
				local prev = Players:GetPlayerByUserId(auction.highestBidderUserId)
				if prev then
					local addMoney = remotes:FindFirstChild("AddMoney")
					if addMoney then addMoney:FireServer(prev, auction.currentBid) end
				end
			end
			local removeMoney = remotes:FindFirstChild("RemoveMoney")
			if removeMoney then removeMoney:FireServer(player, amount) end
			auction.currentBid = amount
			auction.highestBidder = player.Name
			auction.highestBidderUserId = player.UserId
			for _, p in ipairs(Players:GetPlayers()) do auctionUpdate:FireClient(p, auctions) end
			return
		end
	end
end)
