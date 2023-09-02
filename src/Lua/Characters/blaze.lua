--I have a soft spot for this one, so here's something to make this Blaze more fun to play as!
--Golden Shine
-- Edited by Zippy_Zolton to add a super/hyper buff and fix spin dash
-- Edited by TeriosSonic to make her more compatible with models.
-- Refactored by Ashi to improve readability and fix questionable code.

addHook("MobjThinker", function(s)
if not s.player
return end
local p = s.player
	if s and s.skin == "ssnblaze"
		if p.powers[pw_super]
			p.charflags = $1 | SF_DASHMODE
		else
			p.charflags = $ & ~SF_DASHMODE
		end
		if s.state == S_PLAY_FLOAT
		or s.state == S_PLAY_FLOAT_RUN
			s.state = S_PLAY_ROLL
			p.floating = true
		end
		if p.floating
		and (not (p.cmd.buttons & BT_JUMP)
		or P_IsObjectOnGround(s)
		or p.powers[pw_justsprung]
		or(p.playerstate == PST_DEAD))
			p.floating = nil
		end
		if p.floating
		or ((p.pflags & PF_SPINNING) and p.mo.state == S_PLAY_ROLL) and not (p.pflags & PF_JUMPED) or p.dashmode > 3*TICRATE
			s.ghs2 = P_SpawnGhostMobj(s)
			s.ghs2.tics = 5
			P_RadiusAttack(s, s, 120*FRACUNIT)
			if (p.hypermode or (p.powers[pw_super] and p.hyper and p.hyper.capable))
				s.ghs = P_SpawnMobj(s.x+P_RandomRange(-20, 20)*FRACUNIT, s.y+P_RandomRange(-20, 20)*FRACUNIT, s.z+P_RandomRange(-10, 40)*FRACUNIT, MT_THOK)
				s.ghs.sprite = SPR_FLME
				s.ghs.frame = A|(TR_TRANS10+(P_RandomRange(2,7)*FRACUNIT))
				s.ghs.scale = s.scale/P_RandomRange(1,4)
				s.ghs.momz = P_RandomRange(0, 5)*FRACUNIT
				s.ghs.colorized = true
				s.ghs.color = p.mo.color
			else
				s.ghs = P_SpawnMobj(s.x+P_RandomRange(-20, 20)*FRACUNIT, s.y+P_RandomRange(-20, 20)*FRACUNIT, s.z+P_RandomRange(-10, 40)*FRACUNIT, MT_THOK)
				s.ghs.sprite = SPR_FLME
				s.ghs.frame = A|(TR_TRANS10+(P_RandomRange(2,7)*FRACUNIT))
				s.ghs.scale = s.scale/P_RandomRange(1,4)
				s.ghs.momz = P_RandomRange(0, 5)*FRACUNIT	
			end
			if (p.cmd.forwardmove or p.cmd.sidemove) // and p.secondjump --Ehh, why not. Let's keep the gradual spindash speed increase. Remove it // if you want this to be for her float only.
				if (p.speed and (p.speed < 20*FRACUNIT)) and p.secondjump 
				P_Thrust(s, R_PointToAngle2(s.x, s.y, s.x+s.momx, s.y+s.momy), 3*FRACUNIT)
				elseif (p.speed and (p.speed < 50*FRACUNIT))
				P_Thrust(s, R_PointToAngle2(s.x, s.y, s.x+s.momx, s.y+s.momy), 45355)
				elseif (p.speed and (p.speed < 80*FRACUNIT))
				P_Thrust(s, R_PointToAngle2(s.x, s.y, s.x+s.momx, s.y+s.momy), 15355)
				end
			end
			if not s.blnetsfx
			S_StartSound(s, sfx_s3k7e)
			S_StartSound(s, sfx_s3k7f)
			s.blnetsfx = true
			end
		elseif s.blnetsfx
			s.blnetsfx = false
		end
		if (p.pflags & PF_SPINNING) and not (p.pflags & PF_JUMPED)
		or p.floating
			p.charflags = $|SF_CANBUSTWALLS
		else
			p.charflags = $&~SF_CANBUSTWALLS
		end
	end
end, MT_PLAYER)