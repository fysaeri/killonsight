local _, namespace = ...

local Interface = {}
namespace.Interface = Interface

local starSize = 10

local function getPosition (index, rating)
	local positions = {
		[1] = {
			[1] = { -starSize, -5 },
		},
		[2] = {
			[1] = { -starSize, -5 },
			[2] = { -(2.25 * starSize), -5 }
		},
		[3] = {
			[1] = { -starSize, -5 },
			[2] = { -(2.5 * starSize), -5 },
			[3] = { -(1.75 * starSize), 5 }
		},
		[4] = {
			[1] = { -starSize, -5 },
			[2] = { -(3 * starSize), -5 },
			[3] = { -(2 * starSize), 5 },
			[4] = { -(2 * starSize), -15 },
		},
		[5] = {
			[1] = { -(2 * starSize), 5 },
			[2] = { -(3 * starSize), -5 },
			[3] = { -(1 * starSize), -5 },
			[4] = { -(2.5 * starSize), -15 },
			[5] = { -(1.5 * starSize), -15 },
		}
	}
	
	return positions[rating][index]
end

-- Creates and attaches custom nameplate UI for the targeted player
function Interface:CreateKillAnchor(unit, starRating)
		local frame = _G.C_NamePlate.GetNamePlateForUnit(unit)
		
		for i=1,starRating do
			local starPosition = getPosition(i, starRating)
			
			local star = CreateFrame("Frame", nil, frame)
			star:SetFrameStrata("BACKGROUND")

			local t = star:CreateTexture(nil,"BACKGROUND")
			t:SetTexture("Interface\\Addons\\KillOnSight\\star.blp")
			t:SetAllPoints(star)
			star.texture = t
			star:SetWidth(starSize)
			star:SetHeight(starSize)
			star:SetPoint("LEFT", frame, "LEFT", starPosition[1], starPosition[2])
		end
end