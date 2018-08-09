local addonName, rgsaddon = ...
local C, L = unpack(rgsaddon)

local _G = _G
local type, next, unpack, pairs = type, next, unpack, pairs
local PlaySound = PlaySound

local defaults = {
	stats = false,
	stealth = false,
	namehide = false,
}

rgsaddon:AddInitFunc(function()
	if type(rgsboxDB) ~= "table" or next(rgsboxDB) == nil then rgsboxDB = defaults end
	C.db = rgsboxDB
	-- fallback to defaults
	for k,v in pairs(defaults) do
		if C.db[k] == nil then C.db[k] = v end
		if type(v) == "table" then
			for k1,v1 in pairs(v) do
				if C.db[k][k1] == nil then C.db[k][k1] = v1 end
			end
		end
	end
	-- Start of DB Conversion
	-- End of DB conversion
	for k in pairs(C.db) do if defaults[k] == nil then C.db[k] = nil end end -- remove old keys
end)

-- GUI Template --
-- Table for DB initialize
local options = {check={}}

local configFrame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
configFrame.name = addonName
InterfaceOptions_AddCategory(configFrame)
local optionsPerLine = 3
local idx, first, previous = 1, configFrame, configFrame

local function SetFramePoint(frame, pos)
	if type(pos) == "table" then -- Set custom position
		frame:SetPoint(unpack(pos))
		idx, first = 1, frame
	else
		if pos > 0 and idx <= optionsPerLine - pos then -- same line
			frame:SetPoint("LEFT", previous, "LEFT", 170, 0)
			idx = idx + 1
		else -- next line
			frame:SetPoint("TOPLEFT", first, "TOPLEFT", 0, -40)
			idx, first = 1, frame
		end
	end
	previous = frame
end

local function newCheckBox(label, name, desc, pos, get, set, init)
	local check = CreateFrame("CheckButton", "RgsAddonConfig"..label, configFrame, "InterfaceOptionsCheckButtonTemplate")
	check:SetScript("OnClick", function(self)
		local checked = self:GetChecked()
		if set then set(checked) else C.db[label] = checked end
		PlaySound(checked and 856 or 857)
	end)
	check.getfunc = get or function() return C.db[label] end
	check.initfunc = init or function() end
	_G[check:GetName().."Text"]:SetText(name)
	check.tooltipText = name
	check.tooltipRequirement = desc
	SetFramePoint(check, pos)
	options.check[label] = check
end
-- End of GUI template --

C.mover = {}

local titleText = configFrame:CreateFontString(nil,"ARTWORK","GameFontNormalLarge")
titleText:SetPoint("TOPLEFT", configFrame, "TOPLEFT", 200, -20)
titleText:SetText(addonName)

rgsaddon:AddInitFunc(function()
	newCheckBox("stats", "实时属性", nil, {"TOPLEFT", configFrame, "TOPLEFT", 16, -60},
	nil,
	function(checked)
		C.db.stats = checked
		C:SetupStats(checked)
	end,
	function() C:SetupStats(C.db.stats) end)
	newCheckBox("stealth", "潜行警报", nil, 1,
	nil,
	function(checked)
		C.db.stealth = checked
		C:SetupStealth(checked)
	end,
	function() C:SetupStealth(C.db.stealth) end)
	newCheckBox("namehide", "主城隐藏姓名", nil, 1,
	nil,
	function(checked)
		C.db.namehide = checked
		C:SetupNamehide(checked)
	end,
	function() C:SetupNamehide(C.db.namehide) end)
	-- Set values in config
	for _,v in pairs(options.check) do
		v.initfunc()
		v:SetChecked(v.getfunc())
	end
end)
