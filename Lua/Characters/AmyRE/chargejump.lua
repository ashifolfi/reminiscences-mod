-- AmyRE's charged double jump by TeriosSonic
-- this thing was hard to code
-- Freeslottin'
freeslot("S_AMYRE_JUMPCHARGE", "sfx_amydbl")
-- Custom state for charging up so Amy spins faster while charging up
states[S_AMYRE_JUMPCHARGE] = {SPR_PLAY, SPR2_ROLL|FF_ANIMATE, -1, nil, 3, 3, S_PLAY_SPRING}
-- Double jump sfx for when you release the jump at second/third phase
sfxinfo[sfx_amydbl] = {
        singular = false,
        caption = "Double Jump"
}
-- Hook for making Amy enter charge state with the jump button
addHook("AbilitySpecial", function(player)
    if player.mo and player.mo.skin == "amyre" -- charname here
	and player.pflags & PF_JUMPED
	and not(player.pflags & PF_THOKKED)
	and not(player.mo.state == S_AMYRE_JUMPCHARGE)
		player.amyrestore = player.speed
		player.mo.state = S_AMYRE_JUMPCHARGE
		S_StartSound(player.mo, sfx_spndsh, player)
		return true
	end
end)
-- literally everything else from the script in one big hook
addHook("ThinkFrame", function(player)
	for player in players.iterate
		if not player.mo return end
		if player.mo.skin == "amyre"
			if player.amyrecharge == nil
				player.amyrecharge = 0
			end
			if player.powers[pw_super]
				player.amyrejumpphase1 = 15*FRACUNIT
				player.amyrejumpphase2 = 20*FRACUNIT
				player.amyrejumpphase3 = 25*FRACUNIT
			else
				player.amyrejumpphase1 = 10*FRACUNIT
				player.amyrejumpphase2 = 15*FRACUNIT
				player.amyrejumpphase3 = 20*FRACUNIT
			end
			if player.mo.state == S_AMYRE_JUMPCHARGE
				P_SetObjectMomZ(player.mo, 0, false)
				//P_InstaThrust(player.mo, player.mo.angle, 0) -- this line is the old stopping method, uncomment line for old system
				player.pflags = $ | PF_STASIS
				player.mo.momx = FixedMul($, FRACUNIT*88/100)
				player.mo.momy = FixedMul($, FRACUNIT*88/100) -- these three lines are the new stopping method, comment out for old system
				player.amyrecharge = $ + 1
				if player.amyrestore > 45*FRACUNIT
					player.peelout = 1
				end
				if not(player.cmd.buttons & BT_JUMP)
					if player.amyrecharge > 18
						P_SetObjectMomZ(player.mo, player.amyrejumpphase2, false)
						P_InstaThrust(player.mo, player.mo.angle, player.amyrestore/2)
						if player.amyrestore > 90*FRACUNIT
							player.mo.peelout = 1
						end
						player.mo.state = S_PLAY_SPRING
						player.pflags = $ & ~PF_JUMPED
						player.amyrecharge = 0
						player.amyrestore = 0
						S_StopSoundByID(player.mo, sfx_cdfm40)
						S_StartSound(player.mo, sfx_amydbl, player)
						if player.powers[pw_super]
							S_StartSound(player.mo, sfx_zoom, player)
						end
					elseif player.amyrecharge < 18
						P_SetObjectMomZ(player.mo, player.amyrejumpphase1, false)
						P_InstaThrust(player.mo, player.mo.angle, player.amyrestore)
						if player.amyrestore > 45*FRACUNIT
							player.mo.peelout = 1
						end
						player.mo.state = S_PLAY_SPRING
						player.pflags = $ & ~PF_JUMPED
						player.amyrecharge = 0
						player.amyrestore = 0
						S_StopSoundByID(player.mo, sfx_spndsh)
						if player.powers[pw_super]
							S_StartSound(player.mo, sfx_amydbl, player)
						else
							S_StartSound(player.mo, sfx_ngjump, player)
						end
					end
				end
				if player.amyrecharge == 18
					P_SpawnThokMobj(player)
					S_StartSound(player.mo, sfx_cdfm40, player)
				end
				if player.amyrecharge == 35
					P_SpawnThokMobj(player)
					P_SetObjectMomZ(player.mo, player.amyrejumpphase3, false)
					player.mo.state = S_PLAY_SPRING
					player.pflags = $ & ~PF_JUMPED
					player.amyrecharge = 0
					player.amyrestore = 0
					S_StartSound(player.mo, sfx_amydbl, player)
					S_StartSound(player.mo, sfx_zoom, player)
					if player.powers[pw_super]
						P_NukeEnemies(player.mo, player.mo, 768*FRACUNIT)
						S_StartSound(player.mo, sfx_kc4d, player)
					end
				end
			end
		end
	end
end)