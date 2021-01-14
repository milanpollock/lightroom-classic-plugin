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
	hideSections = { 'exportLocation' },
	allowFileFormats = nil,
	allowColorSpaces = nil,
	exportPresetFields = {
		{ key = 'drpApiFunctionKey', default = '' }
	},
	getCollectionBehaviorInfo = getCollectionBehaviorInfo,
	sectionsForTopOfDialog = DrpExportDialogSections.sectionsForTopOfDialog,
	processRenderedPhotos = DrpUploadTask.processRenderedPhotos,
}

