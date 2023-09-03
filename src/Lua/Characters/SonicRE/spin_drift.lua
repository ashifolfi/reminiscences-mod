--[[
	Spin Drift

	Thank you so much Zipper, I literally couldn't do this without you.
	
	Golden Shine: I guess I'll make some edits to make this part work better.
	TeriosSonic: *makes further edits* Yes.
	Ashi: fixed the formatting
]]

local function allSpin(p)
	-- p.mo.skin check goes AFTER we've defined what p is, which is the player by default in this hook.
	if p.mo and p.mo.skin == "sonicre" and not p.spectator and P_IsObjectOnGround(p.mo) then
		
		-- p.mindash = 75*FRACUNIT -- Why did you put mindash higher than the maxdash???
		-- p.maxdash = 50*FRACUNIT -- Whatever, uncomment this if you want your old system back!
		
		if not p.powers[pw_carry] and not p.powers[pw_nocontrol] and p.mo.state != S_PLAY_SPINDASH
		and p.charability2 == CA2_SPINDASH and not (p.pflags & (PF_SPINDOWN|PF_SPINNING|PF_STARTDASH)) then
			if (p.speed < 28*FRACUNIT) then --Remove this part if you want the old system back.
				p.mindash = 28*FRACUNIT
			else
				-- p.mindash = p.speed --Hey, let's just make this dependant on the player's speed instead
				p.mindash = p.speed + 20*FRACUNIT -- this one makes the mindash be boosted a bit
			end
			
			P_InstaThrust(p.mo, p.mo.angle, 2*FRACUNIT)
			p.mo.state = S_PLAY_SPINDASH
			p.pflags = $ | (PF_SPINDOWN|PF_STARTDASH|PF_SPINNING)
			S_StartSound(p.mo, sfx_spndsh)
			return true
		elseif (p.pflags & PF_SPINNING) and p.mo.state == S_PLAY_ROLL and
		not (p.pflags & (PF_SPINDOWN|PF_STARTDASH)) then
			p.mo.state = S_PLAY_RUN
			p.pflags = ($ & ~PF_SPINNING) | PF_SPINDOWN
			-- S_StartSound(p.mo, sfx_zoom) -- this sound is kinda weird so i'll just remove it
			P_Thrust(p.mo, p.mo.angle, 12*FRACUNIT)
			-- P_SpawnGhostMobj(p.mo) -- this ghost is kinda useless too
			return true
		end
	end
end		
addHook("SpinSpecial", allSpin)
