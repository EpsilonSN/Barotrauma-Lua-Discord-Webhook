-- BY
-- EVIL FACTORY

--[[local discordWebHook = "---"

local function escapeQuotes(str)
    return str:gsub("\"", "\\\"")
end

Hook.Add("chatMessage", "discordIntegration_admin", function (msg, client)
    local escapedName = escapeQuotes(client.name)
    local escapedMessage = escapeQuotes(msg)

    Networking.RequestPostHTTP(discordWebHook, '{\"content\": \"'..escapedMessage..'\", \"username\": \"'..escapedName..'\"}')
end)


local discordWebHook = "---"

local function escapeQuotes(str)
    return str:gsub("\"", "\\\"")
end

Hook.Add("chatMessage", "discordIntegration", function (msg, client)
    local escapedName = escapeQuotes(client.name)
    local escapedMessage = escapeQuotes(msg)

    

    if type == ChatMessageType.ServerLog then
        -- do something if the type is Log
    end


    Networking.RequestPostHTTP(discordWebHook, function(result) end, '{\"content\": \"'..escapedMessage..'\", \"username\": \"'..escapedName..'\"}')
end)



Hook.Add("serverLog", "discordIntegrationForLogs", function (logMessage, logType)
    local escapedName = escapeQuotes(tostring(logType))
    local escapedMessage = escapeQuotes(tostring(logMessage))

    Networking.RequestPostHTTP(discordWebHook, function(result) end, '{\"content\": \"'..escapedMessage..'\", \"username\": \"'..escapedName..'\"}')
end)

--]]
local discordWebHook = "INSERT WEBHOOK URL HERE"

local function escapeQuotes(str)
    return str:gsub("\"", "\\\"")
end

local messageBuffer = {}
local messageDelay = 1
local maxSingleMessages = 15

local messageTimer = 0

Hook.Add("serverLog", "discordIntegrationForLogs", function (logMessage, logType)
    local escapedName = escapeQuotes(tostring(logType))
    local escapedMessage = escapeQuotes(tostring(logMessage))

    messageBuffer[escapedMessage] = escapedName
end)

Hook.Add("think", "sendBufferedMessages", function ()
    if Timer.GetTime() < messageTimer then return end

    local appendedMessage = ""

    local totalSent = 0
    for key, value in pairs(messageBuffer) do
        appendedMessage = appendedMessage .. '`' .. value .. '`' .. ": " .. key .. "\\n"

        messageBuffer[key] = nil
        totalSent = totalSent + 1
        if totalSent > maxSingleMessages then break end
    end

    if appendedMessage ~= "" then
        Networking.RequestPostHTTP(discordWebHook, function(result) end, '{\"content\": \"'..appendedMessage..'\", \"username\": \"'..'Server Logs'..'\"}')
    end

    messageTimer = Timer.GetTime() + messageDelay
end)

