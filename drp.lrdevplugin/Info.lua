--[[----------------------------------------------------------------------------

Info.lua
Summary information for Dark Rush Photography plugin

------------------------------------------------------------------------------]]

return {
	
	LrSdkVersion = 3.0,
	LrSdkMinimumVersion = 3.0, -- minimum SDK version required by this plug-in

	LrToolkitIdentifier = 'com.darkrushphotography.plugin',
	LrPluginName = LOC "$$$/DarkRushPhotography/PluginName=Dark Rush Photography",

	LrExportServiceProvider = {
		title = "DRP",
		file = 'DrpExportServiceProvider.lua',
	},
	
	VERSION = { major=1, minor=25, revision=0 },
	
}
