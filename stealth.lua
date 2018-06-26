local addonName, rgsaddon = ...
local C, L = unpack(rgsaddon)

local raceTbl = {
	Human = "Alliance",
	NightElf = "Alliance",
	Dwarf = "Alliance",
	Gnome = "Alliance",
	Draenei = "Alliance",
	Worgen = "Alliance",
	Orc = "Horde",
	Troll = "Horde",
	Scourge = "Horde",
	Tauren = "Horde",
	BloodElf = "Horde",
	Goblin = "Horde",
	--Pandaren
	VoidElf = "Alliance",
	LightforgedDraenei = "Alliance",
	HighmountainTauren = "Horde",
	Nightborne = "Horde",
}

local spellTbl = {
	[1856] = ">>>消失<<<",
	[1784] = ">>>潜行<<<",
	[5215] = ">>>潜行<<<",
}

local myFaction
rgsaddon:AddInitFunc(function() myFaction = UnitFactionGroup("player") end)

local function GetFactionByGUID(guid)
	if not guid then return end
	local _,_,_,race = GetPlayerInfoByGUID(guid)
	return raceTbl[race]
end

local function StealthAlert(_,_,_, Event, _, sourceGUID, _, _, _, _, _, _, _, spellID)
	if Event == "SPELL_CAST_SUCCESS" then
		local faction = GetFactionByGUID(sourceGUID)
		if faction and faction ~= myFaction then
			local alert = spellTbl[spellID]
			if alert then DEFAULT_CHAT_FRAME:AddMessage(alert,1,0,0) end
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

function C:SetupStealth(enable)
	if enable then
		frame:SetScript("OnEvent", StealthAlert)
	else
		frame:SetScript("OnEvent", nil)
	end
end
