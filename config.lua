local _, rgsaddon = ...
local C, R = unpack(rgsaddon)
local E, _, _, _, G = unpack(ElvUI)

local pairs = pairs

local defaults = {
	stats = false,
	stealth = false,
	namehide = false,
}

R:AddInitFunc(function()
	C.db = G.RgsToolbox or {}
	-- fallback to defaults
	for k,v in pairs(defaults) do if C.db[k] == nil then C.db[k] = v end end
	-- Start of DB Conversion
	-- End of DB conversion
	for k in pairs(C.db) do if defaults[k] == nil then C.db[k] = nil end end -- remove old keys
end)

function R:InsertOptions()
	E.Options.args.RgsToolbox = {
		order = 100,
		type = "group",
		name = "RgsToolbox",
		get = function(info) return C.db[info[#info]] end,
		args = {
			stats = {
				order = 1,
				name = "实时属性",
				type = "toggle",
				set = function(info,value) C.db[info[#info]] = value; C:SetupStats() end,
			},
			stealth = {
				order = 2,
				name = "潜行警报",
				type = "toggle",
				set = function(info,value) C.db[info[#info]] = value; C:SetupStealth() end,
			},
			namehide = {
				order = 3,
				name = "主城隐藏姓名",
				type = "toggle",
				set = function(info,value) C.db[info[#info]] = value; C:SetupNamehide() end,
			},
		},
	}
end
