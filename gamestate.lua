local gamestate = {}

gamestate.points = 0
gamestate.pointsDisplay = display.newText( "0", display.contentWidth - 50, 50, "Helvetica", 32 )

function gamestate:addScore()
    gamestate.points = gamestate.points + 1
    gamestate.pointsDisplay.text = "" .. gamestate.points
end

return gamestate