hl.monitor({
	output = "DP-1",
	mode = "1920x1080@180",
	position = "0x0",
	scale = "auto",
})

hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080@60",
	position = "1920x0",
	scale = "auto",
})

-- This is a just in case, you might wanna keep this in
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})