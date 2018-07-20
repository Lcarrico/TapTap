local composer = require( "composer" )
 
local scene = composer.newScene()
 
local widget = require("widget")

--Use physics library
local physics = require "physics"


local bg
local curScene
local menuBtn
local ground
local ball
local leftWall
local rightWall

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function toMenu()
	composer.gotoScene( "mainmenu", "fade", 100 )
end

function push(event)
	--xVel = 3*(body.getCenterX() - click.x)/body.getWidth();
	
	local xVel = 500*(ball.x - event.x)/ball.width
	ball:setLinearVelocity(xVel,-300)
end
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
	
	bg = display.newRect(display.contentCenterX,display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
	bg:setFillColor(0.6,0.6,1)
	sceneGroup:insert(bg)
	
	leftWall = display.newRect(0,display.actualContentHeight/2,display.actualContentHeight/30,display.actualContentHeight)
	leftWall.strokeWidth = 0
	leftWall:setFillColor(0.5)
	sceneGroup:insert(leftWall)
	
	rightWall = display.newRect(display.actualContentWidth,display.actualContentHeight/2,display.actualContentHeight/30,display.actualContentHeight)
	rightWall.strokeWidth = 0
	rightWall:setFillColor(0.5)
	sceneGroup:insert(rightWall)
	
	ground = display.newImageRect("images/ground1.png",display.actualContentWidth, display.actualContentHeight/10)
	ground.x = display.actualContentWidth/2
	ground.y = display.actualContentHeight - (ground.height/2)
	sceneGroup:insert(ground)
	
	leftWall.y = display.actualContentHeight/2 - ground.height
	rightWall.y = display.actualContentHeight/2 - ground.height
	
	ball = display.newImage("images/ball1.png")
	ball.width = display.actualContentWidth/6
	ball.height = display.actualContentWidth/6
	ball.x = display.actualContentWidth/2
	ball.y = display.actualContentHeight/2
	ball.radius = 1
	sceneGroup:insert(ball)
	
	curScene = display.newText("Scene: Game", display.contentCenterX, display.actualContentHeight-(display.actualContentHeight/5), "Arial", 20)
	curScene:setFillColor(1,1,0)
	sceneGroup:insert(curScene)
	
	menuBtn = widget.newButton({label="Back to Menu"})
	menuBtn.x = display.actualContentWidth/2
	menuBtn.y = display.actualContentHeight/14
	sceneGroup:insert(menuBtn)
	
	menuBtn:addEventListener("tap", toMenu)
	
	--Game Physics
	physics.start()
	physics.pause()
	
	physics.addBody(ball, {bounce = .3, friction=.5, radius=display.actualContentWidth/6/2})
	physics.addBody(ground, "static")
	physics.addBody(leftWall, "static")
	physics.addBody(rightWall, "static")
	
	ball:addEventListener("tap", push)
	
	--[[
	leftWall.y = leftWall.y + 28
	rightWall.y = rightWall.y + 28
	ground.y = ground.y + 28
	menuBtn.y = menuBtn.y + 40
	]]--
end


-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
		ball.x = display.actualContentWidth/2
		ball.y = display.actualContentHeight/2
		
		physics.start()
		physics.pause()
		
		physics.addBody(ball, {bounce = .3, friction=.5, radius=display.actualContentWidth/6/2})
		physics.addBody(ground, "static")
		physics.addBody(leftWall, "static")
		physics.addBody(rightWall, "static")
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
		
		physics.start()
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
		physics.stop()
    end
end
 
 
-- destroy()
function scene:destroy( event )
	if menuBtn then
		menuBtn:removeSelf()	-- widgets must be manually removed
		menuBtn = nil
	end
	package.loaded[physics] = nil
	physics = nil
	
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