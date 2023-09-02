-- Stompdash by TeriosSonic
-- Based off of Sonic GT's Stomp and Bullet Dash [not named like that to not confuse with JunioSonic's ability]
-- Freeslottin'
freeslot("SPR_STPD", "S_MIGHTYRE_STOMPDASH")
-- State configuration
states[S_MIGHTYRE_STOMPDASH] = {SPR_STPD, A, -1, nil, nil, nil, S_PLAY_FALL}
-- AbilitySpecial hook
addHook("AbilitySpecial", function(player)
	if not (player.mo.skin == "mightyre") return end
	if P_PlayerInPain(player) return end
	if P_IsObjectInGoop(player.mo) return end
	if (player.hammer == true) return end
	if (player.atwall == 0)
		S_StartSound(player.mo, sfx_zoom)
		player.mo.state = S_MIGHTYRE_STOMPDASH
		player.stompdash = true
		return true
	end
end)
-- Main ThinkFrame hook
addHook("ThinkFrame", function(player)
	for player in players.iterate
		if not player.mo return end
		if player.mo.skin == "mightyre"
-- Setting some values here
			if player.stompdashspeed == nil
				player.stompdashspeed = 0
			end
-- Secret sound change
			if player.randomstompsound == nil
				player.randomstompsound = 0
			elseif player.randomstompsound == 10000
				player.randomstompsound = 0
			else
				player.randomstompsound = $ + 1
			end
-- Main ability effects
			if not (player.stompdash == nil)
				if P_IsObjectOnGround(player.mo) and not (player.stompdash == nil)
					for x=player.mo.x,player.mo.x+player.mo.radius,player.mo.radius
						for y=player.mo.y,player.mo.y+player.mo.radius,player.mo.radius
							local ss = R_PointInSubsector(x,y)
							for fof in ss.sector.ffloors()
								if (fof.flags & FF_BUSTUP) and (fof.flags & FF_EXISTS)
									if (player.mo.z+player.mo.momz==fof.topheight or player.mo.z+player.mo.height+player.mo.momz==fof.bottomheight or (player.mo.eflags & MFE_VERTICALFLIP and (player.mo.z+player.mo.momz==fof.bottomheight or player.mo.z-player.mo.height-player.mo.momz==fof.topheight)))
										EV_CrumbleChain(ss.sector, fof)
										player.mo.state = S_MIGHTYRE_STOMPDASH
										player.stompdash = true
										player.stompdashspeed = 60
									end
								end
							end
						end
					end
				end
				if P_IsObjectOnGround(player.mo)
					if not (player.stompdropdash == nil)
						P_InstaThrust(player.mo, player.mo.angle,max(player.stompdashspeed*FRACUNIT,player.speed))
						S_StartSound(player.mo, sfx_s3kb6)
						S_StartSound(player.mo, sfx_pstop)
						S_StopSoundByID(player.mo, sfx_spin)
						player.stompdashspeed = 0
						player.stompdash = nil
						player.stompdropdash = nil
						player.mo.state = S_PLAY_ROLL
					else
						S_StartSound(player.mo, sfx_pstop)
						player.mo.state = S_PLAY_WALK
						if player.randomstompsound == 20
							S_StartSound(player.mo, sfx_bsnipe)
							P_NukeEnemies(player.mo, player.mo, 1536*FRACUNIT)
						else
							P_NukeEnemies(player.mo, player.mo, 384*FRACUNIT)
						end
						player.stompdashspeed = 0
						player.stompdash = nil
						player.stopstompdropdash = nil
					end
				end
				if (player.powers[pw_carry] ~= CR_NONE) or (player.powers[pw_justsprung]) or (P_IsObjectInGoop(player.mo)) or (player.mo.health == 0) or (player.cling == true) or (player.atwall == 1)
					player.stompdash = nil
					player.stompdropdash = nil
					player.stopstompdropdash = nil
					player.stompdashspeed = 0
					if (P_IsObjectInGoop(player.mo))
						player.mo.state = S_PLAY_FALL
					elseif (player.powers[pw_justsprung])
						player.mo.momz = $ * 125/100
						S_StartSound(player.mo, sfx_sprong)
					end
				end
				if not (player.stompdropdash == nil)
					local ghost = P_SpawnGhostMobj(player.mo)
					ghost.spritexscale = player.mo.spritexscale
					ghost.spriteyscale = player.mo.spriteyscale
					ghost.fuse = 4
					ghost.color = SKINCOLOR_SKY
					if not (player.cmd.buttons & BT_USE)
						player.stompdropdash = nil
						player.stopstompdropdash = true
					end
				else
					local ghost = P_SpawnGhostMobj(player.mo)
					ghost.spritexscale = player.mo.spritexscale
					ghost.spriteyscale = player.mo.spriteyscale
					ghost.fuse = 4
					ghost.color = player.mo.color
				end
				if player.cmd.buttons & BT_USE
				and player.stompdropdash == nil
				and player.stopstompdropdash == nil
					player.stompdropdash = true
				end
				player.stompdashspeed = $ + 5
				P_SetObjectMomZ(player.mo, (player.stompdashspeed*FRACUNIT)/-1, false)
			end
-- 2.2.9 exclusive effects n' shit [first creating the values just in case you're playing 2.2.8]
			if not player.mo.spritexscale
			or player.mo.state ~= S_MIGHTYRE_STOMPDASH
				player.mo.spritexscale = FRACUNIT
			end
			if not player.mo.spriteyscale
			or player.mo.state ~= S_MIGHTYRE_STOMPDASH
				player.mo.spriteyscale = FRACUNIT
			end
			if player.mo.state == S_MIGHTYRE_STOMPDASH
				if player.mo.spritexscale > FRACUNIT-(FRACUNIT/3)
					player.mo.spritexscale = $ - FRACUNIT/10
				end
				if player.mo.spriteyscale < FRACUNIT + (FRACUNIT/2)
					player.mo.spriteyscale = $ + FRACUNIT/10
				end
			end
		end
	end
end)