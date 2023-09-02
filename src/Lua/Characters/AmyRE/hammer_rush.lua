-- Peelout edited by TeriosSonic, to make the player able to break walls, spikes and enemies with the peelout.
freeslot("S_PLAY_PEEL1", "S_PLAY_PEEL2", "S_PLAY_PEEL3", "S_PLAY_PEEL4", "S_PLAY_PWALK1", "S_PLAY_PWALK2", "S_PLAY_PWALK3", "S_PLAY_PWALK4", "S_PLAY_PWALK5", "S_PLAY_PWALK6", "S_PLAY_PWALK7", "S_PLAY_PWALK8", "S_PLAY_PWALK9", "S_PLAY_PWALK10", "S_PLAY_PWALK11", "S_PLAY_PWALK12", "S_PLAY_PWALK13", "S_PLAY_PWALK14", "S_PLAY_PWALK15", "S_PLAY_PWALK16", "S_PLAY_SPEEL1", "S_PLAY_SPEEL2", "S_PLAY_SPEEL3", "S_PLAY_SPEEL4")
states[S_PLAY_PWALK1] = {SPR_PLAY, SPR2_WALK1, 4, nil, 0, 0, S_PLAY_PWALK2}
states[S_PLAY_PWALK2] = {SPR_PLAY, SPR2_WALK2, 4, nil, 0, 0, S_PLAY_PWALK3}
states[S_PLAY_PWALK3] = {SPR_PLAY, SPR2_WALK3, 4, nil, 0, 0, S_PLAY_PWALK4}
states[S_PLAY_PWALK4] = {SPR_PLAY, SPR2_WALK4, 3, nil, 0, 0, S_PLAY_PWALK5}
states[S_PLAY_PWALK5] = {SPR_PLAY, SPR2_WALK5, 3, nil, 0, 0, S_PLAY_PWALK6}
states[S_PLAY_PWALK6] = {SPR_PLAY, SPR2_WALK6, 3, nil, 0, 0, S_PLAY_PWALK7}
states[S_PLAY_PWALK7] = {SPR_PLAY, SPR2_WALK7, 2, nil, 0, 0, S_PLAY_PWALK8}
states[S_PLAY_PWALK8] = {SPR_PLAY, SPR2_WALK8, 2, nil, 0, 0, S_PLAY_PWALK9}
states[S_PLAY_PWALK9] = {SPR_PLAY, SPR2_WALK1, 2, nil, 0, 0, S_PLAY_PWALK10}
states[S_PLAY_PWALK10] = {SPR_PLAY, SPR2_WALK2, 1, nil, 0, 0, S_PLAY_PWALK11}
states[S_PLAY_PWALK11] = {SPR_PLAY, SPR2_WALK3, 1, nil, 0, 0, S_PLAY_PWALK12}
states[S_PLAY_PWALK12] = {SPR_PLAY, SPR2_WALK4, 1, nil, 0, 0, S_PLAY_PWALK13}
states[S_PLAY_PWALK13] = {SPR_PLAY, SPR2_WALK5, 1, nil, 0, 0, S_PLAY_PWALK14}
states[S_PLAY_PWALK14] = {SPR_PLAY, SPR2_WALK6, 1, nil, 0, 0, S_PLAY_PWALK15}
states[S_PLAY_PWALK15] = {SPR_PLAY, SPR2_WALK7, 1, nil, 0, 0, S_PLAY_PWALK16}
states[S_PLAY_PWALK16] = {SPR_PLAY, SPR2_WALK8, 1, nil, 0, 0, S_PLAY_PEEL1}
states[S_PLAY_PEEL1] = {SPR_PLAY, SPR2_DASH1, 1, nil, 0, 0, S_PLAY_PEEL2}
states[S_PLAY_PEEL2] = {SPR_PLAY, SPR2_DASH2, 1, nil, 0, 0, S_PLAY_PEEL3}
states[S_PLAY_PEEL3] = {SPR_PLAY, SPR2_DASH3, 1, nil, 0, 0, S_PLAY_PEEL4}
states[S_PLAY_PEEL4] = {SPR_PLAY, SPR2_DASH4, 1, nil, 0, 0, S_PLAY_PEEL1}
states[S_PLAY_SPEEL1] = {SPR_PLAY, SPR2_DASH1, 1, nil, 0, 0, S_PLAY_SPEEL2}
states[S_PLAY_SPEEL2] = {SPR_PLAY, SPR2_DASH2, 1, nil, 0, 0, S_PLAY_SPEEL3}
states[S_PLAY_SPEEL3] = {SPR_PLAY, SPR2_DASH3, 1, nil, 0, 0, S_PLAY_SPEEL4}
states[S_PLAY_SPEEL4] = {SPR_PLAY, SPR2_DASH4, 1, nil, 0, 0, S_PLAY_SPEEL1}


addHook("ThinkFrame", do
	for player in players.iterate
		if not player.mo return end
		if player.exiting return end
			if player.mo and player.mo.skin == "amyre"
			//CONS_Printf(player, player.mo.peelouttimer)
				player.actionspd = player.normalspeed
				if player.mo.state == S_PLAY_STND
					player.normalspeed = 36*FRACUNIT
				end
				if player.mo.peelouttimer == nil
					player.mo.peelouttimer = 0
				end
				if player.mo.peelout == nil
					player.mo.peelout = 0
				end
				if player.mo.peeloutrun == nil
					player.mo.peeloutrun = 0
				end
				if player.mo.peelsound == nil
					player.mo.peelsound = 0
				end
				if player.mo.peelsound2 == nil
					player.mo.peelsound2 = 0
				end
				if player.pflags & PF_SPINNING
					player.mo.peelouttimer = 0
				end
				if (P_PlayerInPain(player))
				or (player.playerstate == PST_DEAD)
					player.normalspeed = 36*FRACUNIT
					player.mo.peelouttimer = 0
					player.mo.peelout = 0
					player.mo.peeloutrun = 0
					player.mo.peelsound = 0
					player.mo.peeloutsound = 0
				end
				if P_IsObjectOnGround(player.mo)
				and player.speed == 0
				and not (player.pflags & PF_SPINNING)
				and player.cmd.buttons & BT_USE
			    and not (player.playerstate == PST_DEAD)
					if player.mo.peelsound == 0
						S_StartSound(player.mo, sfx_cdfm11)
						player.mo.peelsound = 1
						
					end
					if player.mo.peelouttimer < 60
						player.mo.peelouttimer = $1 + 1
					end
					player.normalspeed = 0
					player.pflags = $1|PF_STASIS
					if player.drawangle ~= player.mo.angle
						local diff = 0
						local factor = 0
						diff = player.mo.angle - player.drawangle
						factor = 8
						if diff > ANGLE_180
							diff = InvAngle(InvAngle(diff)/(factor or 1))
						else
							diff = $ / (factor or 1)
						end
						player.drawangle = $ + diff
					
					end
					if not (player.mo.eflags & MFE_GOOWATER) then
						for i=(leveltime%7)/2,(leveltime%7) do
							local particle = P_SpawnMobj(player.mo.x, player.mo.y,
							player.mo.z + ((player.mo.eflags & MFE_VERTICALFLIP)/MFE_VERTICALFLIP * (player.mo.height - mobjinfo[MT_SPINDUST].height)),
							MT_SPINDUST)
							if (player.powers[pw_shield] == SH_ELEMENTAL and not (player.mo.eflags & MFE_TOUCHWATER or player.mo.eflags & MFE_UNDERWATER)) then
								particle.state = S_SPINDUST_FIRE1
								particle.bubble = false
							elseif (player.mo.eflags & MFE_TOUCHWATER or player.mo.eflags & MFE_UNDERWATER) then
								particle.state = S_SPINDUST_BUBBLE1
								particle.bubble = true
							else
								particle.state = S_SPINDUST1
								particle.bubble = false
							end
					
							particle.target = player.mo
							particle.eflags = $1 | (player.mo.eflags & MFE_VERTICALFLIP)
							particle.scale = player.mo.scale*2/3
							P_SetObjectMomZ(particle, player.mo.peelouttimer*FRACUNIT/50+P_RandomByte()<<10, false)
							P_InstaThrust(particle, player.mo.angle+(P_RandomRange(-ANG30/FRACUNIT, ANG30/FRACUNIT)*FRACUNIT), FixedMul(-player.mo.peelouttimer*FRACUNIT/12-1*FRACUNIT-P_RandomByte()<<11, player.mo.scale))
							P_TryMove(particle, particle.x+particle.momx, particle.y+particle.momy, true)
						end
					end
				end
			if not (player.cmd.buttons & BT_USE) 
				if ((player.mo.peelouttimer >= 1) and (player.mo.peelouttimer <= 35) and not (player.powers[pw_super]))
				or ((player.mo.peelouttimer >= 1) and (player.mo.peelouttimer <= 14) and (player.powers[pw_super]))
					player.normalspeed = 36*FRACUNIT
					player.mo.state = 14
					player.mo.peelouttimer = 0
					player.mo.peelsound = 0
				end
			end
			
			if player.powers[pw_super] == 0
				if player.mo.peelouttimer >= 1
				and player.mo.peelouttimer <= 30
					if not (player.mo.state >= S_PLAY_PWALK1)
					and (player.mo.state <= S_PLAY_PWALK16)
						player.mo.state = S_PLAY_PWALK1
					end
				end
				if player.mo.peelouttimer >= 31
					if not ((player.mo.state >= S_PLAY_PEEL1) and (player.mo.state <= S_PLAY_PEEL4))
					or ((player.mo.state >= S_PLAY_PWALK1) and (player.mo.state <= S_PLAY_PWALK16))
						player.mo.state = S_PLAY_PEEL1
					end
				end
			else
				if player.mo.peelouttimer >= 1
				and player.mo.peelouttimer <= 14
					if not (player.mo.state >= S_PLAY_PWALK8)
					and (player.mo.state <= S_PLAY_PWALK16)
						player.mo.state = S_PLAY_PWALK8
					end
				end
				if player.mo.peelouttimer >= 15
					if not (player.mo.state >= S_PLAY_SPEEL1)
					and (player.mo.state <= S_PLAY_SPEEL4)
						player.mo.state = S_PLAY_SPEEL1
					end
				end
			end
			if not (player.cmd.buttons & BT_USE)
				if ((player.mo.peelouttimer >= 31) and not (player.powers[pw_super]))
				or ((player.mo.peelouttimer >= 15) and (player.powers[pw_super]))
					if player.mo.peelsound == 1
						player.mo.state = S_PLAY_DASH
						S_StartSound(player.mo, sfx_cdfm01)
						player.mo.peelsound = 0
						player.mo.peelout = 1
					end
					P_InstaThrust(player.mo, player.mo.angle, FixedMul(60*FRACUNIT, player.mo.scale))
					player.mo.peelouttimer = 0
					player.drawangle = player.mo.angle
				end
				
			end
			if player.speed > 45*FRACUNIT
			and player.mo.peelout == 1
				player.mo.peeloutrun = 1
				player.normalspeed = 60*FRACUNIT
				if player.mo.state == S_PLAY_RUN
					player.mo.state = S_PLAY_DASH
				end
			end
			if player.speed <= 45*FRACUNIT
			and player.mo.peeloutrun == 1
				player.mo.peelout = 0
				player.mo.peeloutrun = 0
				player.normalspeed = 36*FRACUNIT
				if player.mo.state == S_PLAY_DASH
					player.mo.state = S_PLAY_RUN
				end
			end
			if player.mo.peelout == 1
				local ghost = P_SpawnGhostMobj(player.mo)
				ghost.fuse = 4
				player.charflags = $1|SF_RUNONWATER
			else
				player.charflags = $1 & ~SF_RUNONWATER
			end
			if player.pflags & PF_JUMPED
				if ((player.mo.state >= S_PLAY_PWALK1) and (player.mo.state <= S_PLAY_PWALK16))
				or ((player.mo.state >= S_PLAY_PEEL1) and (player.mo.state <= S_PLAY_PEEL4))
				or ((player.mo.state >= S_PLAY_SPEEL1) and (player.mo.state <= S_PLAY_SPEEL2))
					player.mo.state = S_PLAY_ROLL
				end
				if player.normalspeed == 0*FRACUNIT
					player.normalspeed = 36*FRACUNIT
				end
				player.mo.peelouttimer = 0
				player.mo.peelsound = 0
				player.mo.peelsound2 = 0
			end
		end
	end
end)

-- EnemyHammering function [damaging enemies while charging peelout/dashing]
local function EnemyHammering(enemy, mobj)
	local player = mobj.player
	if not (player.mo.skin == "amyre")
		return false
	end
	if (enemy.flags & (MF_ENEMY|MF_BOSS))
	and (player.mo.peelout == 1 or player.mo.peelouttimer >= 31)
	and not (player.powers[pw_super])
	and not (player.powers[pw_invulnerability])
		P_DamageMobj(enemy, mobj, mobj)
		return true
	end
end

-- EnemyHammering hook
addHook("TouchSpecial", EnemyHammering)

-- Spike breaking hook
addHook("MobjCollide", function(thing, tmthing)
  if (tmthing.skin ~= "amyre" or not tmthing.player) then return end -- return end if you're not that skin or you aren't a skin
  if thing.z + thing.height < tmthing.z + tmthing.momz or thing.z > tmthing.z + tmthing.momz + tmthing.height then return nil end -- return nil end if that's true, i forgot what this checks
  local p = tmthing.player -- localing p as player
  if(p.mo.peelout == 1 or p.mo.peelouttimer >= 31) then -- If you're charging peelout/dashing, you will have the following effects:
    P_KillMobj(thing, tmthing, tmthing, nil, nil) -- You'll "kill" the specified object.
  end
end, MT_SPIKE) -- The specified object is MT_SPIKE in this case.

-- Wall breaking hook is on LUA_MLEE