--[[----------------------------------------------------------------------------

DrpAPI.lua
Common code to initiate Dark Rush Photography Upload API requests

------------------------------------------------------------------------------]]
local LrErrors = import 'LrErrors'
local LrHttp = import 'LrHttp'
local LrPathUtils = import 'LrPathUtils'

local logger = import 'LrLogger'('DrpAPI')

DrpAPI = {}

function DrpAPI.isUploadImageConnectionValid(propertyTable)

    local uploadImageUrl = propertyTable.drpApiBaseUrl .. 'UploadImageFunction'
    local headers = {{
        field = 'x-functions-key',
        value = propertyTable.drpApiFunctionKey
    }}

    local secondsToWait = 3
    local response, hdrs = LrHttp.get(uploadImageUrl, headers, secondsToWait)
    if hdrs and hdrs.status == 200 then
        return true
    end

    return false

end

function DrpAPI.uploadImage(propertyTable, params)

    assert(type(params) == 'table', 'DrpAPI.uploadImage: params must be a table')

    local filePath = assert(params.filePath)
    params.filePath = nil

    local publishServiceName = params.publishServiceName
    local publishedCollectionParentParentName = params.publishedCollectionParentParentName
    local publishedCollectionParentName = params.publishedCollectionParentName
    local publishedCollectionName = params.publishedCollectionName

    local leafName = LrPathUtils.leafName(filePath)
    local fileName = nil
    if publishedCollectionParentParentName ~= nil then
        fileName = publishServiceName .. "|&|" .. publishedCollectionParentParentName .. "|&|" ..
                       publishedCollectionParentName .. "|&|" .. publishedCollectionName .. "|&|" .. leafName
    elseif publishedCollectionParentName ~= nil then
        fileName = publishServiceName .. "|&|" .. publishedCollectionParentName .. "|&|" .. publishedCollectionName ..
                       "|&|" .. leafName
    else
        fileName = publishServiceName .. "|&|" .. publishedCollectionName .. "|&|" .. leafName
    end

    local uploadImageUrl = propertyTable.drpApiBaseUrl .. 'UploadImageFunction'

    local mimeChunks = {}
    mimeChunks[#mimeChunks + 1] = {
        name = 'image',
        fileName = fileName,
        filePath = filePath,
        contentType = 'application/octet-stream'
    }

    local headers = {{
        field = 'x-functions-key',
        value = propertyTable.drpApiFunctionKey
    }}

    local result, hdrs = LrHttp.postMultipart(uploadImageUrl, mimeChunks, headers)
    if hdrs and hdrs.status == 200 then
        return result:gsub('"', "")
    else
        LrErrors.throwUserError(
            LOC '$$$/DarkRushPhotography/Error/NetworkFailure=Could not connect to Dark Rush Photography^R API. Please check your Internet connection.')
    end

end
