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
    local publishedCollectionParentParent = nil
    if publishedCollectionParent ~= nil then
        publishedCollectionParentParent = publishedCollectionParent:getParent()
    end
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
                
                local publishServiceName = publishService:getName()
                local publishedCollectionParentParentName = nil
                if publishedCollectionParentParent ~= nil then
                    publishedCollectionParentParentName = publishedCollectionParentParent:getName()
                end   
                local publishedCollectionParentName = nil
                if publishedCollectionParent ~= nil then
                    publishedCollectionParentName = publishedCollectionParent:getName()
                end
                local publishedCollectionName = publishedCollection:getName()  

                local imageUrl = DrpAPI.uploadImage(exportSettings, {
                    filePath = pathOrMessage,
                    publishServiceName = publishServiceName,
                    publichedCollectionParentParentName = publishedCollectionParentParentName,
                    publishedCollectionParentName = publishedCollectionParentName,
                    publishedCollectionName = publishedCollectionName
                })
                rendition:recordPublishedPhotoId(imageUrl)

                -- When done with image, delete temp file. There is a cleanup step that happens later,
                -- but this will help manage space in the event of a large upload.
                LrFileUtils.delete(pathOrMessage)

            end
        end
    end

end
