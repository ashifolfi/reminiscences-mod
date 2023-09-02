-- Original WallJump code from SSNMighty
//Walljump lua first so we can check if the player is clinging or not first
addHook("ThinkFrame", do
	for player in players.iterate
		if (player.mo and player.mo.skin == "mightyre")
			//if not (player.atwall)
				player.atwall = 0
			//end
			if not (player.cling)
				player.cling = false
			end
			if not (player.clingprev)
				player.clingprev = false
			end
			if not (player.bounce)
				player.bounce = false
			end
			if player.bounce
			and P_IsObjectOnGround(player.mo)
				player.bounce = false
			end
			if (player.mo) //Fixes spectating, and possibly other things
				//Finding walls (not FOFs)
				local wall = R_PointInSubsector(player.mo.x+FixedMul(26*FRACUNIT, cos(player.mo.angle)), player.mo.y+FixedMul(26*FRACUNIT, sin(player.mo.angle))).sector
				local fheight = wall.floorheight
				local cheight = wall.ceilingheight

				if wall.f_slope then
					fheight = P_GetZAt(wall.f_slope, player.mo.x + player.mo.momx, player.mo.y + player.mo.momy)
				end
				if wall.c_slope then
					cheight = P_GetZAt(wall.c_slope, player.mo.x + player.mo.momx, player.mo.y + player.mo.momy)
				end
				
				if (fheight > player.mo.z) or ((cheight <= player.mo.height+player.mo.z) and not (fheight == cheight)/* and (wall.ceilingpic == "F_SKY1")*/) //This last bit seems to be broken...
					player.atwall = 1
				end
				//FOFs can be walls too, so lets check for those
				for wall in wall.ffloors()
					if (player.mo.z <= wall.topheight) and (player.mo.height+player.mo.z > wall.bottomheight)
						and(wall.flags & FF_BLOCKPLAYER) //Don't want the player to cling to water. That would be stupid
						player.atwall = $1 + 1
					end		
				end
				if(player.atwall <= 0)
					if (player.cling)
						player.pflags = $1&~PF_JUMPED
						player.mo.state = S_PLAY_FALL
					end
					player.cling = false
				end	
				if (P_IsObjectOnGround(player.mo))
					player.cling = false
				end	
				//This allows sonic to thok away from a wall. You can remove this if you dont want your character to do this.
				//Lazy checks
				if (player.powers[pw_carry] == CR_NONE)
				and not (player.pflags & PF_THOKKED) 
				and not (player.charability2 == CA2_MULTIABILITY)
					//If you're clinging to a wall
					if (player.cling)
						and not (player.cmd.buttons & BT_JUMP)
						if (player.powers[pw_underwater])
							P_SetObjectMomZ(player.mo, 10*FRACUNIT)
						else
							P_SetObjectMomZ(player.mo, 15*FRACUNIT)
						end
						S_StartSound(player.mo, sfx_jump)
						player.cling = false
						if (player.charability2 == CA2_SPINDASH)
							player.mo.state = S_PLAY_ROLL //L
						else
							player.mo.state = S_PLAY_SPRING //P
						end
						player.jumping = false
						P_InstaThrust(player.mo, player.mo.angle, -player.actionspd/3) //Devided by 3 for sonic, but you can remove this for your character
						player.mo.angle = R_PointToAngle2(0, 0, player.mo.momx, player.mo.momy)
					end
					//Cling onto a wall
					if (player.atwall > 0)
						and (((player.mo.momz < -3*FRACUNIT+1) and not (player.mo.flags2 & MF2_OBJECTFLIP)) or ((player.mo.momz > 3*FRACUNIT-1) and (player.mo.flags2 & MF2_OBJECTFLIP)))
						and (player.pflags & PF_JUMPED)
						and (player.cmd.buttons & BT_JUMP)
						and not (player.exiting)
						P_SetObjectMomZ(player.mo, -3*FRACUNIT)
						player.mo.momx = $1 / 2
						player.mo.momy = $1 / 2
						player.mo.state = S_PLAY_CLING //F
						player.cling = true
						if (player.clingprev == false)
							S_StartSound(player.mo,sfx_s3k4a)
						end
						if not (S_SoundPlaying(player.mo,sfx_s3k7e))
							S_StartSound(player.mo, sfx_s3k7e)
						end
					end
				end			
				//Movement fix
				if (player.cling)
					player.normalspeed = 0
				else 
					player.normalspeed = skins[player.mo.skin].normalspeed
				end
				player.clingprev = player.cling	
			end		
		end
	end
end)