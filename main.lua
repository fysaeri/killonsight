local _, namespace = ...

local HitList = namespace.HitList
local Interface = namespace.Interface

-- A list of known nameplates
local guids = {}

local f = CreateFrame("Frame")

-- Searches the hit list for the given name to see
-- if it matches anyone
local function getStarRating(unit)
	local name = GetUnitName(unit, false)
	
	for target, stars in pairs(HitList) do
		if string.lower(name) == string.lower(target) then
			return stars
		end
	end
	
	return 0
end

-- Function that triggers when a new nameplate is added to the screen
function f:NAME_PLATE_UNIT_ADDED(unit)
	guids[UnitGUID(unit)] = unit
	
	local starRating = getStarRating(unit)
	
	if starRating > 0 then
		print("Kill on sight", GetUnitName(unit, false), "spotted")

		Interface:CreateKillAnchor(unit, starRating)
	end
end

-- Clean up function that runs when nameplates are removed from the screen
function f:NAME_PLATE_UNIT_REMOVED(unit)
	guids[UnitGUID(unit)] = nil
end

f:SetScript("OnEvent", function(self, event, ...)
	f[event](self, ...)
end)

f:RegisterEvent("NAME_PLATE_UNIT_ADDED")
f:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
