local enabled = true
if not enabled then return end

function DressUpVisual(...)
	local frame
	if SideDressUpFrame.parentFrame and SideDressUpFrame.parentFrame:IsShown() then
		frame = SideDressUpFrame
		if not raceFilename then
			raceFilename = select(2, UnitRace("player"))
		end
	else
		frame = DressUpFrame;
		if not classFilename then
			classFilename = select(2, UnitClass("player"))
		end
	end
	SetDressUpBackground(frame, raceFilename, classFilename)

	DressUpFrame_Show(frame)

	local playerActor = frame.ModelScene:GetPlayerActor()
	if (not playerActor) then
		return false;
	end

	playerActor:Undress()
	local result = playerActor:TryOn(...)
	if ( result ~= Enum.ItemTryOnReason.Success ) then
		UIErrorsFrame:AddExternalErrorMessage(ERR_NOT_EQUIPPABLE)
	end
	DressUpFrame_OnDressModel(frame)
	return true
end
