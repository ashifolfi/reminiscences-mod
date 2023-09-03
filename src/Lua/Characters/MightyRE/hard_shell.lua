-- Original spike protection code from SSNMighty
addHook("ShouldDamage", function(mobj, spike)
    if (mobj.player and mobj.skin == "mightyre") then
		if (spike == nil) then return end
		if (spike.valid and spike.type == MT_SPIKE) then
			if not (mobj.player.stompdash == nil) then
				spike.health = 0
				S_StartSound(mobj, spike.info.deathsound)
				P_KillMobj(spike, mobj, mobj)
				return false
			elseif (mobj.player.stompdash == nil) and (mobj.player.bounce == false) then
				mobj.player.pflags = $1 & ~PF_SPINNING
				mobj.momz = 10*FRACUNIT
				mobj.momx = FixedMul(-8*FRACUNIT, cos(mobj.angle))
				mobj.momy = FixedMul(-8*FRACUNIT, sin(mobj.angle))
				S_StartSound(target, sfx_s3k44)
				mobj.state = S_PLAY_FALL
				mobj.player.bounce = true
				return false
			end
		elseif (spike.valid and ((spike.flags & MF_MISSILE and spike.flags & MF_ENEMY) or (spike.type == MT_ARROW)) and (mobj.state == S_PLAY_JUMP or mobj.state == S_PLAY_ROLL or mobj.state == S_PLAY_SPINDASH)) then
			S_StartSound(spike, sfx_bnce1, mobj.player)
			spike.momx = ($1*-2) + (P_RandomRange(-10, 10) * FRACUNIT)
			spike.momy = ($1*-2) + (P_RandomRange(-10, 10) * FRACUNIT)
			spike.momz = ($1*-2) + (P_RandomRange(-10, 10) * FRACUNIT)
			spike.flags = $1|MF_NOCLIPTHING
			spike.flags = $1|MF_NOCLIP
			return false
		end
	end
end)