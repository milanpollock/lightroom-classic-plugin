--[[----------------------------------------------------------------------------

DrpExportDialogSections.lua
Export dialog sections for Dark Rush Photography

------------------------------------------------------------------------------]]
local LrView = import 'LrView'
local LrDialogs = import 'LrDialogs'
local LrBinding = import 'LrBinding'

require 'DrpAPI'

DrpExportDialogSections = {}

function DrpExportDialogSections.sectionsForTopOfDialog(viewFactory, propertyTable)

    local bind = LrView.bind
    local share = LrView.share
    local keyIsNot = LrBinding.keyIsNot

    return {{
        title = LOC '$$$/DarkRushPhotography/ExportDialog/Title=Dark Rush^R Photography API',
        synopsis = LOC '$$$/DarkRushPhotography/ExportDialog/Synopsis=settings mf',
        viewFactory:column{

            spacing = viewFactory:control_spacing(),
            fill_horizontal = 1,

            viewFactory:row{viewFactory:static_text{
                title = LOC '$$$/DarkRushPhotography/ExportDialog/ApiBaseUrlCaption=API Base Url:',
                alignment = 'right',
                width = share 'labelWidth'
            }, viewFactory:edit_field{
                value = bind 'drpApiBaseUrl',
                immediate = true,
                fill_horizontal = 1
            }},
            viewFactory:row{viewFactory:static_text{
                title = LOC '$$$/DarkRushPhotography/ExportDialog/ApiFunctionKeyCaption=API Function Key:',
                alignment = 'right',
                width = share 'labelWidth'
            }, viewFactory:password_field{
                value = bind 'drpApiFunctionKey',
                immediate = true,
                fill_horizontal = 1
            }, viewFactory:push_button{
                title = LOC '$$$/DarkRushPhotography/ExportDialog/ButtonTitle=Verify',
                width = 150,
                action = function()

                    import"LrTasks".startAsyncTask(function()
                        local verifyUpload = DrpAPI.isUploadImageConnectionValid(propertyTable)
                        if verifyUpload then
                            LrDialogs.message(
                                LOC '$$$/DarkRushPhotography/ExportDialog/ApiSettingsValid=API Settings Valid')
                        else
                            LrDialogs.message(
                                LOC '$$$/DarkRushPhotography/ExportDialog/ApiSettingsNotValid=API Settings Not Valid')
                        end
                    end)
                end
            }}
        }
    }}

end
