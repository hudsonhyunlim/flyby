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
	application =
	{
		content =
		{
			width = 640,
			height = 960,
			scale = "letterbox",
			xAlign = "left",
			yAlign = "top",

		}
	}
end