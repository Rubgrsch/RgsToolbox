local _, rgsaddon = ...
rgsaddon[1] = {} -- Config
rgsaddon[2] = {} -- Locales
local C, L = unpack(rgsaddon)
setmetatable(L, {__index=function(_, key) return key end})

local init = {}
function rgsaddon:AddInitFunc(func)
	init[#init+1] = func
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	for _,v in ipairs(init) do v() end
	init = nil
end)
