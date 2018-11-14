-- Stolen from EKCore, credit goes to EKE

-- [[ 根據地點調整亮度 ]] --

local tbl = {
	[1015] = true,	-- 威奎斯特莊園 / Waycrest Manor - The Grand Foyer
	[1016] = true,	-- 威奎斯特莊園 / Waycrest Manor - Upstairs
	[1017] = true,	-- 威奎斯特莊園 / Waycrest Manor - The Cellar
	[1018] = true,	-- 威奎斯特莊園 / Waycrest Manor - Catacombs

	[974] = true,	-- 托達戈爾 / Tol Dagor
	[975] = true,	-- 托達戈爾 / Tol Dagor - The Drain
	[976] = true,	-- 托達戈爾 / Tol Dagor - The Brig
	[977] = true,	-- 托達戈爾 / Tol Dagor - Detention Block
	[978] = true,	-- 托達戈爾 / Tol Dagor - Officer Quarters
	[979] = true,	-- 托達戈爾 / Tol Dagor - Overseer's Redoubt
	[980] = true,	-- 托達戈爾 / Tol Dagor - Overseer's Summit
}

local function changeGamma()
	local MapId = C_Map.GetBestMapForUnit("player")
	if MapId and tbl[MapId] then
		SetCVar("Gamma", 1.2)
	else
		SetCVar("Gamma", 1)
	end
end

local frame = CreateFrame("Frame", "changeGamma")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ZONE_CHANGED")
frame:RegisterEvent("ZONE_CHANGED_INDOORS")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:SetScript("OnEvent", changeGamma)
