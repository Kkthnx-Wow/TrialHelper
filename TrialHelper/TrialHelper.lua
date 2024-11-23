local _, Module = ...

-- Constants
local ADDON_ICON = "|TInterface\\Icons\\Achievement_guild_level20:14:14:0:0|t"
local ADDON_NAME = "|cff5bc0beTrial Helper|r"
local DIMMED_WHITE = "|cffcccccc"
local ICON_SIZE = ":14:14:0:0"

local CLASS_ICONS = {
	WARRIOR = "Interface\\Icons\\ClassIcon_Warrior",
	PALADIN = "Interface\\Icons\\ClassIcon_Paladin",
	HUNTER = "Interface\\Icons\\ClassIcon_Hunter",
	ROGUE = "Interface\\Icons\\ClassIcon_Rogue",
	PRIEST = "Interface\\Icons\\ClassIcon_Priest",
	DEATHKNIGHT = "Interface\\Icons\\ClassIcon_DeathKnight",
	SHAMAN = "Interface\\Icons\\ClassIcon_Shaman",
	MAGE = "Interface\\Icons\\ClassIcon_Mage",
	WARLOCK = "Interface\\Icons\\ClassIcon_Warlock",
	MONK = "Interface\\Icons\\ClassIcon_Monk",
	DRUID = "Interface\\Icons\\ClassIcon_Druid",
	DEMONHUNTER = "Interface\\Icons\\ClassIcon_DemonHunter",
	EVOKER = "Interface\\Icons\\ClassIcon_Evoker",
}

-- Functions
local function ShowLoginMessage()
	if not Module:GetOption("showLoginMessage") then
		return
	end

	local playerName = UnitName("player")
	local _, playerClass = UnitClass("player")
	local classColor = RAID_CLASS_COLORS[playerClass]
	local coloredName = string.format("|cff%02x%02x%02x%s|r", classColor.r * 255, classColor.g * 255, classColor.b * 255, playerName)
	local classIcon = CLASS_ICONS[playerClass] and "|T" .. CLASS_ICONS[playerClass] .. ICON_SIZE .. "|t" or ""

	print(DIMMED_WHITE .. " Thank you for using " .. ADDON_ICON .. ADDON_NAME .. ", " .. classIcon .. coloredName .. "! Enjoy your trial account experience.|r")
end

local function CloseSubscriptionFrame()
	local subscriptionFrame = SubscriptionInterstitialFrame
	if subscriptionFrame and subscriptionFrame:IsShown() then
		subscriptionFrame.ClosePanelButton:Click()
	end
end

local function UpdateMiniMapMailIcon()
	if Module:GetOption("toggleMailIcon") then
		MiniMapMailIcon:Show()
	else
		MiniMapMailIcon:Hide()
	end
end

local function HandleTrialHelperEvents(event)
	if not GameLimitedMode_IsActive() then
		return
	end

	if event == "UPDATE_PENDING_MAIL" then
		C_Timer.After(0.5, UpdateMiniMapMailIcon)
	elseif event == "ADDON_LOADED" or event == "PLAYER_LEVEL_UP" then
		C_Timer.After(0.5, CloseSubscriptionFrame)
		TrialAccountCapReached_Inform()
	end
end

local function MonitorExpansionTrialDialog()
	if not Module:GetOption("enableTrialHelper") then
		return
	end

	local trialDialog = ExpansionTrialCheckPointDialog
	if trialDialog and trialDialog:IsShown() then
		trialDialog.CloseButton:Click()
	end
end

-- Event Handling
local TrialHelperFrame = CreateFrame("Frame", "TrialHelperFrame", UIParent)
TrialHelperFrame:RegisterEvent("PLAYER_LOGIN")
TrialHelperFrame:RegisterEvent("ADDON_LOADED")
TrialHelperFrame:RegisterEvent("PLAYER_LEVEL_UP")
TrialHelperFrame:RegisterEvent("UPDATE_PENDING_MAIL")

TrialHelperFrame:SetScript("OnEvent", function(_, event, addon)
	if not Module:GetOption("enableTrialHelper") then
		return
	end

	if event == "PLAYER_LOGIN" then
		ShowLoginMessage()
		UpdateMiniMapMailIcon()
	else
		HandleTrialHelperEvents(event)
	end
end)

TrialHelperFrame:SetScript("OnUpdate", MonitorExpansionTrialDialog)

-- Option Callbacks
Module:RegisterOptionCallback("toggleMailIcon", UpdateMiniMapMailIcon)

Module:RegisterOptionCallback("enableTrialHelper", function()
	if Module:GetOption("enableTrialHelper") then
		TrialHelperFrame:RegisterEvent("PLAYER_LOGIN")
		TrialHelperFrame:RegisterEvent("ADDON_LOADED")
		TrialHelperFrame:RegisterEvent("PLAYER_LEVEL_UP")
		TrialHelperFrame:RegisterEvent("UPDATE_PENDING_MAIL")
		TrialHelperFrame:SetScript("OnUpdate", MonitorExpansionTrialDialog)
	else
		TrialHelperFrame:UnregisterAllEvents()
		TrialHelperFrame:SetScript("OnUpdate", nil)
	end
end)

Module:RegisterOptionCallback("showLoginMessage", function()
	-- No additional actions are needed since the login message is handled during PLAYER_LOGIN
end)
