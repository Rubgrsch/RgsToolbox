local E, L = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DT = E:GetModule('DataTexts')

-- This invasion module copied from NDui, credit goes to siwei.
-- Works on CN only
-- Check Invasion Status
local invIndex = {
	{title = L["BfA Invasion"], duration = 68400, maps = {862, 863, 864, 896, 942, 895}, timeTable = {4, 1, 6, 2, 5, 3}, baseTime = 1544691600},
	{title = L["Legion Invasion"], duration = 66600, maps = {630, 641, 650, 634}, timeTable = {4, 3, 2, 1, 4, 2, 3, 1, 2, 4, 1, 3}, baseTime = 1517274000},
}

local mapAreaPoiIDs = {
	[630] = 5175,
	[641] = 5210,
	[650] = 5177,
	[634] = 5178,
	[862] = 5973,
	[863] = 5969,
	[864] = 5970,
	[896] = 5964,
	[942] = 5966,
	[895] = 5896,
}

local function GetInvasionInfo(mapID)
	local areaPoiID = mapAreaPoiIDs[mapID]
	local seconds = C_AreaPoiInfo.GetAreaPOISecondsLeft(areaPoiID)
	local mapInfo = C_Map.GetMapInfo(mapID)
	return seconds, mapInfo.name
end

local function CheckInvasion(index)
	for _, mapID in pairs(invIndex[index].maps) do
		local timeLeft, name = GetInvasionInfo(mapID)
		if timeLeft and timeLeft > 0 then
			return timeLeft, name
		end
	end
end

local function GetNextTime(baseTime, index)
	local currentTime = time()
	local duration = invIndex[index].duration
	local elapsed = mod(currentTime - baseTime, duration)
	return duration - elapsed + currentTime
end

local function GetNextLocation(nextTime, index)
	local inv = invIndex[index]
	local count = #inv.timeTable
	local elapsed = nextTime - inv.baseTime
	local round = mod(floor(elapsed / inv.duration) + 1, count)
	if round == 0 then round = count end
	return C_Map.GetMapInfo(inv.maps[inv.timeTable[round]]).name
end

local function OnEvent(self)
	self.text:SetText(L["Invasion"])
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	for index, value in ipairs(invIndex) do
		DT.tooltip:AddLine(value.title)
		local timeLeft, zoneName = CheckInvasion(index)
		local nextTime = GetNextTime(value.baseTime, index)
		if timeLeft then
			timeLeft = timeLeft/60
			DT.tooltip:AddDoubleLine(L["Current: "]..zoneName, format("%dh%.2dm", timeLeft/60, timeLeft%60), 1,1,1, 0,1,0)
		end
		DT.tooltip:AddDoubleLine(L["Next: "]..GetNextLocation(nextTime, index), date("%m/%d %H:%M", nextTime), 1,1,1, 1,1,1)
	end

	DT.tooltip:Show()
end

DT:RegisterDatatext('Invasion', {'PLAYER_ENTERING_WORLD'}, OnEvent, nil, nil, OnEnter, nil, L["Invasion"])
