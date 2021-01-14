--[[----------------------------------------------------------------------------

DrpUploadAPI.lua
Common code to initiate Dark Rush Photography Upload API requests

------------------------------------------------------------------------------]]

local LrDate = import 'LrDate'
local LrErrors = import 'LrErrors'
local LrHttp = import 'LrHttp'
local LrPathUtils = import 'LrPathUtils'

local logger = import 'LrLogger'( 'DrpAPI' )

DrpUploadAPI = {}

local function formatError( nativeErrorCode )
    return LOC "$$$/Flickr/Error/NetworkFailure=Could not contact the Flickr web service. Please check your Internet connection."
end

function DrpAPI.callRestMethod( propertyTable, params )

    -- Automatically add API key.
    
    local apiKey = DrpAPI.getApiKeyAndSecret()
    
    if not params.api_key then
        params.api_key = apiKey
    end
    
    -- Remove any special values from params.

    local suppressError = params.suppressError
    local suppressErrorCodes = params.suppressErrorCodes
    local skipAuthToken = params.skipAuthToken

    params.suppressError = nil
    params.suppressErrorCodes = nil
    params.skipAuthToken = nil
    
    -- Build up the URL for this function.
    
    if not skipAuthToken and propertyTable then
        params.auth_token = params.auth_token or propertyTable.auth_token
    end
    
    params.api_sig = DrpAPI.makeApiSignature( params )
    local url = string.format( 'http://www.flickr.com/services/rest/?method=%s', assert( params.method ) )
    
    for name, value in pairs( params ) do

        if name ~= 'method' and value then  -- the 'and value' clause allows us to ignore false

            -- URL encode each of the params.

            local gsubString = '([^0-9A-Za-z])'
            
            value = tostring( value )
            
            -- 'tag_id' contains '-' symbol.
            
            if name ~= 'tag_id' then
                value = string.gsub( value, gsubString, function( c ) return string.format( '%%%02X', string.byte( c ) ) end )
            end
            
            value = string.gsub( value, ' ', '+' )
            params[ name ] = value

            url = string.format( '%s&%s=%s', url, name, value )

        end

    end

    -- Call the URL and wait for response.

    logger:info( 'calling Flickr API via URL:', url )

    local response, hdrs = LrHttp.get( url )
    
    logger:info( 'Flickr response:', response )

    if not response then

        if suppressError then

            return { stat = "noresponse" }

        else
        
            if hdrs and hdrs.error then
                LrErrors.throwUserError( formatError( hdrs.error.nativeCode ) )
            end
            
        end

    end
    
    -- Mac has different implementation with that on Windows when the server refuses the request.
    
    if hdrs.status ~= 200 then
        LrErrors.throwUserError( formatError( hdrs.status ) )
    end

    -- All responses are XML. Parse it now.

    --local simpleXml = xmlElementToSimpleTable( response )

    -- if suppressErrorCodes then

    --    local errorCode = simpleXml and simpleXml.err and tonumber( simpleXml.err.code )
        --   if errorCode and suppressErrorCodes[ errorCode ] then
        --      suppressError = true
        --  end

    --end

    --if simpleXml.stat == 'ok' or suppressError then

        -- logger:info( 'Flickr API returned status ' .. simpleXml.stat )
        --return simpleXml, response
    
    --else

        -- logger:warn( 'Flickr API returned error', simpleXml.err and simpleXml.err.msg )

        -- LrErrors.throwUserError( LOC( "$$$/Flickr/Error/API=Flickr API returned an error message (function ^1, message ^2)",
        --                     tostring( params.method ),
        --                     tostring( simpleXml.err and simpleXml.err.msg ) ) )

    -- end

end

function DrpAPI.uploadPhoto( propertyTable, params )

    -- Prepare to upload.
    
    assert( type( params ) == 'table', 'DrpAPI.uploadPhoto: params must be a table' )
    
    local postUrl = params.photo_id and 'http://flickr.com/services/replace/' or 'http://flickr.com/services/upload/'
    local originalParams = params.photo_id and table.shallowcopy( params )

    logger:info( 'uploading photo', params.filePath )

    local filePath = assert( params.filePath )
    params.filePath = nil
    
    local fileName = LrPathUtils.leafName( filePath )
    
    params.auth_token = params.auth_token or propertyTable.auth_token
    
    params.tags = string.gsub( params.tags, ",", " " )
    
    params.api_sig = DrpAPI.makeApiSignature( params )
    
    local mimeChunks = {}
    
    for argName, argValue in pairs( params ) do
        if argName ~= 'api_sig' then
            mimeChunks[ #mimeChunks + 1 ] = { name = argName, value = argValue }
        end
    end

    mimeChunks[ #mimeChunks + 1 ] = { name = 'api_sig', value = params.api_sig }
    mimeChunks[ #mimeChunks + 1 ] = { name = 'photo', fileName = fileName, filePath = filePath, contentType = 'application/octet-stream' }
    
    -- Post it and wait for confirmation.
    
    local result, hdrs = LrHttp.postMultipart( postUrl, mimeChunks )
    
    if not result then
    
        if hdrs and hdrs.error then
            LrErrors.throwUserError( formatError( hdrs.error.nativeCode ) )
        end
        
    end
    
    -- Parse Flickr response for photo ID.

    local simpleXml = xmlElementToSimpleTable( result )
    if simpleXml.stat == 'ok' then

        return simpleXml.photoid._value
    
    elseif params.photo_id and simpleXml.err and tonumber( simpleXml.err.code ) == 7 then
    
        -- Photo is missing. Most likely, the user deleted it outside of Lightroom. Just repost it.
        
        originalParams.photo_id = nil
        return DrpAPI.uploadPhoto( propertyTable, originalParams )
    
    else

        LrErrors.throwUserError( LOC( "$$$/Flickr/Error/API/Upload=Flickr API returned an error message (function upload, message ^1)",
                            tostring( simpleXml.err and simpleXml.err.msg ) ) )

    end

end

