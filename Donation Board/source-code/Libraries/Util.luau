--!nocheck
--!nolint
return {
	PagesToTable = function(pages)
		local items = {}
		while true do
			table.insert(items, pages:GetCurrentPage())
			if pages.IsFinished then
				break
			end
			pages:AdvanceToNextPageAsync()
		end
		return items
	end,

	Serialize = function(data)
		local function callback(value)
			if typeof(value) == "Color3" then
				return `#{value:ToHex()}`
			elseif typeof(value) == "table" then
				local serialized = {}
				for key, value in value do
					serialized[key] = callback(value)
				end
				return serialized
			end

			return value
		end

		return game:GetService("HttpService"):JSONEncode(callback(data))
	end,

	Deserialize = function(json)
		local function callback(value)
			if typeof(value) == "string" and value:sub(1, 1) == "#" then
				return Color3.fromHex(value)
			elseif typeof(value) == "table" then
				local deserialized = {}
				for key, value in value do
					deserialized[key] = callback(value)
				end
				return deserialized
			else
				return value
			end
		end

		local decoded = game:GetService("HttpService"):JSONDecode(json)
		return callback(decoded)
	end,

	Commaify = function(n: number)
		return tostring(n):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
	end,
}