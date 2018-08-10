local _, rgsaddon = ...
local C, R = unpack(rgsaddon)
local E, _, _, P = unpack(ElvUI)

local pairs = pairs

P.RgsToolbox = {
	stats = false,
	stealth = false,
	namehide = false,
}

R:AddInitFunc(function()
	if not E.db.RgsToolbox then E.db.RgsToolbox = {} end
	C.db = E.db.RgsToolbox
end)

function R:InsertOptions()
	E.Options.args.RgsToolbox = {
		order = 1000,
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
