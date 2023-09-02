-- Edited by TeriosSonic to have tailswipe while walking, more like in SA1.
-- Custom animation made by Spectro, coded in by TeriosSonic
freeslot("S_TAILSRE_SWIPE")
states[S_TAILSRE_SWIPE] = {SPR_PLAY, SPR2_MLEE, -1, nil, nil, nil, nil}
addHook("PlayerThink", function(player)
	if not (player.spinner)
		player.spinner = 0
	end
	if not (player.tailswipe)
		player.tailswipe = 0
	end
-- no warning pls
	if not player.mo return end
	if player.exiting return end
	if (player.mo.skin == "tailsre")
		if (player.speed > 23*FRACUNIT)
		or (player.bot == 1)//Swiper no Swiping
		or (player.tailsrespindashmode)
			player.charability2 = CA2_SPINDASH
		else
			player.charability2 = CA2_NONE
		end
		
		//Tail Swipe Start
		if (player.pflags & PF_USEDOWN)
		and P_IsObjectOnGround(player.mo)
		and (player.speed < 24*FRACUNIT)
		and not (player.bot == 1)//SWIPER NO SWIPING
		and not (player.skidtime > 0)//Friggin Spindash
		and not (player.tailsrespindashmode)
		or (player.tailswipe == 1)
		and (player.pflags & PF_USEDOWN)
			player.tailswipe = 1
		end
		
		//Ending Tail Swipe
		if not (player.pflags & PF_USEDOWN)
		or not P_IsObjectOnGround(player.mo)
			player.tailswipe = 0
		end
		
		//What to do
		if (player.tailswipe == 1)
			player.mo.state = S_TAILSRE_SWIPE
			player.jumpfactor = 0
			player.normalspeed = 20*FRACUNIT
			//player.pflags = $|PF_SPINNING
			player.spinner = ($ % 7) + 1
			if (player.spinner > 7)
				player.spinner = 0
			end
			player.drawangle = player.spinner * ANGLE_45
		end
		
		//Return to normal
		if (player.tailswipe == 0)
			if player.mo.state == S_TAILSRE_SWIPE
				player.mo.state = S_PLAY_RUN
			end
			player.jumpfactor = skins[player.mo.skin].jumpfactor
			player.normalspeed = skins[player.mo.skin].normalspeed
		end
	end
end)

local function advTailSwipe(enemy, mobj)
	if not mobj.player return end
	if mobj.z + mobj.height < enemy.z return end
	if mobj.z > enemy.z return end
	if (enemy.flags & (MF_ENEMY|MF_BOSS))
	and (mobj.player.tailswipe == 1)
	and not (mobj.player.powers[pw_super])
	and not (mobj.player.powers[pw_invulnerability])
		P_DamageMobj(enemy, mobj, mobj)
		return true
	elseif (mobj.player.tailswipe == 1)
	and (enemy.flags & (MF_MONITOR))
		P_KillMobj(enemy, mobj, mobj)
		return true
	end
end

addHook("MobjCollide", advTailSwipe)