local composer = require( "composer" )

local scene = composer.newScene()

local widget = require("widget")
widget.setTheme( "widget_theme_android_holo_light" )
local audio = require("audio")
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local bg
local curScene
local playBtn
local optionsBtn
local backgroundMusic = audio.loadStream("sounds/backgroundmusic_1.mp3")
local backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1, fadein=5000 } )
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- Sends player to game
function toGame()
	composer.gotoScene( "play", "fade", 100 )
end

--Sends player to options menu
function toOptions()
	composer.gotoScene("options", "fade", 100)
end

-- create()
function scene:create( event )

    local sceneGroup = self.view

	--This is the scrolling background image
	bg = display.newImageRect("images/background_1.png",display.actualContentWidth, display.actualContentHeight * 5)
	bg.x = display.actualContentWidth/2
	bg.y = display.actualContentHeight - (bg.height/2)
	sceneGroup:insert(bg)


	-- Lets us know of the current scene
	curScene = display.newText("Scene: Main Menu", display.contentCenterX, display.actualContentHeight-(display.actualContentHeight/5), "Arial", 20)
	curScene:setFillColor(1,1,0)
	sceneGroup:insert(curScene)

	-- Creates play button
	playBtn = widget.newButton({label="Play"})
	playBtn.x = display.actualContentWidth/2
	playBtn.y = display.actualContentHeight/3
	sceneGroup:insert(playBtn)

	-- Adds event listener to play button
	playBtn:addEventListener("tap", toGame)

	-- Creates options button
	optionsBtn = widget.newButton({label="Options"})
	optionsBtn.x = display.actualContentWidth/2
	optionsBtn.y = display.actualContentHeight*7/16
	sceneGroup:insert(optionsBtn)

	-- Adds even listener to options button
	optionsBtn:addEventListener("tap", toOptions)

end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end


-- destroy()
function scene:destroy( event )
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
	if optionsBtn then
		optionsBtn:removeSelf()	-- widgets must be manually removed
		optionsBtn = nil
	end
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
