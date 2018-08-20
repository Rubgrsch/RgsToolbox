local _, rgsaddon = ...
local C, R = unpack(rgsaddon)

local ipairs = ipairs
local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local GetCVar, SetCVar = GetCVar, SetCVar

local majorCity = {
	[85] = true, -- Orgrimmar
	[86] = true, -- Orgrimmar
	[103] = true, -- The Exodar
	[110] = true, -- Silvermoon City
	[84] = true, -- Stormwind City
	[88] = true, -- Thunder Bluff
	[111] = true, -- Shattrath City, Outland
	[125] = true, -- Dalaran, Northrend
	[624] = true, -- Warspear, Draenor
	[622] = true, -- Stormshield, Draenor
	[627] = true, -- Dalaran, the Broken Isles
	[1163] = true, -- Atal' Dazar, Zuldazar
	[1161] = true, -- Boralus, Tiragarde Sound
}

local CVarT = {"UnitNameFriendlyPlayerName", "UnitNameFriendlyPetName", "UnitNameEnemyPlayerName", "UnitNameEnemyPetName"}

-- SetCVar won't work in combat, queue them first.
local queue = nil
local function queueRun()
	local v = queue
	if v ~= nil then
		for _, CVar in ipairs(CVarT) do if GetCVar(CVar) ~= v then SetCVar(CVar,v) end end
		queue = nil
	end
end

local function nameHide()
	local v = majorCity[C_Map_GetBestMapForUnit("player")] and 0 or 1
	if InCombatLockdown() then
		queue = v
	else
		for _, CVar in ipairs(CVarT) do if GetCVar(CVar) ~= v then SetCVar(CVar, v) end end
	end
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", nameHide)

local q = CreateFrame("Frame")
q:SetScript("OnEvent", queueRun)

function C:SetupNamehide()
	if C.db.namehide then
		f:RegisterEvent("PLAYER_ENTERING_WORLD")
		f:RegisterEvent("ZONE_CHANGED")
		f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		q:RegisterEvent("PLAYER_REGEN_ENABLED")
		nameHide()
	else
		f:UnregisterEvent("PLAYER_ENTERING_WORLD")
		f:UnregisterEvent("ZONE_CHANGED")
		f:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
		q:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
end

R:AddInitFunc(C.SetupNamehide)
