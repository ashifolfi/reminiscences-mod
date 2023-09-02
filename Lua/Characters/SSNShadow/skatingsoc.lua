-- Skating SOC recreation by TeriosSonic
-- Check the RUN frames and compare ingame to see how the animation's organized.
-- This version uses 4 running sprites like the original, but it has a better
-- looking animation.
-- You also need the DSSKATES lump which is the skating sound.
addHook("ThinkFrame", do
	for player in players.iterate
		if not player.mo return end -- The player should be valid.
		if player.mo.skin == "ssnshadow" -- charname goes here
			if(player.mo.state == S_SHADOWRE_SKATE1 or player.mo.state == S_SHADOWRE_SKATE4)
			and(player.skatesound == nil) -- ...and the skate sound hasn't played...
				S_StartSound(player.mo, sfx_skates, player) -- ...then play the sound!
				player.skatesound = true -- Now you played the sound.
			end
			if not(player.mo.state == S_SHADOWRE_SKATE1)
			and not(player.mo.state == S_SHADOWRE_SKATE4)
				player.skatesound = nil
			end
			if not(player.mo.state == S_SHADOWRE_SKATE1)
			and not(player.mo.state == S_SHADOWRE_SKATE2)
			and not(player.mo.state == S_SHADOWRE_SKATE3)
			and not(player.mo.state == S_SHADOWRE_SKATE4)
			and not(player.mo.state == S_SHADOWRE_SKATE5)
			and not(player.mo.state == S_SHADOWRE_SKATE6)
				S_StopSoundByID(player.mo, sfx_skates) -- ...stop the skate sound.
			end
			if player.mo.state == S_PLAY_RUN
			and not(player.powers[pw_super])
				player.mo.state = S_SHADOWRE_SKATE1
			end
			if (player.mo.state > S_SHADOWRE_SKATE1 and player.mo.state < S_SHADOWRE_SKATE6)
			and(player.speed < player.runspeed)
				player.mo.state = S_PLAY_WALK
			end
		end
	end
end)
			