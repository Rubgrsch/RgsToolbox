-- https://wow.gamepedia.com/InstanceMapID
local partyMapIDs = {
	[1594] = true,
	[1754] = true,
	[1762] = true,
	[1763] = true,
	[1771] = true,
	[1822] = true,
	[1841] = true,
	[1862] = true,
	[1864] = true,
	[1877] = true,
}

local raidMapIDs = {
	[1861] = true,
	[2070] = true,
	[2096] = true,
	[2164] = true,
}

local function GetCurrentMapForLogging()
	local _, zoneType, difficulty, _, _, _, _, mapID = GetInstanceInfo()
	mapID = mapID and tonumber(mapID)
	if zoneType == 'raid' and raidMapIDs[mapID] and (difficulty ~= 7 and difficulty ~= 17) then
		return true
	elseif (difficulty == 8 or difficulty == 23) and partyMapIDs[mapID] then
		return true
	end
end

local prevZone = false
local function ZoneNewFunction()
	local zoneForLogging = GetCurrentMapForLogging()
	if zoneForLogging then
		LoggingCombat(true)
		print("开始战斗记录")
	elseif prevZone and LoggingCombat() then
		LoggingCombat(false)
		print("结束战斗记录")
	end
	prevZone = zoneForLogging
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("CHALLENGE_MODE_START")
frame:SetScript("OnEvent", function(_, event)
	C_Timer.After(event == "CHALLENGE_MODE_START" and 1 or 2, ZoneNewFunction)
end)
