-- Skating SOC recreation by TeriosSonic
-- Check the RUN frames and compare ingame to see how the animation's organized.
-- This version uses 4 running sprites like the original, but it has a better
-- looking animation.
-- You also need the DSSKATES lump which is the skating sound.
freeslot(
	"sfx_skates",
	"S_SHADOWRE_SKATE1",
	"S_SHADOWRE_SKATE2",
	"S_SHADOWRE_SKATE3",
	"S_SHADOWRE_SKATE4",
	"S_SHADOWRE_SKATE5",
	"S_SHADOWRE_SKATE6",
	"SPR2_SKT1",
	"SPR2_SKT2",
	"SPR2_SKT3",
	"SPR2_SKT4"
)

sfxinfo[sfx_skates] = {
	singular = true,
	caption = "Skating"
}

states[S_SHADOWRE_SKATE1] = {SPR_PLAY, SPR2_SKT1, 3, nil, nil, nil, S_SHADOWRE_SKATE2}
states[S_SHADOWRE_SKATE2] = {SPR_PLAY, SPR2_SKT2, 12, nil, nil, nil, S_SHADOWRE_SKATE3}
states[S_SHADOWRE_SKATE3] = {SPR_PLAY, SPR2_SKT1, 3, nil, nil, nil, S_SHADOWRE_SKATE4}
states[S_SHADOWRE_SKATE4] = {SPR_PLAY, SPR2_SKT3, 3, nil, nil, nil, S_SHADOWRE_SKATE5}
states[S_SHADOWRE_SKATE5] = {SPR_PLAY, SPR2_SKT4, 12, nil, nil, nil, S_SHADOWRE_SKATE6}
states[S_SHADOWRE_SKATE6] = {SPR_PLAY, SPR2_SKT3, 3, nil, nil, nil, S_SHADOWRE_SKATE1}

addHook("ThinkFrame", function()
	for player in players.iterate do
		if not (player.mo and (player.mo.skin == "shadowre" or player.mo.skin == "ssnshadow")) then return end
		
		if (player.mo.state == S_SHADOWRE_SKATE1 or player.mo.state == S_SHADOWRE_SKATE4)
		and (player.skatesound == nil) then -- ...and the skate sound hasn't played...
			S_StartSound(player.mo, sfx_skates, player) -- ...then play the sound!
			player.skatesound = true -- Now you played the sound.
		end
		
		if not(player.mo.state == S_SHADOWRE_SKATE1)
		and not(player.mo.state == S_SHADOWRE_SKATE4) then
			player.skatesound = nil
		end
		
		if not(player.mo.state == S_SHADOWRE_SKATE1)
		and not(player.mo.state == S_SHADOWRE_SKATE2)
		and not(player.mo.state == S_SHADOWRE_SKATE3)
		and not(player.mo.state == S_SHADOWRE_SKATE4)
		and not(player.mo.state == S_SHADOWRE_SKATE5)
		and not(player.mo.state == S_SHADOWRE_SKATE6) then
			S_StopSoundByID(player.mo, sfx_skates) -- ...stop the skate sound.
		end
		
		if player.mo.state == S_PLAY_RUN
		and not(player.powers[pw_super]) then
			player.mo.state = S_SHADOWRE_SKATE1
		end
		
		if (player.mo.state > S_SHADOWRE_SKATE1 and player.mo.state < S_SHADOWRE_SKATE6)
		and (player.speed < player.runspeed) then
			player.mo.state = S_PLAY_WALK
		end
	end
end)
			