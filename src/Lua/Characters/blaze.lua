--I have a soft spot for this one, so here's something to make this Blaze more fun to play as!
--Golden Shine
-- Edited by Zippy_Zolton to add a super/hyper buff and fix spin dash
-- Edited by TeriosSonic to make her more compatible with models.
-- Edited by Ashi to improve readability and formatting

addHook("PlayerThink", function(p)
	if not (p and p.mo.skin == "ssnblaze") then return end

	if p.powers[pw_super] then
		p.charflags = $1 | SF_DASHMODE
	else
		p.charflags = $ & ~SF_DASHMODE
	end

	if p.mo.state == S_PLAY_FLOAT
	or p.mo.state == S_PLAY_FLOAT_RUN then
		p.mo.state = S_PLAY_ROLL
		p.floating = true
	end

	if p.floating
	and (not (p.cmd.buttons & BT_JUMP)
	or P_IsObjectOnGround(p.mo)
	or p.powers[pw_justsprung]
	or(p.playerstate == PST_DEAD)) then
		p.floating = nil
	end

	if p.floating
	or ((p.pflags & PF_SPINNING) and p.mo.state == S_PLAY_ROLL) and not (p.pflags & PF_JUMPED) or p.dashmode > 3*TICRATE then
		p.mo.ghs2 = P_SpawnGhostMobj(p.mo)
		p.mo.ghs2.tics = 5
		P_RadiusAttack(p.mo, p.mo, 120*FRACUNIT)

		if (p.hypermode or (p.powers[pw_super] and p.hyper and p.hyper.capable)) then
			p.mo.ghs = P_SpawnMobj(p.mo.x+P_RandomRange(-20, 20)*FRACUNIT, p.mo.y+P_RandomRange(-20, 20)*FRACUNIT, p.mo.z+P_RandomRange(-10, 40)*FRACUNIT, MT_THOK)
			p.mo.ghs.sprite = SPR_FLME
			p.mo.ghs.frame = A|(TR_TRANS10+(P_RandomRange(2,7)*FRACUNIT))
			p.mo.ghs.scale = p.mo.scale/P_RandomRange(1,4)
			p.mo.ghs.momz = P_RandomRange(0, 5)*FRACUNIT
			p.mo.ghs.colorized = true
			p.mo.ghs.color = p.mo.color
		else
			p.mo.ghs = P_SpawnMobj(p.mo.x+P_RandomRange(-20, 20)*FRACUNIT, p.mo.y+P_RandomRange(-20, 20)*FRACUNIT, p.mo.z+P_RandomRange(-10, 40)*FRACUNIT, MT_THOK)
			p.mo.ghs.sprite = SPR_FLME
			p.mo.ghs.frame = A|(TR_TRANS10+(P_RandomRange(2,7)*FRACUNIT))
			p.mo.ghs.scale = p.mo.scale/P_RandomRange(1,4)
			p.mo.ghs.momz = P_RandomRange(0, 5)*FRACUNIT	
		end

		if (p.cmd.forwardmove or p.cmd.sidemove) then -- and p.secondjump -- Ehh, why not. Let's keep the gradual spindash speed increase. Remove it // if you want this to be for her float only.
			if (p.speed and (p.speed < 20*FRACUNIT)) and p.secondjump  then
			P_Thrust(p.mo, R_PointToAngle2(p.mo.x, p.mo.y, p.mo.x+p.mo.momx, p.mo.y+p.mo.momy), 3*FRACUNIT)
			elseif (p.speed and (p.speed < 50*FRACUNIT)) then
			P_Thrust(p.mo, R_PointToAngle2(p.mo.x, p.mo.y, p.mo.x+p.mo.momx, p.mo.y+p.mo.momy), 45355)
			elseif (p.speed and (p.speed < 80*FRACUNIT)) then
			P_Thrust(p.mo, R_PointToAngle2(p.mo.x, p.mo.y, p.mo.x+p.mo.momx, p.mo.y+p.mo.momy), 15355)
			end
		end

		if not p.mo.blnetsfx then
			S_StartSound(p.mo, sfx_s3k7e)
			S_StartSound(p.mo, sfx_s3k7f)
			p.mo.blnetsfx = true
		end
	elseif p.mo.blnetsfx then
		p.mo.blnetsfx = false
	end

	if (p.pflags & PF_SPINNING) and not (p.pflags & PF_JUMPED)
	or p.floating then
		p.charflags = $|SF_CANBUSTWALLS
	else
		p.charflags = $&~SF_CANBUSTWALLS
	end
end)