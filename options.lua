local composer = require( "composer" )
 
local scene = composer.newScene()
 
local widget = require("widget")
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local bg
local curScene
local menuBtn

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function toMenu()
	composer.gotoScene( "mainmenu", "fade", 100 )
end
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
	bg = display.newRect(display.contentCenterX,display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
	bg:setFillColor(0.6,0.6,1)
	sceneGroup:insert(bg)
	
	curScene = display.newText("Scene: Options", display.contentCenterX, display.actualContentHeight-(display.actualContentHeight/5), "Arial", 20)
	curScene:setFillColor(1,1,0)
	sceneGroup:insert(curScene)
	
	menuBtn = widget.newButton({label="Back to Menu"})
	menuBtn.x = display.actualContentWidth/2
	menuBtn.y = display.actualContentHeight/3
	sceneGroup:insert(menuBtn)
	
	menuBtn:addEventListener("tap", toMenu)
	
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
	if menuBtn then
		menuBtn:removeSelf()	-- widgets must be manually removed
		menuBtn = nil
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