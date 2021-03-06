-- Requirements
local composer = require "composer"
local libworld = require "scene.game.lib.world"
local ponytiled = require "com.ponywolf.ponytiled"
local snap = require "com.ponywolf.snap"
local json = require "json"

-- Variables local to scene
local scene = composer.newScene()
local world, hud, map

function scene:create( event )
  local view = self.view -- add display objects to this group
  
	display.setDefault("background", 0.2,0.2,0.2)
	
  -- load sounds
  self.sounds = require "scene.game.sounds"
  
  -- create an empty world
  world = libworld.new(2)
  world:center()
  view:insert(world)
	
	local rect = display.newRect(world , 0, 0, 128, 128)
	rect.strokeWidth = 8
	rect:setFillColor(0,0,0,0)
	transition.to(rect, { time = 5000, rotation = -360, iterations = -1 })
	
  local circle = display.newCircle(world, -250, 0, 64)
	transition.to(circle, { time = 5000, x=250, iterations = -1, transition = easing.inOutQuad })
  
  -- or load a tiled map
--  local filename = system.pathForFile("scene/game/map/test.json")
--  local data = json.decodeFile(filename)
--  map = ponytiled.new(data, "scene/game/map")
--  map:centerObject("testobject")
--	view:insert(map)
	
  -- create an HUD group
  hud = display.newGroup()
	scene.score = display.newText{ parent=hud, text = "HUD Group", font = "scene/game/font/RobotoMono.ttf", fontSize = "32" }
  snap(scene.score, "topcenter", 16)
	view:insert(hud)

end

local function enterFrame(event)
  local elapsed = event.time

end

local function key(event)
  local phase, name = event.phase, event.keyName
  print(phase, name)
end

function scene:show( event )
  local phase = event.phase
  if ( phase == "will" ) then
    Runtime:addEventListener("enterFrame", enterFrame)
  elseif ( phase == "did" ) then
    Runtime:addEventListener( "key", key )
  end
end

function scene:hide( event )
  local phase = event.phase
  if ( phase == "will" ) then
    Runtime:removeEventListener( "key", key )
  elseif ( phase == "did" ) then
    Runtime:removeEventListener("enterFrame", enterFrame)
  end
end

function scene:destroy( event )
	audio.stop()
	for s,v in pairs( self.sounds ) do
		audio.dispose( v )
		self.sounds[s] = nil
	end
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene