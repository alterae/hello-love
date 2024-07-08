local graphics = love.graphics
local timer = love.timer

local log = require "lib.log"
local screen = require "lib.screen"

local player

function love.load()
	if love.filesystem.isFused() then
		log.level = log.Level.INFO
	else
		log.level = log.Level.DEBUG
	end

	screen:init()

	local font = graphics.newFont("res/fonts/cozette.otf", 13)
	graphics.setFont(font)

	player = graphics.newImage "res/sprites/player.png"
end

---@param dt number
function love.update(dt) end

---@param dt number
function love.draw(dt)
	screen:begin()

	graphics.setColor(0.25, 0.25, 0.25)
	graphics.rectangle("fill", 0, 0, screen.rect.width, screen.rect.height)
	graphics.setColor(1, 1, 1)
	graphics.print(" Hello, LÖVE!", 10, 10)
	graphics.print("Fps: " .. timer.getFPS(), 10, 26)

	graphics.draw(player, screen.rect.width / 2 - 8, screen.rect.height / 2 - 8)

	screen:finish()
end
