-- SallyRE's moveset by TeriosSonic
-- Inspired [but not ported directly] from SallyRE's moveset in 2.1.
-- Edited by Trystan to have a cool dust effect!
-- Freeslottin'
freeslot("S_SALLYRE_SLIDE")
-- Custom states
states[S_SALLYRE_SLIDE] = {SPR_PLAY, SPR2_MLEE, -1, nil, nil, nil, S_PLAY_STND}
-- Hook for making Sally enter rolling state after doing the air sommersault [jump thok].
addHook("AbilitySpecial", function(player)
    if player.mo and player.mo.skin == "sallyre" -- charname here
	and player.pflags & PF_JUMPED -- If you jumped...
	and not(player.pflags & PF_THOKKED) -- ...and you didn't use the air sommersault yet...
	and not(player.mo.state == S_PLAY_ROLL) -- ...and you're not in roll state...
		player.mo.state = S_PLAY_ROLL -- ...enter roll state!
		player.pflags = $|PF_SPINNING
		player.pflags = $&~PF_JUMPED
	end
end)

-- Hook for sliding.
addHook("ThinkFrame", function(player)
	for player in players.iterate
		if not player.mo return end -- The player should be valid.
		if player.mo.skin == "sallyre" -- charname here
		and(player.mo.state == S_PLAY_ROLL or player.mo.state == S_PLAY_WALK or player.mo.state == S_PLAY_RUN) -- If you're in roll state [or any of these states that interfere with pain state for some reason]...
		and(player.pflags & PF_SPINNING) -- ...and you're ''spinning'' [flag used for the sliding move]...
		and(P_IsObjectOnGround(player.mo)) -- ...and you're on the ground...
			player.mo.state = S_SALLYRE_SLIDE -- ...enter slide state!
			P_SpawnSkidDust(player, 20*FRACUNIT)
			player.sallyslide = true -- This tells the game you're doing Sally's slide move.
		end
		if player.sallyslide == nil -- If the sallyslide value doesn't exist...
			player.sallyslide = false -- ...create it on false!
		end
		if player.sallyslide == true -- If the sallyslide value is true...
		and not(player.pflags & PF_SPINNING) -- ...but you're not actually sliding...
			player.sallyslide = false -- ...change the value to false!
		end
		-- sliding dust thingy
		if player.mo.state == S_SALLYRE_SLIDE --are you in the slide state?
		player.sallyslide = true -- and actually sliding?
			P_SpawnSkidDust(player, 20*FRACUNIT) -- SPAWN THE DUST!
		end
	end
end)

-- Hook for the air sommersault.
addHook("JumpSpecial", function(player)
	if player.mo and player.mo.skin == "sallyre" -- charname here
	and P_IsObjectOnGround(player.mo) -- If you're on the ground...
	and(player.mo.state == S_PLAY_SPINDASH or player.sallyslide == true) -- ...and you're crouching or sliding...
		P_SetObjectMomZ(player.mo, FRACUNIT*7, false) -- ...thrust the player upwards so they get height...
		P_InstaThrust(player.mo, player.mo.angle, 35*FRACUNIT) -- ...and forwards so they get speed!
		player.mo.state = S_PLAY_ROLL -- You'll enter roll state.
		S_StartSound(player.mo, sfx_thok, player) -- You'll play the thok [sommersault] sound effect.
		return true -- This will cancel the normal jump.
	end
end)