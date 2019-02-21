local addonName, rgsaddon = ...
local C, R = {}, {}
rgsaddon[1] = C -- Config
rgsaddon[2] = R -- Func

local init = {}
function R:AddInitFunc(func)
    init[#init+1] = func
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    for _,v in ipairs(init) do v() end
    init = nil
end)
