--!nocheck
--!nolint
local Receipt = {}
Receipt.__index = Receipt


export type receiptInfoType = {
	PurchaseId: string,
	PlayerId: number,
	ProductId: number,
	PlaceIdWherePurchased: number,
	CurrencySpent: number,
	CurrencyType: Enum.CurrencyType,
	ProductPurchaseChannel: Enum.ProductPurchaseChannel,
	IsStudio: boolean,
} 


function Receipt.new(receiptInfo: receiptInfoType)
	local self = {
		PurchaseId = receiptInfo.PurchaseId or game:GetService("HttpService"):GenerateGUID(false):gsub("-", ""),
		PlayerId = receiptInfo.PlayerId or 0,
		ProductId = receiptInfo.ProductId or 0,
		PlaceIdWherePurchased = receiptInfo.PlaceIdWherePurchased or game.PlaceId,
		CurrencySpent = (receiptInfo.ProductId and game:GetService("MarketplaceService"):GetProductInfo(receiptInfo.ProductId, Enum.InfoType.Product).PriceInRobux) or 0,
		CurrencyType = Enum.CurrencyType.Robux,
		ProductPurchaseChannel = receiptInfo.ProductPurchaseChannel or Enum.ProductPurchaseChannel.InExperience,
		IsStudio = shared["_db/environment"].studiomode
	}

	return self :: receiptInfoType
end


return Receipt