-- Add DELETE when deleting items
hooksecurefunc(StaticPopupDialogs["DELETE_GOOD_ITEM"],"OnShow",function(s) s.editBox:SetText(DELETE_ITEM_CONFIRM_STRING) end)

-- Hide boss loot banner
BossBanner:UnregisterEvent("ENCOUNTER_LOOT_RECEIVED")
BossBanner:UnregisterEvent("BOSS_KILL")

StaticPopupDialogs["LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS"] = {
	text = "针对此项活动，你的队伍人数已满，将被移出列表。",
	button1 = OKAY,
	timeout = 0,
	whileDead = 1,
}

if not GuildControlUIRankSettingsFrameRosterLabel then
	GuildControlUIRankSettingsFrameRosterLabel = CreateFrame("Frame")
	GuildControlUIRankSettingsFrameRosterLabel:Hide()
end
