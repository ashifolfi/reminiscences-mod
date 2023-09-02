-- Double Thok. Thok, thok!
-- Based off of Legacy Homing Thok by TeriosSonic
-- and Vbilities by Trystan
-- Merged and edited by TeriosSonic
addHook("AbilitySpecial", function(player)
    if player.mo.skin == "ssnshadow"
	and player.charability == CA_HOMINGTHOK
        if P_LookForEnemies(player)
            player.charability = CA_HOMINGTHOK
        elseif not (player.pflags & PF_THOKKED)
            P_InstaThrust(player.mo, player.mo.angle, player.actionspd/2)
			P_SpawnThokMobj(player)
			S_StartSound(player.mo, sfx_thok, player)
			player.mo.state = S_PLAY_JUMP
			player.pflags = $ | PF_THOKKED
			return true
        end
    end
end)
addHook("ThinkFrame", do
	for player in players.iterate
		if not player.mo return end -- The player should be valid.
		if player.mo.skin == "ssnshadow" -- charname goes here
			if player.mo.eflags & MFE_UNDERWATER
				player.thokspeed = player.actionspd/2
			else
				player.thokspeed = player.actionspd
			end
			if player.mo.state == S_PLAY_SPRING
			and (player.pflags & PF_JUMPED)
			and (player.pflags & PF_JUMPDOWN)
			and not (player.mo.eflags & MFE_SPRUNG)
				P_InstaThrust(player.mo, player.mo.angle, player.prevactionspd/3)
				P_SetObjectMomZ(player.mo, 10*FRACUNIT, false)
				player.mo.state = S_PLAY_JUMP
			elseif player.mo.state == S_PLAY_SPRING
			and (player.pflags & PF_JUMPED)
			and not (player.pflags & PF_JUMPDOWN)
			and not (player.mo.eflags & MFE_SPRUNG)
				player.mo.state = S_PLAY_JUMP
				player.mo.momx = 0
				player.mo.momy = 0
			end
			player.prevactionspd = player.actionspd
			if player.homing
				player.actionspd = skins[player.mo.skin].actionspd
			else
				player.actionspd = (player.speed+10*FRACUNIT)*2
			end
		end
	end
end)