local _, Module = ...

-- Function to populate the About section
local function CreateAboutSection(canvas)
	local padding = 16

	-- Addon Description
	local description = canvas:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	description:SetPoint("TOPLEFT", canvas, "TOPLEFT", padding, -padding)
	description:SetPoint("TOPRIGHT", canvas, "TOPRIGHT", -padding, -padding)
	description:SetText("|cff5bc0beTrial Helper|r is a World of Warcraft addon designed to enhance the Trial Account experience. " .. "It automates common tasks, manages subscription-related notifications, and provides a clean interface " .. "for Trial players. We hope this addon makes your trial journey more enjoyable!")
	description:SetJustifyH("LEFT")
	description:SetJustifyV("TOP")
	description:SetWordWrap(true)

	-- Spacer
	local spacer1 = canvas:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	spacer1:SetPoint("TOPLEFT", description, "BOTTOMLEFT", 0, -padding)
	spacer1:SetText(" ")

	-- Starter Edition Limitations
	local limitationsTitle = canvas:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	limitationsTitle:SetPoint("TOPLEFT", spacer1, "BOTTOMLEFT", 0, -padding)
	limitationsTitle:SetText("World of Warcraft Starter Edition Limitations:")

	local limitations = canvas:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	limitations:SetPoint("TOPLEFT", limitationsTitle, "BOTTOMLEFT", 0, -padding)
	limitations:SetPoint("TOPRIGHT", canvas, "TOPRIGHT", -padding, -padding)
	limitations:SetText(
		"- |cffffd700Character Level Cap:|r Level any character up to 20. You are currently level "
			.. UnitLevel("player")
			.. ".\n\n"
			.. "- |cffffd700Gold Limit:|r Earn up to 1,000 gold per character.\n\n"
			.. "- |cffffd700Chat Restrictions:|r Limited to /say and /party channels. Characters ten or more levels higher will not see your /say messages.\n\n"
			.. "- |cffffd700Dungeon Finder Access:|r Access to the Random Dungeon Finder.\n\n"
			.. "- |cffffd700Whisper Limitations:|r Whisper World of Warcraft friends added by character name to your in-game friend list. RealID friends are not available.\n\n"
			.. "- |cffffd700Guild and Trading Restrictions:|r No access to guild-related functions, trading, mail, or the Auction House.\n\n"
			.. "- |cffffd700Other Limitations:|r No access to Pet Battles, most recent expansion content, and certain chat channels."
	)
	limitations:SetJustifyH("LEFT")
	limitations:SetJustifyV("TOP")
	limitations:SetWordWrap(true)

	-- Spacer
	local spacer2 = canvas:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	spacer2:SetPoint("TOPLEFT", limitations, "BOTTOMLEFT", 0, -padding)
	spacer2:SetText(" ")

	-- Author and Version Info
	local info = canvas:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	info:SetPoint("TOPLEFT", spacer2, "BOTTOMLEFT", 0, -padding)
	info:SetPoint("TOPRIGHT", canvas, "TOPRIGHT", -padding, -padding)
	info:SetText("Version: |cffffd7001.0.0|r\n" .. "Author: |cff5bc0beKkthnx|r\n" .. "Website: |cffffd700https://github.com/Kkthnx-Wow/TrialHelper|r")
	info:SetJustifyH("LEFT")
	info:SetJustifyV("TOP")
	info:SetWordWrap(true)
end

-- Register the About Section
Module.settingsChildren = Module.settingsChildren or {}
table.insert(Module.settingsChildren, {
	name = "About",
	callback = CreateAboutSection,
})
