local _, rgsaddon = ...
local C, R = unpack(rgsaddon)

if C.db.nakePreview then
	function DressUpVisual(...)
		if ( SideDressUpFrame.parentFrame and SideDressUpFrame.parentFrame:IsShown() ) then
			if ( not SideDressUpFrame:IsShown() or SideDressUpFrame.mode ~= "player" ) then
				SideDressUpFrame.mode = "player";
				SideDressUpFrame.ResetButton:Show();

				local _, fileName = UnitRace("player");
				SetDressUpBackground(SideDressUpFrame, fileName);

				ShowUIPanel(SideDressUpFrame);
				SideDressUpModel:SetUnit("player");
			end
			SideDressUpModel:Undress()
			SideDressUpModel:TryOn(...);
		else
			DressUpFrame_Show();
			DressUpModel:Undress()
			DressUpModel:TryOn(...);
		end
		return true;
	end
end
