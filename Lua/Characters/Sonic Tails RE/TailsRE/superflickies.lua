/*[[ Super Tails' Flickies v1.3
Author: birbhorse (aka EeveeEuphoria)
Sprites: Sonic Team Jr. (with modifications by author, to allow for coloration)
Shoutouts: gregory_house for making the original Super Flickies mod. I was already a ways in developing this when I discovered this already existed! The code used here is from how the flickies are arranged, and the general flow of the code is derrived from them.
And to MotorRoach for their Flicky character mod, I didn't use their sprites, but I did learn how to give the flicky sprites the abillity to be colored.

TO-DO LIST:
	- [x] 2.2.1 changes, use PlayerThink instead of mobjthinker, remove "end, MT_PLAYER)"
		- [x] also use "gaybird.shadowscale = 2*FRACUNIT/3"
	- Fix Fang's boss fight from letting the birds attack him when he's in the box.
		- Goes up to S_FANG_INTRO9, when at that state, he's ready to be b o p p ' d. Also include the SETUP state.
	
CHANGELOG:
	- NOTE TO SELF: POST srb20130.gif FOR USE AS THE NEW GIF FOR STF
	- This is now only usable in SRB2 v2.2.1 and above! Update SRB2 before using this! Also yes this is v1.3, not v1.2.1, there's a lot more changes than expected.
	- Added drop shadows to the flickies.
	- Made it so the flickies only go out to m u r d e r when the player is completely done with their super transformation animation.
	- Reduced redudancy in code by a lot.
	- Removed unused frames.
	- The birds will not attack the ACZ boss if they're still in the box.
	- Fixed a bug where the birds don't actually animate.
	- Fixed the birds not disappearing when going above the ceiling (thankfully i had a failsafe in there)
	- Fixed problem where if Tails went super again before the birds disappeared, the birds might not spawn correctly.

]]
*/
if CODEBASE < 220 or (CODEBASE == 220 and SUBVERSION < 1)
error("SRB2 Version is not detected as v2.2.1! Please update your game to use this!", 0)
end

-- this returns from MMT, because yes
rawset(_G, "STFINTHEPK3", true)

rawset(_G, "STFModLoaded", true) -- detection of this mod, if needed for any reason

local STFDebug

if STFINTHEPK3 -- detects if file is in the PK3, in which a rawset _G value was placed in a "pk3.lua" file
	STFDebug = false
	else
	STFDebug = true
end

local function DebugPrint(text) -- debug printer
	if STFDebug
		print(text)
	end
end

freeslot(
"MT_TLBRD",
"MT_TLHME",
"S_TAILSBIRD1",
"S_TAILSBIRD2",
"S_TAILSBIRD3",
"S_TAILSBIRD4",
"S_TAILSBIRDHOUSE",
"SPR_FLTS"
)

states[S_TAILSBIRD1] = {
	sprite = SPR_FLTS,
	frame = A,
	tics = 6,
	nextstate = S_TAILSBIRD2
}

states[S_TAILSBIRD2] = {
	sprite = SPR_FLTS,
	frame = C,
	tics = 6,
	nextstate = S_TAILSBIRD3
}

states[S_TAILSBIRD3] = {
	sprite = SPR_FLTS,
	frame = B,
	tics = 6,
	nextstate = S_TAILSBIRD4
}

states[S_TAILSBIRD4] = {
	sprite = SPR_FLTS,
	frame = C,
	tics = 6,
	nextstate = S_TAILSBIRD1
}

states[S_TAILSBIRDHOUSE] = {
	sprite = SPR_NULL, 
	frame = A,
	tics = -1,
	nextstate = S_TAILSBIRDHOUSE
}

mobjinfo[MT_TLBRD] = {
	doomednum = -1,
	spawnstate = S_TAILSBIRD1,
	--speed = 40*FRACUNIT,
	height = 25*FRACUNIT,
	radius = 13*FRACUNIT,
	flags = MF_RUNSPAWNFUNC|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY
}

mobjinfo[MT_TLHME] = {
	doomednum = -1,
	spawnstate = S_TAILSBIRDHOUSE,
	speed = 10*FRACUNIT,
	height = 50,
	flags = MF_RUNSPAWNFUNC|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY
}

local STFCheckSpeed = 6
local STFAttackNum = 4
local STFSuperTails = "on"
local STFSearchType = "aggressive"

-- [[[ Commands ]]] --
-- A lot of this stuff is just code carried over from MMT, because...uh, laziness, and comfort.

local commandDescription = {
["STFCheckSpeed"] = "*\x85 STFCheckSpeed \x81<num>\x80: Adjusts the speed in which checks are performed on the map for enemies, for STFSearchType aggressive. Set to a higher number for slower computers.",
["STFAttackNum"] = "*\x85 STFAttackNum \x81<1, 2, 3, 4>\x80: Changes the number of flickies that are allowed to attack enemies simultaneously.",
["STFSuperTails"] = "*\x85 STFSuperTails \x81<on/off>\x80: Allows Tails to go super.",
["STFSearchType"] = "*\x85 STFSearchType \x81<slow/aggressive>\x80: Changes search type, slow is less accurate but less CPU-demanding."
}

local function cmdDesc(tbl, key)
    for k, v in pairs(tbl) do
        if k == key then 
			return v
		end
    end
    return nil
end

local function stfcheckspeed(player, arg1)
local cmdname = "STFCheckSpeed"
	if STFSearchType == "slow"
		CONS_Printf(player, "\x85\ERROR:\x80 Can not use while STFSearchType is set to slow!")
		return
	end
	if tonumber(arg1)
		arg1 = tonumber(arg1)
	end
	if tonumber(arg1) and arg1 > 0 and arg1 < TICRATE+1
		STFCheckSpeed = tonumber(arg1)
		CONS_Printf(player, "*\x8A ".. cmdname .."\x80 is set to \x87" .. arg1)
	else
		CONS_Printf(player, cmdDesc(commandDescription, cmdname))
		CONS_Printf(player, "*\x8A " .. cmdname .. "\x80 is set to \x87" +STFCheckSpeed)
		CONS_Printf(player, "*\x8E Options:\x80 Values go between 1 and " .. TICRATE .. ", default is 6.")
	end
end

local function stfattacknum(player, arg1)
local cmdname = "STFAttackNum"
	if tonumber(arg1)
		arg1 = tonumber(arg1)
	end
	if tonumber(arg1) and arg1 > 0 and arg1 < 4
		STFAttackNum = tonumber(arg1)
		CONS_Printf(player, "*\x8A ".. cmdname .."\x80 is set to \x87" .. arg1)
	else
		CONS_Printf(player, cmdDesc(commandDescription, cmdname))
		CONS_Printf(player, "*\x8A " .. cmdname .. "\x80 is set to \x87" +STFAttackNum)
		CONS_Printf(player, "*\x8E Options:\x80 Values go between 1 and 4, default is 4.")
	end
end

local function stfsupertails(player, arg1)
local cmdname = "STFSuperTails"
	if mmtVersion
		CONS_Printf(player, "\x85\ERROR:\x80 Can not use while MMT is loaded! Use \"everysuper disable\" or \"everysuper off\" instead!")
		return
	end
	if arg1 == "on" or arg1 == "off"
		STFSuperTails = arg1
		CONS_Printf(player, "*\x8A ".. cmdname .."\x80 is set to \x87" .. arg1)
	else
		CONS_Printf(player, cmdDesc(commandDescription, cmdname))
		CONS_Printf(player, "*\x8A " .. cmdname .. "\x80 is set to \x87" +STFSuperTails) 
		CONS_Printf(player, "*\x8E Options:\x80 \"on\", \"off\".")
	end
end

local function stfsearchtype(player, arg1)
local cmdname = "STFSearchType"
	if arg1 == "aggressive" or arg1 == "slow"
		STFSearchType = arg1
		CONS_Printf(player, "*\x8A ".. cmdname .."\x80 is set to \x87" .. arg1)
	else
		CONS_Printf(player, cmdDesc(commandDescription, cmdname))
		CONS_Printf(player, "*\x8A " .. cmdname .. "\x80 is set to \x87" +STFSearchType) 
		CONS_Printf(player, "*\x8E Options:\x80 \"slow\", \"aggressive\".")
	end
end

COM_AddCommand("STFCheckSpeed", stfcheckspeed, 1)
COM_AddCommand("STFAttackNum", stfattacknum, 1)
COM_AddCommand("STFSuperTails", stfsupertails, 1)
COM_AddCommand("STFSearchType", stfsearchtype, 1)


-- [[[ Player Thinker ]]] --

addHook("PlayerThink", function(player)

if not player.STFMod
	player.STFMod = {}
end

if player.STFMod.birdangle == nil
	player.STFMod.birdangle = 0 
	player.STFMod.birdheightangle = 0 
	player.STFMod.birdheight = 0 
end

-- [[ Spawn The Birb ]] --
	if (player.mo.skin == "tailsre") and player.powers[pw_super] and not player.STFMod.birdsSummoned --when player is super, but birds are not out
		player.STFMod.birdMissionTime = 0
		player.STFMod.CoolDownBirdTimer = 0
		player.STFMod.bird1target = "none"
		player.STFMod.bird2target = "none"
		player.STFMod.bird3target = "none"
		player.STFMod.bird4target = "none"
		
		local function SummonMe(bird, number)
			bird = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.ceilingz-(2*FRACUNIT), MT_TLBRD)
			bird.number = number	
			bird.color = 79
			bird.idle = true
			bird.tailsdude = player.mo
			bird.shadowscale = 2*FRACUNIT/3
		end
		
		SummonMe(player.STFMod.bird1, 1)
		SummonMe(player.STFMod.bird2, 2)
		SummonMe(player.STFMod.bird3, 3)
		SummonMe(player.STFMod.bird4, 4)
		player.STFMod.birdhome = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_TLHME)
		player.STFMod.birdhome.tailsdude = player.mo
		player.STFMod.birdsSummoned = true
		player.STFMod.birdsReady = false
	end

-- [[ The Good Birb Stuff, contains logic for the movement when idle, and the detection of enemies ]] --
	if player.powers[pw_super] and player.STFMod.birdsSummoned
		-- [ Bird Home ] --
		if (player.mo.eflags & MFE_VERTICALFLIP) or (player.mo.flags2 & MF2_OBJECTFLIP)
			P_TeleportMove(player.STFMod.birdhome, player.mo.x+player.mo.momx, player.mo.y+player.mo.momy, player.mo.momz + (player.mo.z-(player.mo.height/2)-25*FRACUNIT))
		else
			P_TeleportMove(player.STFMod.birdhome, player.mo.x+player.mo.momx, player.mo.y+player.mo.momy, player.mo.momz + (player.mo.z+(player.mo.height/2)+20*FRACUNIT))
		end
		
		-- [ Bobbing ] -- Todo: Duplicate the GayBirdH thing 3 times to make different ones for each individual birb.
		if player.STFMod.gaybirdtimer == nil
			player.STFMod.gaybirdtimer = 0
			player.STFMod.GayBirdH = 40*FRACUNIT
		else
			player.STFMod.gaybirdtimer = $+1
		end
		if player.STFMod.gaybirdtimer < 40
			player.STFMod.GayBirdH = $+(3/FRACUNIT)
		elseif player.STFMod.gaybirdtimer < 80
			player.STFMod.GayBirdH = $-(3/FRACUNIT)
		else
			player.STFMod.gaybirdtimer = 0
		end

		-- [ Player Flip ] --
		if (player.mo.eflags & MFE_VERTICALFLIP) or (player.mo.flags2 & MF2_OBJECTFLIP)
			player.STFMod.GayBirdHFlip = (-player.STFMod.GayBirdH)
		else
			player.STFMod.GayBirdHFlip = 0
		end

		-- [ Floating Stuffs ] --
		player.STFMod.birdangle = $+5*FRACUNIT
		player.STFMod.birdheightangle = $+7*FRACUNIT
		player.STFMod.birdheight = player.mo.z+player.STFMod.GayBirdH+player.STFMod.GayBirdHFlip -- add timer to make this bob up and down
		player.STFMod.birddistance = 45
		
		-- [ Search Cooldown Timer ] --
		if player.STFMod.CoolDownBirdTimer > 0
			player.STFMod.CoolDownBirdTimer = $ - 1
		end
	end
	
	if player.STFMod.birdsSummoned
		-- [ Distance between player and target enemy ] --
		if player.STFMod.bird1MissionTime and player.STFMod.bird1target.valid
			player.STFMod.target1distance = R_PointToDist2(player.STFMod.bird1target.x, player.STFMod.bird1target.y, player.mo.x, player.mo.y)/FRACUNIT
		end
		if player.STFMod.bird2MissionTime and player.STFMod.bird2target.valid
			player.STFMod.target2distance = R_PointToDist2(player.STFMod.bird2target.x, player.STFMod.bird2target.y, player.mo.x, player.mo.y)/FRACUNIT
		end
		if player.STFMod.bird3MissionTime and player.STFMod.bird3target.valid
			player.STFMod.target3distance = R_PointToDist2(player.STFMod.bird3target.x, player.STFMod.bird3target.y, player.mo.x, player.mo.y)/FRACUNIT
		end
		if player.STFMod.bird4MissionTime and player.STFMod.bird4target.valid
			player.STFMod.target4distance = R_PointToDist2(player.STFMod.bird4target.x, player.STFMod.bird4target.y, player.mo.x, player.mo.y)/FRACUNIT
		end
		
		-- [ Keep Up With Da Player ] --
		player.STFMod.bird1 = { x =  player.mo.x+cos(FixedAngle(player.STFMod.birdangle))*player.STFMod.birddistance, y = player.mo.y+sin(FixedAngle(player.STFMod.birdangle))*player.STFMod.birddistance, z = player.STFMod.birdheight+sin(FixedAngle(2*player.STFMod.birdheightangle))*5 }
		player.STFMod.bird2 = { x =  player.mo.x+cos(FixedAngle(player.STFMod.birdangle+90*FRACUNIT))*player.STFMod.birddistance, y = player.mo.y+sin(FixedAngle(player.STFMod.birdangle+90*FRACUNIT))*player.STFMod.birddistance, z = player.STFMod.birdheight+sin(FixedAngle(2*player.STFMod.birdheightangle))*5 }
		player.STFMod.bird3 = { x =  player.mo.x+cos(FixedAngle(player.STFMod.birdangle+180*FRACUNIT))*player.STFMod.birddistance, y = player.mo.y+sin(FixedAngle(player.STFMod.birdangle+180*FRACUNIT))*player.STFMod.birddistance, z = player.STFMod.birdheight+sin(FixedAngle(2*player.STFMod.birdheightangle))*5 }
		player.STFMod.bird4 = { x =  player.mo.x+cos(FixedAngle(player.STFMod.birdangle+270*FRACUNIT))*player.STFMod.birddistance, y = player.mo.y+sin(FixedAngle(player.STFMod.birdangle+270*FRACUNIT))*player.STFMod.birddistance, z = player.STFMod.birdheight+sin(FixedAngle(2*player.STFMod.birdheightangle))*5 }
		

		-- { Searches ] --
		
		local function searchingtime(mobj)
			if (R_PointToDist2(mobj.x, mobj.y, player.mo.x, player.mo.y) < 512*FRACUNIT) and (abs(mobj.z - player.mo.z) < 512*FRACUNIT) 
			and (((mobj.flags & MF_ENEMY) or (mobj.flags & MF_BOSS)))
			and not (mobj.flags2 & MF2_FRET)
			and not (mobj.type == MT_TURRET)
			and not ((mobj.type == MT_EGGMOBILE4) and (mobj.health >= 4) and (mobj.state == S_EGGMOBILE4_STND)) -- CEZ 3 Boss
			and ((mobj.flags & MF_SPECIAL) or mobj.type == MT_DETON or mobj.type == MT_EGGGUARD) -- detects if enemy can actually be hit, or if it's a deton
			and P_CheckSight(player.mo, mobj) -- checks to see if not obscured by wall
			and not ((mobj.type == MT_FANG) and (mobj.state == S_FANG_SETUP) or (mobj.state == S_FANG_INTRO0) or (mobj.state == S_FANG_INTRO1) or (mobj.state == S_FANG_INTRO2) or (mobj.state == S_FANG_INTRO3) or (mobj.state == S_FANG_INTRO4) or (mobj.state == S_FANG_INTRO5) or (mobj.state == S_FANG_INTRO6) or (mobj.state == S_FANG_INTRO7) or (mobj.state == S_FANG_INTRO8)) -- fang boss, makes sure he's not in the box
			and mobj.health > 0
				return true
			else
				return false
			end
		end
		
		local function sendthemout(searchtype)
			if player.STFMod.bird1target == "none" and not (player.STFMod.bird2target == searchtype or player.STFMod.bird3target == searchtype or player.STFMod.bird4target == searchtype)
			and STFAttackNum >= 1
				player.STFMod.bird1target = searchtype
			elseif player.STFMod.bird2target == "none" and not (player.STFMod.bird1target == searchtype or player.STFMod.bird3target == searchtype or player.STFMod.bird4target == searchtype)
			and STFAttackNum >= 2
				player.STFMod.bird2target = searchtype
			elseif player.STFMod.bird3target == "none" and not (player.STFMod.bird1target == searchtype or player.STFMod.bird2target == searchtype or player.STFMod.bird4target == searchtype)
			and STFAttackNum >= 3
				player.STFMod.bird3target = searchtype
			elseif player.STFMod.bird4target == "none" and not (player.STFMod.bird2target == searchtype or player.STFMod.bird3target == searchtype or player.STFMod.bird1target == searchtype)
			and STFAttackNum >= 4
				player.STFMod.bird4target = searchtype
			end
			DebugPrint("ENEMY SPOTTED, IT'S: " +searchtype.type .. " WITH A STATE OF: " .. searchtype.state .. " AND HEALTH OF: " .. searchtype.health .. " AND FLAG VALUES: " .. searchtype.flags .. " " .. searchtype.flags2 .. " " .. searchtype.eflags)
		end
		
		if STFSearchType == "slow" and player.STFMod.birdsReady
			player.STFMod.SearchTime = P_LookForEnemies(player, false, false)
			if player.STFMod.SearchTime
				if searchingtime(player.STFMod.SearchTime)
					-- [ Send the Birbs ] -- 
					sendthemout(player.STFMod.SearchTime)
				end
			end
		end
		-- [ o.g. Break The Targets ] -- 
		if STFSearchType == "aggressive" and player.STFMod.CoolDownBirdTimer == 0 and player.STFMod.birdsReady
			player.STFMod.CoolDownBirdTimer = STFCheckSpeed
			for mobj in mobjs.iterate("mobj")
				if searchingtime(mobj)
				-- [ Send the Birbs ] -- 
					sendthemout(mobj)
				end
			end
		
	-- [ end of BirdsSummoned ] --
	end
		-- [ Assign Birb on a mission] -- 
		if player.STFMod.bird1target != "none" and not player.STFMod.bird1MissionTime and player.STFMod.bird1target.valid
			player.STFMod.bird1MissionTime = true
			DebugPrint("SENDING OUT: FIRST BIRB")
		end
		if player.STFMod.bird2target != "none" and not player.STFMod.bird2MissionTime and player.STFMod.bird2target.valid
			player.STFMod.bird2MissionTime = true
			DebugPrint("SENDING OUT: SECOND BIRB")
		end
		if player.STFMod.bird3target != "none" and not player.STFMod.bird3MissionTime and player.STFMod.bird3target.valid
			player.STFMod.bird3MissionTime = true
			DebugPrint("SENDING OUT: THIRD BIRD")
		end
		if player.STFMod.bird4target != "none" and not player.STFMod.bird4MissionTime and player.STFMod.bird4target.valid
			player.STFMod.bird4MissionTime = true
			DebugPrint("SENDING OUT: FINAL BIRD")
		end
	end 
	
	if not player.powers[pw_super] and player.STFMod.birdsSummoned --when player is no longer super, but birds are still out
		player.STFMod.birdsSummoned = false
		player.STFMod.bird1 = nil
		player.STFMod.bird2 = nil
		player.STFMod.bird3 = nil
		player.STFMod.bird4 = nil
	end
end)


-- [[ Bird Thinker ]] --
addHook("MobjThinker", function(gaybird) -- figure out how to sync their pulses with the character's pulses
local player = gaybird.tailsdude.player

-- [ Local functions ] --
local function attacc(mission, distance, target, number)
	if mission and distance and target.valid 
		--DebugPrint("I've been summoned, I am: " .. gaybird.number)
		gaybird.idle = false
		if target != "none" 
			gaybird.target = target 
		end
		if gaybird.target and gaybird.target.valid and gaybird.target.health > 0 and not (gaybird.target.flags2 & MF2_FRET)
		and distance < 768
			A_HomingChase(gaybird, 40*FRACUNIT, 0)
			if (R_PointToDist2(gaybird.target.x, gaybird.target.y, gaybird.x, gaybird.y))/FRACUNIT < 30 and (abs((gaybird.target.z - gaybird.z)/FRACUNIT) < 30)
				if gaybird.target.health > 1
				P_DamageMobj(gaybird.target, gaybird, player.mo, 1)
				else
				P_KillMobj(gaybird.target, gaybird, player.mo, DMG_INSTAKILL)
				end
			end
		else
			target = "none"
			gaybird.target = nil
			distance = nil
			mission = false
			gaybird.returninghome = true
			DebugPrint("Enemy is gone, or mission has failed! Number: " .. number)
		end
	end	
end

local function hovertime(opposition, division)
	gaybird.angle = R_PointToAngle2(gaybird.x, gaybird.y, opposition.x, opposition.y)+45*FRACUNIT
	gaybird.momx = (opposition.x - gaybird.x)/division
	gaybird.momy = (opposition.y - gaybird.y)/division
	gaybird.momz = (opposition.z - gaybird.z)/division
end

local function returning(target, distance, mission)
	target = "none"
	distance = nil
	mission = false
end


if not gaybird.GoAway and player.STFMod.bird1 and player.STFMod.bird2 and player.STFMod.bird3 and player.STFMod.bird4
-- [ Colors and States ] -- 
	if gaybird.timer == nil
	gaybird.timer = 0 + (gaybird.number*2) --offset the color
	else
	gaybird.timer = $+1
	end
	if gaybird.timer == 1
		gaybird.color = SKINCOLOR_SUPERGOLD1
	elseif gaybird.timer == 3
		gaybird.color = SKINCOLOR_SUPERGOLD2
	elseif gaybird.timer == 5
		gaybird.color = SKINCOLOR_SUPERGOLD3
	elseif gaybird.timer == 7
		gaybird.color = SKINCOLOR_SUPERGOLD4
	elseif gaybird.timer == 9
		gaybird.color = SKINCOLOR_SUPERGOLD5
	elseif gaybird.timer == 11
		gaybird.color = SKINCOLOR_SUPERGOLD4
	elseif gaybird.timer == 13
		gaybird.color = SKINCOLOR_SUPERGOLD3
	elseif gaybird.timer == 15
		gaybird.color = SKINCOLOR_SUPERGOLD2
	elseif gaybird.timer == 17
		gaybird.timer = 0
	end
	if not gaybird.setstate
		if gaybird.number == 1
			gaybird.state = S_TAILSBIRD1
		elseif gaybird.number == 2
			gaybird.state = S_TAILSBIRD2
		elseif gaybird.number == 3
			gaybird.state = S_TAILSBIRD3
		elseif gaybird.number == 4
			gaybird.state = S_TAILSBIRD4
		end
		gaybird.setstate = true
	end

-- [ player flip, bird flip ] --

	if (player.mo.eflags & MFE_VERTICALFLIP)
		gaybird.flags2 = $1 | MF2_OBJECTFLIP
		else
		gaybird.flags2 = $ & ~MF2_OBJECTFLIP
	end

-- [ get the birbs ready to attack ] --
	if not player.STFMod.birdsReady and abs((player.mo.z-gaybird.z)/FRACUNIT) <91
	and (player.mo.state != S_PLAY_SUPER_TRANS1) and (player.mo.state != S_PLAY_SUPER_TRANS2) and (player.mo.state != S_PLAY_SUPER_TRANS3) and (player.mo.state != S_PLAY_SUPER_TRANS4) and (player.mo.state != S_PLAY_SUPER_TRANS5) and (player.mo.state != S_PLAY_SUPER_TRANS6) 
		player.STFMod.birdsReady = true
	end
	

-- [[ It begins ]] --

-- [ Hover near player ] --
	if gaybird.idle --and player.STFMod.bird1target == "none"
		if gaybird.number == 1 and not player.STFMod.bird1MissionTime
			hovertime(player.STFMod.bird2, 2)
		elseif gaybird.number == 2 and not player.STFMod.bird2MissionTime
			hovertime(player.STFMod.bird3, 3)
		elseif gaybird.number == 3 and not player.STFMod.bird3MissionTime
			hovertime(player.STFMod.bird4, 4)
		elseif gaybird.number == 4 and not player.STFMod.bird4MissionTime
			hovertime(player.STFMod.bird1, 5)
		end
	end
	
	-- [ Target Enemy ] --

	if not gaybird.returninghome
		if gaybird.number == 1
			attacc(player.STFMod.bird1MissionTime, player.STFMod.target1distance, player.STFMod.bird1target, 1)
		elseif gaybird.number == 2
			attacc(player.STFMod.bird2MissionTime, player.STFMod.target2distance, player.STFMod.bird2target, 2)
		elseif gaybird.number == 3
			attacc(player.STFMod.bird3MissionTime, player.STFMod.target3distance, player.STFMod.bird3target, 3)
		elseif gaybird.number == 4
			attacc(player.STFMod.bird4MissionTime, player.STFMod.target4distance, player.STFMod.bird4target, 4)
		end
	end
	
	-- [ Return back to player ] --
	if gaybird.returninghome
		gaybird.idle = false
		gaybird.target = player.STFMod.birdhome
		gaybird.DistanceFromPlayer = R_PointToDist2(gaybird.target.x, gaybird.target.y, gaybird.x, gaybird.y)/FRACUNIT
		gaybird.SpeedPlus = gaybird.DistanceFromPlayer / 70
		if gaybird.SpeedPlus < 10
		gaybird.SpeedPlus = 10
		end
		if gaybird.imlost
			A_HomingChase(gaybird, 10*gaybird.SpeedPlus*FRACUNIT, 0)
		else 
			A_HomingChase(gaybird, 6*gaybird.SpeedPlus*FRACUNIT, 0)
		end
		if gaybird.target and (R_PointToDist2(gaybird.target.x, gaybird.target.y, gaybird.x, gaybird.y))/FRACUNIT < 45
			gaybird.target = nil
			gaybird.returninghome = false
			gaybird.imlost = false
			if gaybird.number == 1 -- for some reason, returning function does not work here
				player.STFMod.bird1target = "none"
				player.STFMod.bird1MissionTime = false
				player.STFMod.target1distance = nil
			elseif gaybird.number == 2
				player.STFMod.bird2target = "none"
				player.STFMod.bird2MissionTime = false
				player.STFMod.target2distance = nil
			elseif gaybird.number == 3
				player.STFMod.bird3target = "none"
				player.STFMod.bird3MissionTime = false
				player.STFMod.target3distance = nil
			elseif gaybird.number == 4 
				player.STFMod.bird4target = "none"
				player.STFMod.bird4MissionTime = false
				player.STFMod.target4distance = nil
			end
			gaybird.idle = true
			DebugPrint("back home, number: " +gaybird.number)
		end
	end

-- [ bird is travelling dimensions when they're supposed to be idle ] --
-- this shouldn't be a problem anymore, but this is just for in case it comes up in some Wild situation
	gaybird.idleplayerdistance = R_PointToDist2(player.mo.x, player.mo.y, gaybird.x, gaybird.y)/FRACUNIT
	if gaybird.idleplayerdistance > 1690 and gaybird.idle
		if gaybird.number == 1
			returning(player.STFMod.bird1target, player.STFMod.target1distance, player.STFMod.bird1MissionTime)
		elseif gaybird.number == 2
			returning(player.STFMod.bird2target, player.STFMod.target2distance, player.STFMod.bird2MissionTime)
		elseif gaybird.number == 3
			returning(player.STFMod.bird3target, player.STFMod.target3distance, player.STFMod.bird3MissionTime)
		elseif gaybird.number == 4
			returning(player.STFMod.bird4target, player.STFMod.target4distance, player.STFMod.bird4MissionTime)
		end
		gaybird.returninghome = true
		gaybird.imlost = true
		DebugPrint("Too far away, forcing self to return! Number is: " .. gaybird.number)
	end
	
	
	gaybird.playerceiling = player.mo.ceilingz
end

-- [[ Player is no longer super, disperse. ]] --
	if not player.powers[pw_super]
		gaybird.TimeToLeave = true
	end
	if gaybird.TimeToLeave
		gaybird.GoAway = true
		gaybird.color = SKINCOLOR_CORNFLOWER
		if not gaybird.DisperseTimer
			gaybird.DisperseTimer = 0
			gaybird.momx = 0
			gaybird.momy = 0
			gaybird.momz = 0
		end
		gaybird.DisperseTimer = $ + 1
		
		if gaybird.number == 1
			returning(player.STFMod.bird1target, player.STFMod.target1distance, player.STFMod.bird1MissionTime)
		elseif gaybird.number == 2
			returning(player.STFMod.bird2target, player.STFMod.target2distance, player.STFMod.bird2MissionTime)
		elseif gaybird.number == 3
			returning(player.STFMod.bird3target, player.STFMod.target3distance, player.STFMod.bird3MissionTime)
		elseif gaybird.number == 4
			returning(player.STFMod.bird4target, player.STFMod.target4distance, player.STFMod.bird4MissionTime)
		end

		P_SetObjectMomZ(gaybird, (FRACUNIT/2), true)

		if gaybird.z >= gaybird.playerceiling 
		or gaybird.DisperseTimer >= TICRATE*5
			DebugPrint("delet this, " .. gaybird.number)
			P_RemoveMobj(gaybird)
		end
	end
	if player.powers[pw_super] and gaybird.TimeToLeave
		DebugPrint("player went super early, removing self now: " .. gaybird.number)
		P_RemoveMobj(gaybird)
	end
end, MT_TLBRD)

addHook("MobjThinker", function(CoryInTheHouse)
local player = CoryInTheHouse.tailsdude.player
	if (player.mo.eflags & MFE_VERTICALFLIP) or (player.mo.flags2 & MF2_OBJECTFLIP)
		CoryInTheHouse.flags2 = $1 | MF2_OBJECTFLIP
	else
		CoryInTheHouse.flags2 = $ & ~MF2_OBJECTFLIP
	end
	
	if STFDebug
		CoryInTheHouse.sprite = SPR_RING
	end

	if not player.powers[pw_super]
		P_RemoveMobj(CoryInTheHouse)
	end
end, MT_TLHME)