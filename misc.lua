-- Add DELETE when deleting items
hooksecurefunc(StaticPopupDialogs["DELETE_GOOD_ITEM"],"OnShow",function(s) s.editBox:SetText(DELETE_ITEM_CONFIRM_STRING) end)

-- Hide boss loot banner
BossBanner:UnregisterEvent("BOSS_KILL")

-- Fix LFG globalstring error
if GetLocale() == "zhCN" then
	StaticPopupDialogs["LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS"] = {
		text = "针对此项活动，你的队伍人数已满，将被移出列表。",
		button1 = OKAY,
		timeout = 0,
		whileDead = 1,
	}
end

-- Auto Achievement Screenshot, stolen from EKCore
local AutoScreenshot = CreateFrame("Frame")
AutoScreenshot:RegisterEvent("ACHIEVEMENT_EARNED")
AutoScreenshot:RegisterEvent("CHALLENGE_MODE_COMPLETED") -- SCENARIO_COMPLETED/SCENARIO_CRITERIA_UPDATE/SCENARIO_UPDATE?
AutoScreenshot:SetScript("OnEvent", function()
	C_Timer.After(1,Screenshot)
end)

--[[
-- Warning with mod keys holding
local modKeyDown = false

local function WarnModKeyStucked()
	if modKeyDown then ChatFrame1:AddMessage("你的"..modKeyDown.."卡住了！") end
end

local ModKeyFrame = CreateFrame("Frame")
ModKeyFrame:RegisterEvent("MODIFIER_STATE_CHANGED")
ModKeyFrame:SetScript("OnEvent", function(_, _, key, down)
	if down == 1 then
		modKeyDown = key
		C_Timer.After(3, WarnModKeyStucked)
	else
		modKeyDown = false
	end
end)
]]
