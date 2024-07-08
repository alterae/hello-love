---Logging functions.
---@class log
---@field level log.Level
local log = {}

---Log level enum.
---@enum log.Level
log.Level = {
	---Lowest level, for spammy tracing messages.
	TRACE = { 1, "\x1b[34;1m", "Trace" },
	---Log level for messages useful during debugging.
	DEBUG = { 2, "\x1b[36;1m", "Debug" },
	---Log level for generally informative messages.
	INFO = { 3, "\x1b[32;1m", "Info" },
	---Log level for warning messages.
	WARN = { 4, "\x1b[33;1m", "Warning" },
	---Log level for (recoverable) error messages.
	ERROR = { 5, "\x1b[31;1m", "Error" },
	---Log level for fatal errors.
	FATAL = { 6, "\x1b[35;1m", "Fatal" },
}

log.level = log.Level.DEBUG

---Format and print a log message with the given level.
---@param level log.Level
---@param format string
---@param ... any
function log._print(level, format, ...)
	if level[1] < log.level[1] then return end

	local info = debug.getinfo(3, "Sl")
	local lineinfo = info.short_src .. ":" .. info.currentline
	local date = os.date "%Y-%m-%d %H:%M:%S :: "
	local prefix = level[2] .. level[3] .. "\x1b[0m\t"
	local message = date .. prefix .. string.format(format, ...)

	print(message)

	if level == log.Level.FATAL then
		error(lineinfo .. ": " .. string.format(format, ...))
	end
end

---Format and print a log message with `log.Level.TRACE`.
---@param format string
---@param ... any
function log.trace(format, ...) log._print(log.Level.TRACE, format, ...) end

---Format and print a log message with `log.Level.DEBUG`.
---@param format string
---@param ... any
function log.debug(format, ...) log._print(log.Level.DEBUG, format, ...) end

---Format and print a log message with `log.Level.INFO`.
---@param format string
---@param ... any
function log.info(format, ...) log._print(log.Level.INFO, format, ...) end

---Format and print a log message with `log.Level.WARN`.
---@param format string
---@param ... any
function log.warn(format, ...) log._print(log.Level.WARN, format, ...) end

---Format and print a log message with `log.Level.ERROR`.
---@param format string
---@param ... any
function log.error(format, ...) log._print(log.Level.ERROR, format, ...) end

---Format and print a log message with `log.Level.FATAL`, and then crash.
---@param format string
---@param ... any
function log.fatal(format, ...) log._print(log.Level.FATAL, format, ...) end

return log
