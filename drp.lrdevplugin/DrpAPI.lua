--[[----------------------------------------------------------------------------

DrpAPI.lua
Common code to initiate Dark Rush Photography Upload API requests

------------------------------------------------------------------------------]]

local LrDate = import 'LrDate'
local LrErrors = import 'LrErrors'
local LrHttp = import 'LrHttp'
local LrPathUtils = import 'LrPathUtils'

local logger = import 'LrLogger'( 'DrpAPI' )

DrpAPI = {}

local function formatError( nativeErrorCode )
    return LOC "$$$/DarkRushPhotography/Error/NetworkFailure=Could not contact the Dark Rush Photography API. Please check your Internet connection."
end


function DrpAPI.uploadPhoto( propertyTable, params )

	-- Prepare to upload.

	assert( type( params ) == 'table', 'DrpAPI.uploadPhoto: params must be a table' )

    logger:info( 'uploading photo', params.filePath )

    -- params.photo_id is nothing, until it is uploaded 
	--local postUrl = params.photo_id and 'http://flickr.com/services/replace/' or 'http://flickr.com/services/upload/'
	--local originalParams = params.photo_id and table.shallowcopy( params )

    local postUrl = propertyTable.domain .. "UploadImageFunction"

	local filePath = assert( params.filePath )
	params.filePath = nil
	
	local fileName = LrPathUtils.leafName( filePath )
    
    local mimeChunks = {}
    
	mimeChunks[ #mimeChunks + 1 ] = { name = 'photo', fileName = fileName, filePath = filePath, contentType = 'application/octet-stream' }

	local result, hdrs = LrHttp.postMultipart( postUrl, mimeChunks )
	
	if not result then
	
		if hdrs and hdrs.error then
			LrErrors.throwUserError( formatError( hdrs.error.nativeCode ) )
		end
		
    end

    return true

end