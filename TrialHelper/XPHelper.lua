local _, Module = ...

local XPLockHelperFrame = CreateFrame("Frame")

-- Cache global functions for performance
local C_Map = C_Map
local UnitFactionGroup = UnitFactionGroup
local UnitLevel = UnitLevel
local StaticPopup_Show = StaticPopup_Show

-- Define NPC data
local npcData = {
	Alliance = { name = "Behsten", mapID = 84, x = 0.8767, y = 0.672 },
	Horde = { name = "Slahtz", mapID = 85, x = 0.7426, y = 0.443 },
}

-- Levels to trigger the XP lock reminder
local reminderLevels = {
	[10] = true,
	[11] = true,
	[19] = true,
	[20] = true,
}

-- Set a map pin to the Experience Eliminator NPC
local function SetMapPin()
	if not Module:GetOption("enableXPLock") then
		return
	end

	local faction = UnitFactionGroup("player")
	local npc = npcData[faction]
	if not npc then
		print("|cffff0000Faction not recognized. Unable to set map pin.|r")
		return
	end

	local mapID, x, y = npc.mapID, npc.x, npc.y
	if mapID and x and y then
		C_Map.ClearUserWaypoint()
		local waypoint = UiMapPoint.CreateFromCoordinates(mapID, x, y)
		if C_Map.SetUserWaypoint(waypoint) then
			C_SuperTrack.SetSuperTrackedUserWaypoint(true)
			print(string.format("|cff00ff00Waypoint successfully set at [%.2f, %.2f] on map ID %d|r", x * 100, y * 100, mapID))
		else
			print("|cffff0000Failed to set waypoint. Please verify mapID and coordinates.|r")
		end
	else
		print("|cffff0000Failed to create waypoint. Missing or invalid data.|r")
	end
end

-- Handle level-up logic for specified levels
local function OnLevelUp(level)
	if not Module:GetOption("enableXPLock") then
		return
	end

	if tonumber(level) > 20 then
		return
	end

	if not GameLimitedMode_IsActive() then
		return
	end

	if reminderLevels[tonumber(level)] then
		SetMapPin()
		if Module:GetOption("enableXPReminder") then
			StaticPopup_Show("XP_LOCK_INFO")
		end
	end
end

-- Event handler for level-up and login
local function HandleEvent(_, event, ...)
	if not Module:GetOption("enableXPLock") then
		return
	end

	if event == "PLAYER_LOGIN" then
		local level = UnitLevel("player")
		OnLevelUp(level)
	elseif event == "PLAYER_LEVEL_UP" then
		local level = ...
		OnLevelUp(level)
	end
end

-- Register events and set script
XPLockHelperFrame:RegisterEvent("PLAYER_LOGIN")
XPLockHelperFrame:RegisterEvent("PLAYER_LEVEL_UP")
XPLockHelperFrame:SetScript("OnEvent", HandleEvent)

-- Define the popup dialog
StaticPopupDialogs["XP_LOCK_INFO"] = {
	text = "|cff00ff00Congratulations!|r You have reached |cffffd100Level 20|r!\n\n" .. "A |cffffd100map pin|r has been set to the |cffffd100Experience Eliminator NPC|r " .. "in your capital city.\n\n|cff00ff00Why is this important?|r\n" .. "Visiting this NPC allows you to |cffff0000lock your XP gains|r for a fee of |cffffd10010 gold|r. " .. "This helps prevent unwanted leveling up, especially if you plan to purchase game time " .. "that will |cff00ff00unlock XP gain again|r.\n\n" .. "|cffffff00Visit the NPC now to lock your XP!|r",
	button1 = "Okay",
	button2 = "Don't Show Again",
	OnCancel = function()
		Module:SetOption("enableXPReminder", false)
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

-- Option Callbacks
Module:RegisterOptionCallback("enableXPLock", function()
	if Module:GetOption("enableXPLock") then
		XPLockHelperFrame:RegisterEvent("PLAYER_LOGIN")
		XPLockHelperFrame:RegisterEvent("PLAYER_LEVEL_UP")
	else
		XPLockHelperFrame:UnregisterAllEvents()
	end
end)

Module:RegisterOptionCallback("enableXPReminder", function()
	-- No direct actions needed, logic is dynamically handled in OnLevelUp
end)
