freeslot("S_AMYRE_HAMMERSPIN")
states[S_AMYRE_HAMMERSPIN] = {SPR_PLAY, SPR2_MLEE|FF_ANIMATE, 32, nil, 7, 2, S_PLAY_RUN}
addHook("ThinkFrame", function(player)
	for player in players.iterate
		if not player.mo return end
		if player.mo.skin == "amyre" -- charname here
			-- Button tapping detection script, taken and modified from the wiki
			if not (player.cmd.buttons & BT_USE) then
				player.spintapready = true
				player.spintapping = false
			elseif player.spintapready then
				player.spintapping = true
				player.spintapready = false
			else
				player.spintapping = false
			end
			-- Hammer spin cooldown
			if player.hammerspincooldown == nil
				player.hammerspincooldown = 0
			end
			if player.mo.state == S_AMYRE_HAMMERSPIN
			and player.hammerspincooldown == 0
				player.hammerspincooldown = 64
			end
			if player.hammerspincooldown > 0
				player.hammerspincooldown = $ - 1
			end
			-- Ghost trail thing
			if player.mo.state == S_AMYRE_HAMMERSPIN
				local ghost = P_SpawnGhostMobj(player.mo)
				ghost.fuse = 4
				ghost.speed = player.speed
			end
		end
	end
end)
addHook("PlayerThink", function(player)
	if player.exiting return end
    if player.mo and player.mo.skin == "amyre" -- charname here
		-- State swap for hammer spin
		if P_IsObjectOnGround(player.mo) -- If you're on the ground...
		and not (player.mo.state == S_AMYRE_HAMMERSPIN) -- ...and you're not spinning...
		and player.spintapping == true -- ...and you're tapping Custom 1...
		and player.speed > 4*FRACUNIT -- ...and your speed is higher than 4...
		and player.hammerspincooldown == 0
			player.mo.state = S_AMYRE_HAMMERSPIN -- ...you'll enter spin state!
			S_StartSound(player.mo, sfx_s3k42, player)
		end
		if(player.mo.state == S_AMYRE_HAMMERSPIN)
		or(player.mo.peelout == 1 or player.mo.peelouttimer >= 31)
			player.charflags = $|SF_CANBUSTWALLS
		else
			player.charflags = $&~SF_CANBUSTWALLS
		end
	end
end)
local function HammerSpinKill(touchedmobj, mobj)
	local player = mobj.player
	if not player return end
	if mobj.z + mobj.height < touchedmobj.z return end
	if mobj.z > touchedmobj.z return end
	if (player.mo.skin == "amyre")
	and (touchedmobj.flags & (MF_ENEMY|MF_BOSS))
	and (player.mo.state == S_AMYRE_HAMMERSPIN)
		P_DamageMobj(touchedmobj, mobj, mobj)
		S_StartSound(player.mo, sfx_s3k8b, player)
		return true
	elseif (player.mo.skin == "amyre")
	and (touchedmobj.flags & (MF_MONITOR))
	and (player.mo.state == S_AMYRE_HAMMERSPIN)
		P_KillMobj(touchedmobj, mobj, mobj)
		S_StartSound(player.mo, sfx_s3k8b, player)
		return true
	end
end
addHook("MobjCollide", HammerSpinKill)
-- Spike breaking hook
addHook("MobjCollide", function(thing, tmthing)
  if (tmthing.skin ~= "amyre" or not tmthing.player) then return end -- return end if you're not that skin or you aren't a skin
  if thing.z + thing.height < tmthing.z + tmthing.momz or thing.z > tmthing.z + tmthing.momz + tmthing.height then return nil end -- return nil end if that's true, i forgot what this checks
  local p = tmthing.player -- localing p as player
  if(p.mo.state == S_AMYRE_HAMMERSPIN) then -- If you're spinning, you will have the following effects:
    P_KillMobj(thing, tmthing, tmthing, nil, nil) -- You'll "kill" the specified object.
  end
end, MT_SPIKE) -- The specified object is MT_SPIKE in this case.