addHook("ThinkFrame", function(player)
	for player in players.iterate do
		if not (player.mo and player.mo.skin == "ssnamy") then return end

		-- Button tapping detection script, taken and modified from the wiki
		if not (player.cmd.buttons & BT_SPIN) then
			player.spintapready = true
			player.spintapping = false
		elseif player.spintapready then
			player.spintapping = true
			player.spintapready = false
		else
			player.spintapping = false
		end

		if player.powers[pw_super]
		and player.speed > (skins["ssnamy"].normalspeed*2)+5*FRACUNIT
		and not player.isxmomentum
		or player.speed > (skins["ssnamy"].normalspeed)+5*FRACUNIT
		and not player.isxmomentum then
			player.normalspeed = player.actionspd
		else
			player.normalspeed = skins["ssnamy"].normalspeed
		end

		if player.donnycooldown then
			player.donnycooldown = $-1
		end

		if player.donnydash
		and player.donnydash > 0 then
			if player.powers[pw_invulnerability] <= 2
			and (not(player.powers[pw_shield] & SH_NOSTACK)
			or player.powers[pw_super]) then
				player.powers[pw_invulnerability] = 2
			elseif player.powers[pw_flashing] <= 2
			and player.powers[pw_invulnerability] <= 2 then
				player.powers[pw_flashing] = 2
			end

			if player.powers[pw_justsprung] then
				player.donnydash = 0
				player.mo.state = S_PLAY_SPRING
			end

			if player.mo.state == S_PLAY_JUMP
			and not player.donnydashup then
				P_DoJump(player, false)
				player.donnydashjump = true
				player.donnydash = 0
			elseif player.donnydashup then
				P_SetObjectMomZ(player.mo, player.actionspd/2/(4/3), false)
			else
				player.mo.momz = 0
			end

			if player.pflags & PF_ANALOGMODE
			and not player.donnydashup then
				player.mo.state = S_PLAY_DASH
				if player.powers[pw_super] then
					P_InstaThrust(player.mo, player.mo.angle, (player.actionspd*(5*TICRATE/2))/TICRATE)
				else
					P_InstaThrust(player.mo, player.mo.angle, player.actionspd)
				end
			elseif not player.donnydashup then
				player.mo.state = S_PLAY_DASH
				if player.powers[pw_super] then
					P_InstaThrust(player.mo, R_PointToAngle2(0, 0, player.cmd.forwardmove*FRACUNIT, -player.cmd.sidemove*FRACUNIT)+player.mo.angle, player.actionspd*(5/2))
				else
					P_InstaThrust(player.mo, R_PointToAngle2(0, 0, player.cmd.forwardmove*FRACUNIT, -player.cmd.sidemove*FRACUNIT)+player.mo.angle, player.actionspd)
				end
			end

			local ghost = P_SpawnGhostMobj(player.mo)
			ghost.colorized = true
			ghost.color = player.mo.color
			player.donnyresetme = true
			player.height = P_GetPlayerSpinHeight(player)
			player.charflags = $|SF_NOSKID
			player.donnydash = $ - 1
		elseif player.donnyresetme
		and not player.donnydashjump then
			player.mo.state = S_PLAY_FALL
			player.height = skins["ssnamy"].height
			player.charflags = $&~SF_NOSKID
			player.donnyresetme = false
		elseif player.donnydashjump then
			if P_IsObjectOnGround(player.mo) then
				player.donnydashjump = nil
			end
		end

		if player.pflags & PF_THOKKED
		and player.donnydashup then
			player.pflags = $|PF_CANCARRY
		else
			player.pflags = $&~PF_CANCARRY
		end
	end
end)

addHook("SpinSpecial", function(player)
    if player.mo and player.mo.skin == "ssnamy" -- charname here
	and not player.exiting
	and not(player.donnydash and player.donnydash > 0)
	and player.spintapping
	and P_IsObjectOnGround(player.mo)
	and not(player.pflags & PF_SLIDING)
	and not player.donnycooldown then
		player.donnydashup = nil
		player.donnydash = TICRATE/4
		player.donnycooldown = TICRATE
		player.mo.state = S_PLAY_DASH
		S_StartSound(player.mo, sfx_zoom, player)
		return true
    end
end)

addHook("JumpSpinSpecial", function(player)
    if player.mo and player.mo.skin == "ssnamy" -- charname here
	and not player.exiting
	and not(player.donnydash and player.donnydash > 0)
	and player.spintapping
	and not(player.pflags & PF_THOKKED)
	and not(player.pflags & PF_SLIDING)
	and not player.donnycooldown then
		player.donnydashup = nil
		player.donnydash = TICRATE/4
		player.donnycooldown = TICRATE
		S_StartSound(player.mo, sfx_zoom, player)
		player.mo.state = S_PLAY_DASH
		player.pflags = $|PF_THOKKED
		return true
    end
end)

addHook("AbilitySpecial", function(player)
    if player.mo and player.mo.skin == "ssnamy" -- charname here
	and not player.exiting
	and not(player.donnydash and player.donnydash > 0)
	and not(player.pflags & PF_THOKKED)
	and not(player.pflags & PF_SLIDING) then
		player.donnydashup = true
		player.donnydash = TICRATE/4
		S_StartSound(player.mo, sfx_zoom, player)
		player.mo.state = S_PLAY_SPRING
		player.pflags = $|PF_THOKKED
		return true
	end
end)

local function P_AmyIsStrongGodDamnIt(mo, sec)
	for fof in sec.ffloors() do
		if not (fof.flags & FF_EXISTS) then continue end -- Does it exist?
		if not (fof.flags & FF_BUSTUP) then continue end -- Is it bustable?
		
		if mo.z + mo.height < fof.bottomheight then continue end -- Are we too low?
		if mo.z > fof.topheight then continue end -- Are we too high?
		
		if not mo.player.donnydash then return end
		if not (mo.player.donnydash > 0) then return end

		EV_CrumbleChain(fof) -- Crumble
	end
end

addHook("PlayerThink", function(p)
	if not p.mo then return end
	if p.mo.skin != "ssnamy" then return end
	P_AmyIsStrongGodDamnIt(p.mo, p.mo.subsector.sector)
end)

addHook("MobjLineCollide", function(mo, line)
	if not mo.player then return end
	if mo.skin != "ssnamy" then return end
	
	for _, sec in ipairs({line.frontsector, line.backsector}) do
		P_AmyIsStrongGodDamnIt(mo, sec)
	end
end, MT_PLAYER)

addHook("MobjCollide", function(thing, tmthing)
	if (tmthing.skin ~= "ssnamy" or not tmthing.player) then return end -- return end if you're not that skin or you aren't a skin
	if thing.z + thing.height < tmthing.z + tmthing.momz or thing.z > tmthing.z + tmthing.momz + tmthing.height then return nil end -- return nil end if that's true, i forgot what this checks
	local p = tmthing.player -- localing p as player
	if(p.mo.state == S_PLAY_DASH) then -- If you're spinning, you will have the following effects:
		P_KillMobj(thing, tmthing, tmthing, nil, nil) -- You'll "kill" the specified object.
	end
end, MT_SPIKE)

addHook("PlayerCanDamage", function(player, mobj)
	if not player.mo.skin == "ssnamy" then return end
	
	if player.donnydash then
		return true
	end
end)