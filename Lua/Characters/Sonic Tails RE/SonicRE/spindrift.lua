//Thank you so much Zipper, I literally couldn't do this without you.
--Golden Shine: I guess I'll make some edits to make this part work better.
-- TeriosSonic: *makes further edits* Yes.
local function allSpin(p)
  if p.mo and p.mo.skin == "sonicre" and not p.spectator and P_IsObjectOnGround(p.mo)--p.mo.skin check goes AFTER we've defined what p is, which is the player by default in this hook.
  
	//   p.mindash = 75*FRACUNIT --Why did you put mindash higher than the maxdash???
	//   p.maxdash = 50*FRACUNIT --Whatever, uncomment this if you want your old system back!
	
	 if not p.powers[pw_carry] and not p.powers[pw_nocontrol] and p.mo.state != S_PLAY_SPINDASH
	 and p.charability2 == CA2_SPINDASH and not (p.pflags & (PF_SPINDOWN|PF_SPINNING|PF_STARTDASH))
	 
		if (p.speed < 28*FRACUNIT) --Remove this part if you want the old system back.
		p.mindash = 28*FRACUNIT
		else
		//p.mindash = p.speed --Hey, let's just make this dependant on the player's speed instead
		p.mindash = p.speed + 20*FRACUNIT -- this one makes the mindash be boosted a bit
		end
		
        P_InstaThrust(p.mo, p.mo.angle, 2*FRACUNIT)
	    p.mo.state = S_PLAY_SPINDASH
	    p.pflags = $ | (PF_SPINDOWN|PF_STARTDASH|PF_SPINNING)
	    S_StartSound(p.mo, sfx_spndsh)
		//p.mo.ghs = P_SpawnGhostMobj(p.mo) -- i don't like this ghost thing, it's kinda useless
		//p.mo.ghs.scale = (p.mo.scale*(p.mindash/FRACUNIT))/20
		//p.mo.ghs.destscale = p.mo.scale
		//p.mo.ghs.scalespeed = $*2
		//p.mo.ghs.flags = $|MF_NOCLIPHEIGHT|MF_NOCLIP & ~MF_SOLID
		//p.mo.ghs.z = p.mo.z-p.mo.ghs.scale*10
	    return true
    elseif (p.pflags & PF_SPINNING) and p.mo.state == S_PLAY_ROLL and
    not (p.pflags & (PF_SPINDOWN|PF_STARTDASH))
        p.mo.state = S_PLAY_RUN
		p.pflags = ($ & ~PF_SPINNING) | PF_SPINDOWN
	    //S_StartSound(p.mo, sfx_zoom) -- this sound is kinda weird so i'll just remove it
		P_Thrust(p.mo, p.mo.angle, 12*FRACUNIT)
		//P_SpawnGhostMobj(p.mo) -- this ghost is kinda useless too
		return true
    end
 end
end		
addHook("SpinSpecial", allSpin)
