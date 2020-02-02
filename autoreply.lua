local C_Scenario_GetStepInfo, C_BattleNet_GetGameAccountInfoByGUID, C_ChallengeMode_IsChallengeModeActive, C_FriendList_IsFriend, C_ChallengeMode_GetActiveKeystoneInfo, C_Scenario_GetInfo, C_Scenario_GetCriteriaInfo, C_Timer_After = C_Scenario.GetStepInfo, C_BattleNet.GetGameAccountInfoByGUID,  C_ChallengeMode.IsChallengeModeActive, C_FriendList.IsFriend, C_ChallengeMode.GetActiveKeystoneInfo, C_Scenario.GetInfo, C_Scenario.GetCriteriaInfo, C_Timer.After
local format, pairs, BNSendWhisper, SendChatMessage, IsGuildMember = string.format, pairs, BNSendWhisper, SendChatMessage, IsGuildMember

local function replyString()
	local _, _, steps = C_Scenario_GetStepInfo()
	local bosses, totalbosses, progress = 0, 0
	for i=1, steps do
		local _, _, completed, quantity, totalQuantity, _, _, _, _, _, _, _, isWeightedProgress = C_Scenario_GetCriteriaInfo(i)
		if isWeightedProgress then
			progress = completed and 100 or quantity
		else
			bosses = bosses + quantity
			totalbosses = totalbosses + totalQuantity
		end
	end
	local dungeonLevel = C_ChallengeMode_GetActiveKeystoneInfo()
	local dungeonName = C_Scenario_GetInfo()
	return format("正在进行史诗钥石 +%d %s | 首领%d/%d | 进度%.0f%%", dungeonLevel, dungeonName, bosses, totalbosses, progress)
end

local frame = CreateFrame("Frame")

local sentPlayers, wipeTimer = {}, false
local function WipePlayers() for k in pairs(sentPlayers) do sentPlayers[k] = nil end wipeTimer = false end
local function SentMessage(target)
	sentPlayers[target] = true
	if not wipeTimer then
		wipeTimer = true
		C_Timer_After(60, WipePlayers)
	end
end

function frame:CHAT_MSG_WHISPER(_, _, sender, _, _, _, _, _, _, _, _, _, guid)
	if C_ChallengeMode_IsChallengeModeActive() and (C_BattleNet_GetGameAccountInfoByGUID(guid) or IsGuildMember(guid) or C_FriendList_IsFriend(guid)) and not (UnitInRaid(sender) or UnitInParty(sender)) and not sentPlayers[sender] then
		SentMessage(sender)
		SendChatMessage(replyString(), "WHISPER", nil, sender)
	end
end

function frame:CHAT_MSG_BN_WHISPER(_, _, _, _, _, _, _, _, _, _, _, _, _, bnSenderID)
	if C_ChallengeMode_IsChallengeModeActive() and not sentPlayers[bnSenderID] then
		local index = BNGetFriendIndex(bnSenderID)
		local gameAccs = C_BattleNet.GetFriendNumGameAccounts(index)
		for i=1, gameAccs do
			local gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(index, i)
			if gameAccountInfo.clientProgram == "WoW" then
				local player = gameAccountInfo.characterName
				if gameAccountInfo.realmName ~= GetRealmName() then
					player = player .. "-" .. gameAccountInfo.realmName
				end
				if UnitInRaid(player) or UnitInParty(player) then
					return
				end
			end
		end
		SentMessage(bnSenderID)
		BNSendWhisper(bnSenderID, replyString())
	end
end

frame:RegisterEvent("CHAT_MSG_WHISPER")
frame:RegisterEvent("CHAT_MSG_BN_WHISPER")
frame:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)
