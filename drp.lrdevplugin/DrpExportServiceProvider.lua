--[[----------------------------------------------------------------------------

DrpExportServiceProvider.lua
Export service provider description for Dark Rush Photography Upload

------------------------------------------------------------------------------]]
require 'DrpExportDialogSections'
require 'DrpUploadTask'

local function getCollectionBehaviorInfo(publishSettings)

    return {
        defaultCollectionCanBeDeleted = true,
        canAddCollection = true,
        maxCollectionSetDepth = 1
    }

end

local function startDialog(propertyTable)
    propertyTable.LR_renamingTokensOn = true
    propertyTable.LR_tokens = "{{image_originalName}}"
    propertyTable.LR_jpeg_quality = 1
end

function deletePhotosFromPublishedCollection(publishSettings, arrayOfPhotoIds, deletedCallback)

    for i, photoId in ipairs(arrayOfPhotoIds) do

        deletedCallback(photoId)

    end

end

function deletePublishedCollection( publishSettings, info )

	import 'LrFunctionContext'.callWithContext( 'deletePublishedCollection', function( context )
	end )

end

function metadataThatTriggersRepublish(publishSettings)

    return {
        default = false
    }

end

return {
    small_icon = 'small_drp.png',
    supportsIncrementalPublish = 'only',
    allowFileFormats = {'JPEG'},
    allowColorSpaces = {'sRGB'},
    hideSections = {'exportLocation', 'fileNaming', 'metadata', 'video'},
    canExportVideo = false,
    exportPresetFields = {{
        key = 'drpApiBaseUrl',
        default = 'http://localhost:7071/api/'
    }, {
        key = 'drpApiFunctionKey',
        default = ''
    }},
    getCollectionBehaviorInfo = getCollectionBehaviorInfo,
    startDialog = startDialog,
    deletePhotosFromPublishedCollection = deletePhotosFromPublishedCollection,
    metadataThatTriggersRepublish = metadataThatTriggersRepublish,
    sectionsForTopOfDialog = DrpExportDialogSections.sectionsForTopOfDialog,
    processRenderedPhotos = DrpUploadTask.processRenderedPhotos
}

