local GCOLOUR = 102
local FCOLOUR = 204
local TEMP = 400
local touchPushed = false
local stReactor = false
local startCounter = 0
local startedReactor = false
local rodCounter = 0
local startingState = false
local start = false
local rodCounter2 = 0
local startingState2 = false
local rodCounter3 = 0
local startingState3 = false
local shutdown = false
local shutdownCounter = 0
local finShutdown = true


function onTick()
	touchX = input.getNumber(3)
	touchY = input.getNumber(4)
	isPressed = input.getBool(1)
	rod1 = input.getNumber(7)
	rod2 = input.getNumber(8)
	rod3 = input.getNumber(9)
	rod4 = input.getNumber(10)
	rod5 = input.getNumber(11)
	rod6 = input.getNumber(12)
	rod7 = input.getNumber(13)
	clRod1 = input.getNumber(14)
	clRod2 = input.getNumber(15)
	surTemp = input.getNumber(27) --surrounding temperature around the reactor

	if isPressed then
		if not touchPushed and not startedReactor then
			touchPushed = true
			if touchScreen(touchX, touchY, 97, 4, 61, 16) then
				stReactor =	 not stReactor
				startedReactor = true
				startCounter = 0
			end
		end
	else
		touchPushed = false
	end

	if startedReactor then
		startCounter = startCounter + 1
		if startCounter >= 60 * 7 then
			startCounter = 0
			startedReactor = false
		end
	end

	if stReactor then
		output.setBool(1, false)
		output.setNumber(1, 0.25)
		start = true
	else
		output.setBool(1, true)
		output.setNumber(1, -0.25)
		start = false
	end
	if rod1 < 180 then
		if start then
			output.setBool(2, true)
			rodCounter2 = rodCounter2 + 1
			if rodCounter2 == 60 then
				rodCounter2 = 0
				startingState2 = not startingState2
			end
		else
			output.setBool(2, false)
			startingState2 = false
			rodCounter2 = 0
		end
	end
	--[[
	if not start and finShutdown then
		shutdownCounter = shutdownCounter + 1
		shutdown = true
		if shutdownCounter == 60 * 2 then
			finShutdown = false
			shutdown = false
			shutdownCounter = 0
		end
	end
	--]]
end

function touchScreen(x, y, rectX, rectY, rectW, rectH)
	return x > rectX and y > rectY and x < rectX+rectW and y < rectY+rectH
end

function drawRod(rod, x, y, radius, max)
	rod = math.floor(rod)
	if rod > max then
		screen.setColor(FCOLOUR, 0, 0)
	elseif rod > 180 and rod <= max - 100 then
		screen.setColor(0, 156, 0)
	else
		screen.setColor(GCOLOUR, GCOLOUR, GCOLOUR)
	end
	screen.drawCircleF(x, y, radius)
	screen.setColor(0, 0, 0)
	screen.drawText(x - 10, y - 2, string.format("%.0f", rod) .. "°C")
end

function drawConRod(rod, x, y, w, h)
	screen.setColor(GCOLOUR, GCOLOUR, GCOLOUR)
	screen.drawRectF(x, y, w, h)
	screen.setColor(0, 0, 0)
	screen.drawText(x + 5, y + 10, string.format("%.0f", (rod * 100)) .. "%")
end

function drawAbly(r1, r2, r3, r4, r5, r6, r7, cr1, cr2)
	drawConRod(cr1, 2, 2, 13 * 2, 13 * 2)
	drawRod(rod1, 24 * 2, 15, 6.75 * 2, TEMP)
	drawRod(rod2, 40 * 2, 15, 6.75 * 2, TEMP)
	drawRod(rod3, 8 * 2, 24 * 2, 6.75 * 2, TEMP)
	drawRod(rod4, 24 * 2, 24 * 2, 6.75 * 2, TEMP)
	drawRod(rod5, 40 * 2, 24 * 2, 6.75 * 2, TEMP)
	drawRod(rod6, 8 * 2, 40 * 2, 6.75 * 2, TEMP)
	drawRod(rod7, 24 * 2, 40 * 2, 6.75 * 2, TEMP)
	drawConRod(cr2, 34 * 2, 34 * 2, 13 * 2, 13 * 2)
end

function onDraw()
	width = screen.getWidth()
	height = screen.getHeight()
	--background
	screen.setColor(16, 16, 16)
	screen.drawRectF(0, 0, width, height)
	screen.setColor(32, 32, 32)
	screen.drawRectF(95, 0, width, height)	
	screen.setColor(8, 8, 8)
	screen.drawLine(95, 0, 95, height)
	--assembly
	drawAbly(rod1, rod2, rod3, rod4, rod5, rod6, rod7, clRod1, clRod2)
	--button
	if stReactor then
		screen.setColor(0, 26, 15)
	else
		screen.setColor(FCOLOUR, 0, 0)
	end
	screen.drawRectF(97, 4, 61, 16)
	screen.setColor(GCOLOUR, GCOLOUR, GCOLOUR)
	screen.drawRect(97, 4, 61, 16)
	if startedReactor then
		rodCounter = rodCounter + 1
		if rodCounter == 60 then
			rodCounter = 0
			startingState = not startingState
		end
		if startingState then
			screen.setColor(0, 0, 0)
			screen.drawText(99, 6, "Working")
		end
	elseif stReactor then
		screen.setColor(16, 16, 16)
		screen.drawText(99, 6, "Shutdown")
		screen.drawText(99, 12, "Reactor")
	else
		screen.setColor(16, 16, 16)
		screen.drawText(99, 6, "Startup")
		screen.drawText(99, 12, "Reactor")
	end
	--temp
	screen.setColor(16, 16, 16)
	screen.drawText(97, 22, "Ambient Temp:")
	screen.drawText(97, 28, string.format("%.1f", surTemp) .. "C")
	--starting info
	if startingState2 and rod1 < 180 then
		screen.setColor(FCOLOUR, 0, 0)
		screen.drawText(97, 34, "starting up")
	end
	--[[
	while shutdown do
		rodCounter3 = rodCounter3 + 1
		if rodCounter3 == 60 then
			rodCounter3 = 0
			startingState3 = not startingState3
		end
	end
	if startingState3 then
		screen.setColor(FCOLOUR, 0, 0)
		screen.drawText(97, 34, "shutting down")
	end
	--]]
end