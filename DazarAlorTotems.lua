-- Stolen and simplified from addon: Dazar'Alor Totems
-- Credit goes to its author: Smonman

local _, rgsaddon = ...
local C, R = unpack(rgsaddon)

local mapF = WorldMapFrame.ScrollContainer.Child

local nodeSize = 32
local width = 90

local E = {}

local allNodeCoords = {
	1900, -840, true,	--1
	1918, -1020, false,	--2

	1960, -1055, true,	--3
	1920, -1115, false,	--4

	1615, -970, true,	--5
	1800, -2190, true,	--6

	1615, -1020, true,	--7
	1918, -1020, false,	--8

	1645, -600, true,	--9
	1565, -285, true,	--10

	1805, -500, true,	--11
	1930, -840, false,	--12

	2025, -315, true,	--13
	1725, -160, true,	--14

	2025, -280, true,	--15
	2280, -280, true,	--16

	2040, -500, true,	--17
	2027, -300, false,	--18

	1735, -133, true,	--19
	1780, -520, false,	--20

	2260, -830, true,	--21
	2930, -1020, false,	--22

	2750, -375, true,	--23
	2270, -580, false,	--24

	1565, -2150, true,	--25
	1800, -2210, false	--26
}

-- Dazar'Alor = 1165
hooksecurefunc(WorldMapFrame, "OnMapChanged", function(self)
	if self:GetMapID() == 1165 then
		mapF.dazarAlor:Show()
	else
		mapF.dazarAlor:Hide()
	end
end)

R:AddInitFunc(function()
	mapF.dazarAlor = CreateFrame("FRAME", "DazarAlorFrame", mapF)
	mapF.dazarAlor:SetAllPoints(mapF)
	mapF.dazarAlor:SetFrameStrata("MEDIUM")

	E:SetupTextures()
end)

local function NewNode(x, y, isStartNode, size, parent)
	local tex = parent:CreateTexture("BACKGROUND")
	tex:SetDrawLayer("BACKGROUND", -7)
	if isStartNode then
		tex:SetTexture("INTERFACE\\TAXIFRAME\\UI-Taxi-Icon-Yellow.blp")
		tex:SetSize(size, size)
		tex:SetPoint("TOPLEFT", parent, "TOPLEFT", x - size / 2, y + size / 2)
	else
		tex:SetTexture("INTERFACE\\TAXIFRAME\\UI-Taxi-Icon-Nub.blp")
		tex:SetSize(size / 1.2, size / 1.2)
		tex:SetPoint("TOPLEFT", parent, "TOPLEFT", x - size / 1.2 / 2, y + size / 1.2 / 2)
	end
end

-- http://www.wowinterface.com/forums/showthread.php?p=15012
local function NewLine(sx, sy, ex, ey, w, parent)
	local T = parent:CreateTexture("BACKGROUND")
	T:SetDrawLayer("BACKGROUND", -8)

	local LINEFACTOR_2 = 32 / 60; -- Half o that

	-- Determine dimensions and center point of line
	local dx,dy = ex - sx, ey - sy;
	local cx,cy = (sx + ex) / 2, (sy + ey) / 2;

	-- Normalize direction if necessary
	if (dx < 0) then
		dx,dy = -dx,-dy;
	end

	-- Calculate actual length of line
	local l = sqrt((dx * dx) + (dy * dy));

	-- Quick escape if it's zero length
	if (l == 0) then
		T:SetTexCoord(0,0,0,0,0,0,0,0);
		T:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", cx,cy);
		T:SetPoint("TOPRIGHT", parent, "TOPLEFT", cx,cy);
		return;
	end

	-- Sin and Cosine of rotation, and combination (for later)
	local s,c = -dy / l, dx / l;
	local sc = s * c;

	-- Calculate bounding box size and texture coordinates
	local Bwid, Bhgt, BLx, BLy, TLx, TLy, TRx, TRy, BRx, BRy;
	if (dy >= 0) then
		Bwid = ((l * c) - (w * s)) * LINEFACTOR_2;
		Bhgt = ((w * c) - (l * s)) * LINEFACTOR_2;
		BLx, BLy, BRy = (w / l) * sc, s * s, (l / w) * sc;
		BRx, TLx, TLy, TRx = 1 - BLy, BLy, 1 - BRy, 1 - BLx;
		TRy = BRx;
	else
		Bwid = ((l * c) + (w * s)) * LINEFACTOR_2;
		Bhgt = ((w * c) + (l * s)) * LINEFACTOR_2;
		BLx, BLy, BRx = s * s, -(l / w) * sc, 1 + (w / l) * sc;
		BRy, TLx, TLy, TRy = BLx, 1 - BRx, 1 - BLx, 1 - BLy;
		TRx = TLy;
	end

	-- Set texture coordinates and anchors
	T:SetTexture("INTERFACE\\TAXIFRAME\\UI-Taxi-Line.blp")
	T:SetTexCoord(TLx, TLy, BLx, BLy, TRx, TRy, BRx, BRy);
	T:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", cx - Bwid, cy - Bhgt);
	T:SetPoint("TOPRIGHT", parent, "TOPLEFT", cx + Bwid, cy + Bhgt);
	T:SetVertexColor(1, 1, 1, 1)
	return T
end

function E:SetupTextures()
	for i = 1, #allNodeCoords, 6 do
		NewNode(allNodeCoords[i], allNodeCoords[i + 1], allNodeCoords[i + 2], nodeSize, mapF.dazarAlor)
		NewNode(allNodeCoords[i + 3], allNodeCoords[i + 4], allNodeCoords[i + 5], nodeSize, mapF.dazarAlor)
		NewLine(allNodeCoords[i], allNodeCoords[i + 1], allNodeCoords[i + 3], allNodeCoords[i + 4], width, mapF.dazarAlor)
	end
end
