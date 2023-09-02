-- SA1 Tails flight by TeriosSonic
-- Free to use as long as you credit me.
-- Remember to add the SF_MULTIABILITY flag to your char and set his actionspd to 150 [normal SA1 Tails flight]
addHook("PlayerThink", function(player)
	if player.mo and player.mo.valid -- The player should be valid.
	and player.mo.skin == "tailsre" -- char name here
		if player.powers[pw_super]
		and player.powers[pw_tailsfly] <= 2
			player.powers[pw_tailsfly] = 2
		elseif player.powers[pw_tailsfly] > 2*TICRATE -- If your flight timer is higher than 2 seconds...
		and not player.bot
			player.powers[pw_tailsfly] = 2*TICRATE -- ...it will be set to 2 seconds.
		elseif player.powers[pw_tailsfly] > 4*TICRATE -- If your flight timer is higher than 6 seconds...
			player.powers[pw_tailsfly] = 4*TICRATE
		end
		if player.bot == 1
			player.charflags = $ & ~SF_MULTIABILITY
		else
			player.charflags = $ |SF_MULTIABILITY
		end
	end
end)