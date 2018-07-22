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
local ballScreenText

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function toMenu()
	composer.gotoScene( "mainmenu", "fade", 100 )
end

local function push(event)
	--xVel = 3*(body.getCenterX() - click.x)/body.getWidth();
	
	local xVel = 500*(ball.x - event.x)/ball.width
	ball:setLinearVelocity(xVel,-300)
end

local function scroll(event)
	local vx, vy = ball:getLinearVelocity()
	if (vy < 0) then
		bg.y = bg.y - vy/180
		rightWall.y = rightWall.y - vy/180
		leftWall.y = leftWall.y - vy/180
		ground.y = ground.y - vy/180
	end
end

local function isBallOffScreen()
	local left = 0-(display.actualContentWidth - display.contentWidth)/2
	local top = 0-(display.actualContentHeight - display.contentHeight)/2
	local right = display.contentWidth + (display.actualContentWidth - display.contentWidth)/2
	local bottom = display.contentHeight + (display.actualContentHeight - display.contentHeight)/2

	local maxRadius = (ball.contentWidth > ball.contentHeight) and ball.contentWidth or ball.contentHeight
	maxRadius = (maxRadius / 2) * math.sqrt(2)
	maxRadius = math.floor( (maxRadius * 10^2) + 0.5) / (10^2)
	if( (ball.x - maxRadius) > right ) then return true end
	if( (ball.x + maxRadius) < left) then return true end
	if( (ball.y + maxRadius) < top ) then return true end
	if( (ball.y - maxRadius) > bottom ) then return true end
	return false
	
end

local function setOffScreenText(event)
	ballScreenText.text = "Ball Off Screen: " .. tostring(isBallOffScreen())
end
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
	
	bg = display.newImageRect("images/background_1.png",display.actualContentWidth, display.actualContentHeight * 10)
	bg.x = display.actualContentWidth/2
	bg.y = display.actualContentHeight - (bg.height/2)
	sceneGroup:insert(bg)
	
	leftWall = display.newRect(0,display.actualContentHeight/2,display.actualContentHeight/30,display.actualContentHeight *2)
	leftWall.strokeWidth = 0
	leftWall:setFillColor(0.5)
	sceneGroup:insert(leftWall)
	
	rightWall = display.newRect(display.actualContentWidth,display.actualContentHeight/2,display.actualContentHeight/30,display.actualContentHeight*2)
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
	
	ballScreenText = display.newText("Ball Off Screen: " .. tostring(isBallOffScreen()), display.contentCenterX, display.actualContentHeight-(display.actualContentHeight/4), "Arial", 20)
	ballScreenText:setFillColor(1,1,0)
	sceneGroup:insert(ballScreenText)
	
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
	Runtime:addEventListener("enterFrame", scroll)
	Runtime:addEventListener("enterFrame", setOffScreenText)
	
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
		
		bg.y = display.actualContentHeight - (bg.height/2)
		ground.y = display.actualContentHeight - (ground.height/2)
		leftWall.y = display.actualContentHeight/2 - ground.height
		rightWall.y = display.actualContentHeight/2 - ground.height
		
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
		Runtime:addEventListener("enterFrame", scroll)
		physics.start()
    end
end

 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
		Runtime:removeEventListener("enterFrame", scroll)	
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener("enterFrame", scroll)	
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
	Runtime:removeEventListener("enterFrame", scroll)
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