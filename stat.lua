local addonName, rgsaddon = ...
local C, L = unpack(rgsaddon)

local format = string.format

local intID = {
	[62] = true,
	[63] = true,
	[64] = true,
	[65] = true,
	[102] = true,
	[105] = true,
	[256] = true,
	[257] = true,
	[258] = true,
	[262] = true,
	[264] = true,
	[265] = true,
	[266] = true,
	[267] = true,
	[270] = true,
}
local agiID = {
	[103] = true,
	[104] = true,
	[253] = true,
	[254] = true,
	[255] = true,
	[259] = true,
	[260] = true,
	[261] = true,
	[263] = true,
	[268] = true,
	[269] = true,
	[577] = true,
	[581] = true,
}
local strID = {
	[66] = true,
	[70] = true,
	[71] = true,
	[72] = true,
	[73] = true,
	[250] = true,
	[251] = true,
	[252] = true,
}

local specType
local function specFunc()
	local currentSpec = GetSpecialization()
	local specId = GetSpecializationInfo(currentSpec)
	if intID[specId] then
		specType = 1
	elseif agiID[specId] then
		specType = 2
	else
		specType = 3
	end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
eventFrame:SetScript("OnEvent", specFunc)
	
local frame = CreateFrame("Frame", "MyStatFrame", UIParent)
frame:SetSize(300,200)
frame:SetPoint("BOTTOMLEFT",300,170)

SlashCmdList.MYSTAT = function() ToggleFrame(frame) end
SLASH_MYSTAT1 = "/mystat"


local text = frame:CreateFontString(nil,"ARTWORK","GameFontHighlightLarge")
text:SetAllPoints(frame)
local function statString(self, event,...)
	local mastery = format("精通: %.2f%%|n", GetMasteryEffect())
	local haste = format("急速: %.2f%%|n", GetHaste())
	local crit = format("暴击: %.2f%%|n", GetCritChance())
	local versatility = format("全能: %.2f%%", GetCombatRatingBonus(29) + GetVersatilityBonus(29))
	
	local primaryStat
	if specType == 1 then
		primaryStat = "智力: " .. UnitStat("player", 4).."|n"
	elseif specType == 2 then
		primaryStat = "敏捷: " .. UnitStat("player", 2).."|n"
	else
		primaryStat = "力量: " .. UnitStat("player", 1).."|n"
	end

	text:SetText(primaryStat..crit..haste..mastery..versatility)
end
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
frame:RegisterEvent("PLAYER_TALENT_UPDATE")
frame:RegisterEvent("PLAYER_DAMAGE_DONE_MODS")
frame:RegisterUnitEvent("UNIT_STATS", "player")
frame:RegisterUnitEvent("UNIT_AURA", "player")

function C:SetupStats(enable)
	if enable then
		frame:SetScript("OnEvent", statString)
	else
		frame:SetScript("OnEvent", nil)
	end
end
