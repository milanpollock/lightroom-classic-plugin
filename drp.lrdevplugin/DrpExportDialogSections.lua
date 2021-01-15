--[[----------------------------------------------------------------------------

DrpExportDialogSections.lua
Export dialog sections for Dark Rush Photography

------------------------------------------------------------------------------]]

local LrView = import 'LrView'
local LrDialogs = import 'LrDialogs'
local LrBinding = import 'LrBinding'

DrpExportDialogSections = {}

function DrpExportDialogSections.sectionsForTopOfDialog( viewFactory, propertyTable )

	local bind = LrView.bind
	local share = LrView.share
	local keyIsNot = LrBinding.keyIsNot

	return {
		{
			title = LOC "$$$/DarkRushPhotography/ExportDialog/Title=Dark Rush Photography API",
			synopsis = LOC "$$$/DarkRushPhotography/ExportDialog/Synopsis=API Settings",
			viewFactory:column {

				spacing = viewFactory:control_spacing(),
				fill_horizontal = 1,
				
				viewFactory:row { 
					viewFactory:static_text {
						title = LOC "$$$/DarkRushPhotography/ExportDialog/ApiDomainCaption=API Domain:",
						alignment = 'right',
						width = share 'labelWidth'
					},

					viewFactory:edit_field {
						value = bind 'drpApiDomain',
						immediate = true,
						fill_horizontal = 1,
					},
				},
				viewFactory:row { 
					viewFactory:static_text {
						title = LOC "$$$/DarkRushPhotography/ExportDialog/ApiFunctionKeyCaption=API Function Key:",
						alignment = 'right',
						width = share 'labelWidth'
					},

					viewFactory:password_field {
						value = bind 'drpApiFunctionKey',
						immediate = true,
						fill_horizontal = 1,
					},

					viewFactory:push_button {
						title = LOC "$$$/DarkRushPhotography/ExportDialog/ButtonTitle=Verify",
						width = 150,
						enabled = keyIsNot('drpApiDomain', '') and keyIsNot('drpApiFunctionKey', ''),
						action = function()
							LrDialogs.message(propertyTable.drpApiFunctionKey) -- TODO: Call the rest service!!!
						end,
					},
				}
			},
		},
	}

end