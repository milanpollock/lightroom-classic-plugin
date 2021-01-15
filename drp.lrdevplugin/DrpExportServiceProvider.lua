--[[----------------------------------------------------------------------------

DrpExportServiceProvider.lua
Export service provider description for Dark Rush Photography Upload

------------------------------------------------------------------------------]]

require "DrpExportDialogSections"
require "DrpUploadTask"

local function getCollectionBehaviorInfo( publishSettings )

	return {
		defaultCollectionCanBeDeleted = true,
		canAddCollection = true,
		maxCollectionSetDepth = 0,
			-- Collection sets are not supported through the Dark Rush Photography plugin.
	}
	
end

return {
	small_icon = 'small_drp.png',
	supportsIncrementalPublish = 'only',
	hideSections = { 'exportLocation', 'video' },
	allowFileFormats = nil,
	allowColorSpaces = nil,
	canExportVideo = false, 
	exportPresetFields = {
		{ key = 'drpApiDomain', default = 'http://localhost:7071/api/' },
		{ key = 'drpApiFunctionKey', default = '' },
	},
	getCollectionBehaviorInfo = getCollectionBehaviorInfo,
	sectionsForTopOfDialog = DrpExportDialogSections.sectionsForTopOfDialog,
	processRenderedPhotos = DrpUploadTask.processRenderedPhotos,
}

