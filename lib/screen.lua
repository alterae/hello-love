--[[
	screen.lua
	A pixel-perfect screen management library for LÖVE.

	zlib License

	(C) 2024 alterae

	This software is provided 'as-is', without any express or implied
	warranty.  In no event will the authors be held liable for any damages
	arising from the use of this software.

	Permission is granted to anyone to use this software for any purpose,
	including commercial applications, and to alter it and redistribute it
	freely, subject to the following restrictions:

	1. The origin of this software must not be misrepresented; you must not
	   claim that you wrote the original software. If you use this software
	   in a product, an acknowledgment in the product documentation would be
	   appreciated but is not required.
	2. Altered source versions must be plainly marked as such, and must not be
	   misrepresented as being the original software.
	3. This notice may not be removed or altered from any source distribution.
]]

local graphics = love.graphics
local window = love.window

local log = require "lib.log"

---Pixel-perfect screen-management library.
---@class (exact) screen
---@field canvas love.Canvas
---@field scale integer
---@field rect screen.Rect
---@field window screen.Rect
local screen = {
	---Scaling factor in real pixels per scaled pixel.
	scale = 1,

	---The "safe area" for drawing.
	rect = {
		---X coordinate of the drawing origin, in scaled pixels. Should always
		---equal 0.
		x = 0,
		---Y coordinate of the drawing origin, in scaled pixels. Should always
		---equal 0.
		y = 0,
		---Width of the "safe area", in scaled pixels.
		width = 0,
		---Height of the "safe area", in scaled pixels.
		height = 0,
	},

	---The actual game window.
	window = {
		---X coordinate of the game window origin, in scaled pixels.
		x = 0,
		---Y coordinate of the game window origin, in scaled pixels.
		y = 0,
		---Width of the game window, in scaled pixels.
		width = 0,
		---Height of the game window, in scaled pixels.
		height = 0,
	},
}

---Integer rectangle type.
---@class (exact) screen.Rect
---@field x integer
---@field y integer
---@field width integer
---@field height integer

---Initializes the screen canvas to the `minwidth` and `minheight` specified in
---`conf`.
function screen:init()
	local _, _, flags = window.getMode()
	local width, height = flags.minwidth, flags.minheight

	log.info(
		"Initializing screen canvas with dimensions %dx%d...",
		width,
		height
	)

	graphics.setDefaultFilter "nearest"
	graphics.setLineStyle "rough"

	self.rect.width = width
	self.rect.height = height
	self:resize(graphics.getDimensions())
end

---Begin pixel-perfect drawing.
function screen:begin()
	graphics.push "all"

	graphics.setBlendMode "alpha"
	graphics.setColor(1, 1, 1)
	graphics.setCanvas(self.canvas)
	graphics.clear()

	graphics.translate(-self.window.x, -self.window.y)
end

---Finish pixel-perfect drawing, render the canvas, and reset graphics state.
function screen:finish()
	graphics.pop()
	graphics.push "all"

	graphics.setBlendMode("alpha", "premultiplied")
	graphics.setColor(1, 1, 1)
	graphics.setCanvas()

	graphics.draw(self.canvas, 0, 0, 0, self.scale, self.scale)

	graphics.pop()
end

---Handles window resizing, allowing for pixel-perfect scaling and letterboxing.
---Intended to be called from `resize`.
---@param w number The new width of the game window, in real pixels.
---@param h number The new height of the game window, in real pixels.
function screen:resize(w, h)
	self.scale = math.max(
		1,
		math.floor(math.min(w / self.rect.width, h / self.rect.height))
	)

	self.window.width = math.ceil(w / self.scale)
	self.window.height = math.ceil(h / self.scale)
	self.window.x = (self.rect.width - self.window.width) / 2
	self.window.y = (self.rect.height - self.window.height) / 2

	self.canvas = graphics.newCanvas(
		self.window.width,
		self.window.height,
		{ dpiscale = 1 }
	)

	log.debug(
		"Window resized to %dx%d. Canvas resized to %dx%d. Scale factor: %d.",
		w,
		h,
		self.window.width,
		self.window.height,
		self.scale
	)
end

function love.resize(w, h) screen:resize(w, h) end

return screen
