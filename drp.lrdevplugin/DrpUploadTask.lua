--[[----------------------------------------------------------------------------

DrpUploadTask.lua
Upload images to Dark Rush Photography

------------------------------------------------------------------------------]]
local LrPathUtils = import 'LrPathUtils'
local LrFileUtils = import 'LrFileUtils'
local LrDialogs = import 'LrDialogs'

require 'DrpAPI'

DrpUploadTask = {}

function DrpUploadTask.processRenderedPhotos(functionContext, exportContext)

    local exportSession = exportContext.exportSession

    local exportSettings = assert(exportContext.propertyTable)

    local numberOfImages = exportSession:countRenditions()
    local progressScope = exportContext:configureProgress{
        title = numberOfImages > 1 and
            LOC('$$$/DarkRushPhotography/Upload/Progress=Publishing ^1 images to Dark Rush Photography.', numberOfImages) or
            LOC '$$$/DarkRushPhotography/Upload/Progress/One=Publishing one image to Dark Rush Photography.'
    }

    local publishedCollection = exportContext.publishedCollection
    local publishedCollectionParent = publishedCollection:getParent()
    local publishService = publishedCollection:getService()

    for i, rendition in exportContext:renditions{
        stopIfCanceled = true
    } do

        progressScope:setPortionComplete((i - 1) / numberOfImages)

        local image = rendition.photo

        if rendition.wasSkipped then

            -- To get the skipped photo out of the to-republish bin.
            rendition:recordPublishedPhotoId(rendition.publishedPhotoId)

        else

            local success, pathOrMessage = rendition:waitForRender()

            if progressScope:isCanceled() then
                break
            end

            if success then

                local filename = LrPathUtils.leafName(pathOrMessage)

                local publishServiceName = publishService:getName()
                local publishedCollectionName = publishedCollection:getName()  
                local publishedCollectionParentName = nil
                if publishedCollectionParent ~= nil then
                    publishedCollectionParentName = publishedCollectionParent:getName()
                end
                local imageUrl = DrpAPI.uploadImage(exportSettings, {
                    filePath = pathOrMessage,
                    publishServiceName = publishServiceName,
                    publishedCollectionName = publishedCollectionName,   
                    publishedCollectionParentName = publishedCollectionParentName
                })
                rendition:recordPublishedPhotoId(imageUrl)

                -- When done with image, delete temp file. There is a cleanup step that happens later,
                -- but this will help manage space in the event of a large upload.
                LrFileUtils.delete(pathOrMessage)

            end
        end
    end

end
