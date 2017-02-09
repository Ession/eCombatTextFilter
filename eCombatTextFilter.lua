-- =============================================================================
-- 
--       Filename:  eCombatTextFilter.lua
-- 
--    Description:  Filters low healing numbers from the wow combat text.
--  
--         Author:  Mathias Jost (mail@mathiasjost.com)
-- 
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Minimum amount of healing to be displayed.
-- Anything lower than this value will be filtered out.
-- -----------------------------------------------------------------------------
local minthreshold = 30000

-- -----------------------------------------------------------------------------
-- Create the main frame and other variables for the addon
-- -----------------------------------------------------------------------------
local eCombatTextFilter = CreateFrame("Frame")

eCombatTextFilter:RegisterEvent("COMBAT_TEXT_UPDATE")

-- -----------------------------------------------------------------------------
-- Eventhandler
-- -----------------------------------------------------------------------------
local function EventHandler(self, event, str, ...)

	local OrigEventHandler = _G.CombatText_OnEvent

	-- Override the original event handler with our own hook
	CombatText:SetScript("OnEvent", function(self, event, ...)
		
		local combat_text_type, target_unit, healing_amount, _ = ...;
		
		if ( combat_text_type == "HEAL" 
		  or combat_text_type == "PERIODIC_HEAL"
		  or combat_text_type == "HEAL_ABSORB" 
		  or combat_text_type == "PERIODIC_HEAL_ABSORB"
		  or combat_text_type == "HEAL_CRIT" 
		  or combat_text_type == "PERIODIC_HEAL_CRIT"
		  or combat_text_type == "HEAL_CRIT_ABSORB"
		  or combat_text_type == "ABSORB_ADDED" )
		 and healing_amount <= minthreshold then
			-- Hide this heal!
			return;	
		else
			-- Call the original event handler as if nothing happened
			return OrigEventHandler(self, event, ...);		
		end
		
	end) --	CombatText:SetScript("OnEvent", function(self, event, ...)
	
end -- local function EventHandler(self, event, str, ...)


-- -----------------------------------------------------------------------------
-- Initializes the addon and registers the events
-- -----------------------------------------------------------------------------
eCombatTextFilter:SetScript("OnEvent", EventHandler)