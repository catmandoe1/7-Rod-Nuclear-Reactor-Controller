local MAXVOL = 175

function onTick()
	brPressure = input.getNumber(16)
	brTemp = input.getNumber(17)
	brVolume = input.getNumber(18)
	volumePercent = (brVolume / MAXVOL) * 100
	pressurePercent = (brPressure / 10) * 100
	ratio = volumePercent / 100
	boxSize = 55 * ratio
	ratio2 = pressurePercent / 100
	boxSize2 = 55 * ratio2
end

function onDraw()
	width = screen.getWidth()
	height = screen.getHeight()
	--background
	screen.setColor(16, 16, 16)
	screen.drawRectF(0, 0, width, height)
	screen.setColor(102, 102, 102)
	--volume
	screen.drawText(2, 1, "boiler water vol:")
	screen.setColor(51, 153, 255)
	screen.drawRectF(2, 7, boxSize, 8)
	screen.setColor(8, 8, 8)
	screen.drawRect(2, 7, 55, 8)
	screen.setColor(0, 0, 0)
	screen.drawText(4, 9, string.format("%.1f", volumePercent) .. "%")
	--pressure
	screen.setColor(102, 102, 102)
	screen.drawText(2, 17, "boiler pressure:")
	if brPressure > 9 then
		screen.setColor(204, 0, 0)
	else
		screen.setColor(0, 26, 15)
	end
	screen.drawRectF(2, 23, boxSize2, 8)
	screen.setColor(8, 8, 8)
	screen.drawRect(2, 23, 55, 8)
	screen.setColor(0, 0, 0)
	screen.drawText(4, 25, string.format("%.1f", pressurePercent) .. "%")
end