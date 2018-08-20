-- Add DELETE when deleting items
hooksecurefunc(StaticPopupDialogs["DELETE_GOOD_ITEM"],"OnShow",function(s) s.editBox:SetText(DELETE_ITEM_CONFIRM_STRING) end)

-- Hide boss loot banner
BossBanner:UnregisterEvent("ENCOUNTER_LOOT_RECEIVED")
BossBanner:UnregisterEvent("BOSS_KILL")


if not GuildControlUIRankSettingsFrameRosterLabel then
	GuildControlUIRankSettingsFrameRosterLabel = CreateFrame("Frame")
	GuildControlUIRankSettingsFrameRosterLabel:Hide()
end
