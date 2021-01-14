--[[----------------------------------------------------------------------------

DrpUploadTask.lua
Upload images to Dark Rush Photography

------------------------------------------------------------------------------]]	

local LrPathUtils = import 'LrPathUtils'
local LrFileUtils = import 'LrFileUtils'
local LrDialogs = import 'LrDialogs'

DrpUploadTask = {}

function DrpUploadTask.processRenderedPhotos( functionContext, exportContext )
	
	local exportSession = exportContext.exportSession

	local exportSettings = assert( exportContext.propertyTable )
	
	local numberOfImages = exportSession:countRenditions()
	local progressScope = exportContext:configureProgress {
						title = numberOfImages > 1
									and LOC( "$$$/DarkRushPhotography/Publish/Progress=Publishing ^1 images to Dark Rush Photography", numberOfImages )
									or LOC "$$$/DarkRushPhotography/Publish/Progress/One=Publishing one image to Dark Rush Photography",
					}

	local failures = {}

	for _, rendition in exportContext:renditions{ stopIfCanceled = true } do
	
		-- Wait for next photo to render.

		local success, pathOrMessage = rendition:waitForRender()
		
		-- Check for cancellation again after photo has been rendered.
		
		if progressScope:isCanceled() then break end
		
		if success then

			local filename = LrPathUtils.leafName( pathOrMessage )
			
			--local success = ftpInstance:putFile( pathOrMessage, filename )
			
			if not success then
			
				-- If we can't upload that file, log it.  For example, maybe user has exceeded disk
				-- quota, or the file already exists and we don't have permission to overwrite, or
				-- we don't have permission to write to that directory, etc....
				
				table.insert( failures, filename )
			end
					
			-- When done with photo, delete temp file. There is a cleanup step that happens later,
			-- but this will help manage space in the event of a large upload.
			
			--LrFileUtils.delete( pathOrMessage )
					
		end
		
	end

	if #failures > 0 then
		local message
		if #failures == 1 then
			message = LOC "$$$/FtpUpload/Upload/Errors/OneFileFailed=1 file failed to upload correctly."
		else
			message = LOC ( "$$$/FtpUpload/Upload/Errors/SomeFileFailed=^1 files failed to upload correctly.", #failures )
		end
		LrDialogs.message( message, table.concat( failures, "\n" ) )
	end

	progressScope:done()
	
end
