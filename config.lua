--[[
if ( display.pixelHeight / display.pixelWidth > 1.72 ) then
	application =
	{
		content =
		{
			width = 540,
			height = 960,
			scale = "letterbox",
			xAlign = "left",
			yAlign = "top",

		}
	}
else
--]]
-- scale everything to width ratio
local scaleFactor = display.pixelWidth / 640

	application =
	{
		content =
		{
			width = display.pixelWidth/scaleFactor,
			height = display.pixelHeight/scaleFactor,
			scale = "zoomStretch",
			xAlign = "left",
			yAlign = "top",

		}
	}