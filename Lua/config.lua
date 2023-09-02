--[[
	Reminiscences Config System

	- simple csv like structure
	- integrity checking via a file header

	Written by Ashi
]]

local REM_CONFIG_LOCATION = "client/reminiscences/config.cfg"

-- array of CVars to save to the file
-- THIS IS AUTOPOPULATED
local save_vars = {}

-- holds the "pretty names" of every defined cvar
local cvar_pnames = {}

-- non global function used to speed up adding config vars
-- actual config var registering is found at the bottom of this file
local function ReminRegisterVar(name, prettyname, defaultvalue, possiblevalue)
	CV_RegisterVar({
		name = name,
		defaultvalue = defaultvalue,
		-- (CV_NOINIT) don't overwrite the config on startup
		flags = CV_CALL|CV_NOINIT,
		PossibleValue = possiblevalue,
		func = function(var)
			print("[REMIN] "..cvar_pnames[var.name].." is now set to "..var.string)
			ReminSaveConfig()
		end
	})

	cvar_pnames[name] = prettyname
	table.insert(save_vars, name)
end

-- Attempts to load the config file.
-- If the config is invalid or missing a new one with defaults is generated
local function ReminLoadConfig()
	local file = io.openlocal(REM_CONFIG_LOCATION, "r")

	-- check for the existence of the config file.
	if not file then
		-- no config file? write one with defaults.
		print("[REMIN] No config file detected. Writing defaults...")
		ReminSaveConfig()
		return
	end

	-- check for an intact file header
	if not (file:read("*l") == "<ReminCFG>") then
		print("[REMIN] Config file is bad or corrupted. Regenerating...")
		ReminSaveConfig()
		return
	end

	-- if we made it here we should be good.
	-- start reading lines.
	for line in file:lines() do
		local name, value = string.match(line, "'(.*)','(.*)'")

		local cvar = CV_FindVar(name)
		if cvar then
			-- don't want to overwrite the config file we're reading it!!!
			CV_StealthSet(cvar, value)
		end
	end
end

-- Attempts to save the config file
-- This process will overwrite the file! be careful about when you call this!
local function ReminSaveConfig()
	local cfg_line_templ = "'%s','%s'\n"

	local file = io.openlocal(REM_CONFIG_LOCATION, "w+")

	-- write the file header
	file:write("<ReminCFG>\n")

	-- for every cvar name in the table. save it's name and value
	for _,cvname in ipairs(save_vars) do
		local cvar = CV_FindVar(cvname)
		local cfg_line = string.format(cfg_line_templ, cvname, cvar.string)
		file:write(cfg_line)
	end

	file:flush()
	file:close()
	print("[REMIN] Saved config file.")
end

rawset(_G, "ReminLoadConfig", ReminLoadConfig)
rawset(_G, "ReminSaveConfig", ReminSaveConfig)

-- game quit hook to save config on quit
addHook("GameQuit", function()
	ReminSaveConfig()
end)

--------------------------------------------------
--				Config System Init              --
--------------------------------------------------

-- register CVars
ReminRegisterVar("remin_taunt_button", "Taunt Button", "custom3", {
	["custom3"] = BT_CUSTOM3,
	["custom2"] = BT_CUSTOM2, -- TODO: check for conflicts on this one
	["tossflag"] = BT_TOSSFLAG
})
ReminRegisterVar("remin_taunt_sounds", "Taunt Sounds", "On", CV_OnOff)

-- Load config file
ReminLoadConfig()