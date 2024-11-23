local _, Settings = ...

Settings:RegisterSettings("TrialHelperDB", {
	{
		key = "enableTrialHelper",
		type = "toggle",
		title = "Enable Trial Helper",
		tooltip = "Toggle to enable or disable the Trial Helper addon functionality.",
		default = true,
	},
	{
		key = "toggleMailIcon",
		type = "toggle",
		title = "Show Mail Icon",
		tooltip = "Toggle to show or hide the mail icon in the Trial Helper addon.",
		default = false,
	},
	{
		key = "showLoginMessage",
		type = "toggle",
		title = "Show Login Message",
		tooltip = "Toggle to show or hide the welcome login message in the Trial Helper addon.",
		default = true,
	},
})

Settings:RegisterSettingsSlash("/th")

function Settings:OnLoad()
	if not TrialHelperDB then
		-- set default
		TrialHelperDB = CopyTable(TrialHelperDB)
	end
end
