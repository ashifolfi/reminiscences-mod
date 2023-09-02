--[[
	Reminiscences init script

	this file is mostly self explanatory and shouldn't
	be too difficult to understand.

	Created by Ashi
]]

local folder = ""
local function df(filename)
	dofile(folder..filename..".lua")
end

-------------------------------
--        Init Start         --
-------------------------------

-- check for the version global
if (rawget(_G, "REMIN_VERSION") != nil) then
	-- we have a conflict. cancel load and inform the user.
	error("[REMIN] Another version of Reminiscences is already loaded!")
	return
end

-- establish the version global
rawset(_G, "REMIN_VERSION", 200)

-- Load lua files

df("config")

folder = "Definitions/"
	df("skincolors")
	df("taunts")

folder = "Characters/"
	-- TODO: we might want to separate some of these up
	df("blaze")
	df("ssnamy")
	df("sally")

folder = "Characters/AmyRE/"
	df("hammer_rush")
	df("charge_jump")
	df("hammer_spin")

folder = "Characters/MightyRE/"
	df("walljump")
	df("hard_shell")
	df("stomp_dash")

folder = "Characters/ShadowRE/"
	df("skating")
	df("super_float")
	df("hud")
	df("chaos_energy")
	df("chaos_spear")

folder = "Characters/SSNShadow/"
	df("light_dash")
	df("skating")
	df("floating")
	df("double_thok")

folder = "Characters/SonicRE/"
	df("bounce")
	df("spin_drift")
	df("super_float")

folder = "Characters/TailsRE/"
	df("tail_swipe")
	df("sa1_flight")
	df("super_flickies")

folder = "Characters/SonicTailsRE/"
	df("sa_effects")
	df("partner_code")