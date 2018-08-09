local _, rgsaddon = ...
local C, R = unpack(rgsaddon)

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

local function StealthAlert()
	local _, Event, _, sourceGUID, _, _, _, _, _, _, _, spellID = CombatLogGetCurrentEventInfo()
	if Event == "SPELL_CAST_SUCCESS" and sourceGUID and type(sourceGUID) == "string" and sourceGUID ~= "" then
		local _,_,_,race = GetPlayerInfoByGUID(sourceGUID)
		local faction = raceTbl[race]
		if faction and faction ~= UnitFactionGroup("player") then
			local alert = spellTbl[spellID]
			if alert then DEFAULT_CHAT_FRAME:AddMessage(alert,1,0,0) end
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

function C:SetupStealth()
	if C.db.stealth then
		frame:SetScript("OnEvent", StealthAlert)
	else
		frame:SetScript("OnEvent", nil)
	end
end

R:AddInitFunc(C.SetupStealth)
