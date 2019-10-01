local _, namespace = ...

local HitList = namespace.HitList
local Interface = namespace.Interface

-- A list of known nameplates to ids
local guids = {}
-- a list of names to units
local unitIds = {}

local f = CreateFrame("Frame")

-- Sets up the chat command /kos
SLASH_KOS1 = '/kos'
function SlashCmdList.KOS(msg, editbox)
	local name = ""
	local rating = 3 -- default 3 rating
		
	-- Look through function params to do the right thing
	for i in string.gmatch(msg, "%S+") do
		-- cast to a number for evaluation
		local num = tonumber(i)
		
		if num and num <= 5 then
			rating = num;
		elseif not num then
			name = i;
		end
	end

	print("Added", name, "to the hit list with rating", rating)
	HitListData[name] = rating
	
	-- If the nameplate for this player is still visible then
	-- Refresh nameplates so that star rating appears immediately
	if unitIds[name] then
		Interface:CreateKillAnchor(unitIds[name], rating)
	end
end

-- Erases local hit list data and restores defaults
-- This is useful for testing
SLASH_KOSDEFAULT1 = '/kosdefault'
function SlashCmdList.KOSDEFAULT(msg, editbox)
	HitListData = nil
	
	-- force refresh the UI for changes to take place
	C_UI.Reload()
end

-- Returns the star rating for the given player
-- if it exists in the hit list
local function getStarRating(unit)
	local name = GetUnitName(unit, false)
	
	for target, stars in pairs(HitListData) do
		if string.lower(name) == string.lower(target) then
			return stars
		end
	end
	
	return 0
end

-- Fired once when saved variables become available
function f:ADDON_LOADED(arg1)
	if arg1 == "KillOnSight" then
		-- KOS variables are available now
		if HitListData == nil then
			-- This is the first time loading this addon so save the
			-- current list to savedVariables
			HitListData = HitList
		end
	end
end

-- Function that triggers when a new nameplate is added to the screen
function f:NAME_PLATE_UNIT_ADDED(unit)
	guids[UnitGUID(unit)] = unit
	unitIds[GetUnitName(unit, false)] = unit
	
	local starRating = getStarRating(unit)
	
	if starRating > 0 then
		print("Kill on sight", GetUnitName(unit, false), "spotted")

		Interface:CreateKillAnchor(unit, starRating)
	end
end

-- Clean up function that runs when nameplates are removed from the screen
function f:NAME_PLATE_UNIT_REMOVED(unit)
	guids[UnitGUID(unit)] = nil
	unitIds[GetUnitName(unit, false)] = nil
end

f:SetScript("OnEvent", function(self, event, ...)
	f[event](self, ...)
end)

f:RegisterEvent("NAME_PLATE_UNIT_ADDED")
f:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
f:RegisterEvent("ADDON_LOADED")
