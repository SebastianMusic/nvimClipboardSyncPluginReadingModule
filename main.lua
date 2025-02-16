local file = io.open("./example.json", "r")
local messageToBeSentString = file:read("*all")

-- Break the message into smaller segments into a table and append the size of the message at the beginning
local function preprocessUserMessage(string)
	local messageLength = string.len(string)
	messageLength = messageLength + 16
	messageLength = string.format("%016d", messageLength)
	string = messageLength .. string
	return string
end

-- breaks the message into random sized pieces and returns a table
local function simulateRealSituation(string)
	local message = preprocessUserMessage(string)
	local messageTable = {}
	local messageLength = string.len(message)
	print("message Length is ", messageLength)
	local messageEnd = messageLength
	while messageLength > 0 do
		local packetSize = math.min(math.random(1, messageLength), 20)
		print("packet size is ", packetSize)
		local startIndex = messageEnd - messageLength + 1
		print("start index is ", startIndex)
		local packetString = string.sub(message, startIndex, startIndex + packetSize - 1)
		print("packet string is", packetString)
		table.insert(messageTable, packetString)
		messageLength = messageLength - packetSize
		print("new message length is ", messageLength)
	end
	return messageTable
end

local messageTable = simulateRealSituation(messageToBeSentString)
MessageBuffer = {}

local function readerFunction(data)
	if data then
		table.insert(MessageBuffer, data)
		local messageString = table.concat(MessageBuffer)
		if string.len(messageString) < 16 then
			print("not received enough data to determine message length")
		else
			local messageLength = string.sub(messageString, 1, 16)
			-- print(
			-- 	"message length is ",
			-- 	messageLength,
			-- 	"messageString length is ",
			-- 	string.len(table.concat(MessageBuffer))
			-- )
			if tonumber(messageLength) == tonumber(string.len(table.concat(MessageBuffer))) then
				local message = table.concat(MessageBuffer)
				message = string.sub(message, 17, tonumber(messageLength))
				print(message)
				MessageBuffer = {}
			end
		end
	end
end

for i in ipairs(messageTable) do
	readerFunction(messageTable[i])
end
