local E = ElvUI[1]
local RgsToolbox = E:NewModule('RgsToolbox');
local EP = LibStub("LibElvUIPlugin-1.0")
local addonName, rgsaddon = ...
rgsaddon[1] = {} -- Config
rgsaddon[2] = RgsToolbox

local init = {}
function RgsToolbox:AddInitFunc(func)
    init[#init+1] = func
end

function RgsToolbox:Initialize()
    for _,v in ipairs(init) do v() end
    init = nil
    EP:RegisterPlugin(addonName, RgsToolbox.InsertOptions)
end

E:RegisterModule(RgsToolbox:GetName())
