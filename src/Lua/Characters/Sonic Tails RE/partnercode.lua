addHook("ThinkFrame", function(player)
	for player in players.iterate
		if players[0] and players[0].mo -- The player should be valid.
		and players[1] and players[1].mo -- The bot too.
			if (((players[0].mo.skin == "sonicre") and (players[1].mo.skin == "tailsre"))
                or ((players[0].mo.skin == "tailsre") and (players[1].mo.skin == "sonicre")))
			and(players[1].bot == 1)
				if players[0].powers[pw_super]
				and not(players[1].powers[pw_super])
					P_DoSuperTransformation(players[1], true)
				elseif not(players[0].powers[pw_super])
				and(players[1].powers[pw_super])
					players[1].powers[pw_super] = 0
					players[1].mo.color = players[1].skincolor
				end	
			end
			if ((players[0].mo.skin == "tailsre") and (players[1].mo.skin == "sonicre"))
			and(players[1].bot == 1)
				players[0].tailsrespindashmode = true
			else
				players[0].tailsrespindashmode = false
			end
		end
	end
end)
