freeslot("sfx_srebce")
sfxinfo[sfx_srebce].caption = "Rebound"
//Sonic Lost World Bounce Attack. made by MotdSpork. Boing!
//Edited by TeriosSonic to replicate the SA2 bounce more.
addHook("MobjThinker", function(sonicre)
	if (sonicre and sonicre.skin == "sonicre") //if you're sonicre..
	and not (P_PlayerInPain(sonicre.player) or sonicre.state == S_PLAY_DEAD)
	and not (sonicre.player.powers[pw_super]) //super sonicre has float instead
		if sonicre.player.bounceattack == nil //if the variable doesnt exist
			sonicre.player.bounceattack = 0 //create variable
		end
		if sonicre.player.bouncenumber == nil //if the variable doesnt exist
			sonicre.player.bouncenumber = 0 //create variable
			sonicre.player.justchangedbouncenumber = 0 //create variable
		end
		if P_IsObjectOnGround(sonicre) //are you on the ground?
		and sonicre.player.bounceattack == 0 //the player isnt bouncing
			sonicre.player.bouncenumber = 0 //set it to zero!
		end
		if sonicre.player.usedown == nil //if the variable doesnt exist
		or not (sonicre.player.cmd.buttons & BT_SPIN) //not pressing the spin button?
			sonicre.player.usedown = 0 //create variable
			sonicre.player.justchangedbouncenumber = 0 //create variable
		end
		if P_IsObjectOnGround(sonicre) //Is the player on the ground?
		and (sonicre.player.cmd.buttons & BT_SPIN) //Is the player holding the spin button?
			sonicre.player.usedown = 1 //Set it to one!
		end
		if sonicre.player.pflags & PF_JUMPED //if the player has jumped
		and not (sonicre.player.pflags & PF_THOKKED) //and the player hasnt used their mid-air ability
		and not (P_IsObjectOnGround(sonicre)) //and you arent on the ground.
		and sonicre.player.cmd.buttons & BT_SPIN //pressing custom2?
		and sonicre.player.bounceattack == 0 //checking if the custom variable it set to 0
		and sonicre.player.usedown == 0 //make sure you arent holding the spin button.
		and not (sonicre.player.exiting) //not...exiting the level?
		and sonicre.health //you're alive?
		and not (P_PlayerInPain(sonicre.player)) //not hurt are you?
			sonicre.player.bounceattack = 1 //set it to one!
			P_SetObjectMomZ(sonicre, -35*FRACUNIT) //make the player "shoot" downward
			//P_SetObjectMomZ(sonicre, FixedMul(-35*FRACUNIT, sonicre.scale)) //make the player shoot downwards 
			sonicre.player.pflags = $1|PF_THOKKED //force the player into a "thokked" state
		end
			
		if (sonicre.eflags & MFE_JUSTHITFLOOR) //you're on the ground.
		and not (sonicre.player.pflags & PF_SPINNING) //you arent spinning....somehow
		and not (sonicre.player.pflags & PF_STARTDASH) //you arent doing a spindash
		and not (sonicre.tracer and sonicre.tracer.type == MT_TUBEWAYPOINT) //not in a...zoomtube?
		and sonicre.player.bounceattack == 1 //our custom variable is one right...?
		and sonicre.health //is the player alive..?
		and not (P_PlayerInPain(sonicre.player)) //not hurt are you?
			if sonicre.player.bouncenumber == 0 //if he hasnt bounced yet
			and sonicre.player.justchangedbouncenumber == 0 //if he hasnt left the ground yet
				sonicre.player.justchangedbouncenumber = 1 //now he has!
				sonicre.player.bouncenumber = 1 //Set this to one!
				sonicre.player.pflags = $1|PF_JUMPED //forcing the player into a jumping state.
				P_SetObjectMomZ(sonicre, 12*FRACUNIT)
				if not (sonicre.player.panim == PA_ROLL) //checking if the players animation is it's spinning anim.
					sonicre.state = S_PLAY_ROLL //force the player into a spinning state.
				end
			end
			if sonicre.player.bouncenumber == 1 //if it's currently on his first bounce
			and sonicre.player.justchangedbouncenumber == 0 //if he hasnt left the ground yet
			and not (P_PlayerInPain(sonicre.player)) //not hurt are you?
				sonicre.player.justchangedbouncenumber = 1 //now he has!
				//sonicre.player.bouncenumber = 2 //set this to two! [commented out so you have infinite bounce]
				sonicre.player.pflags = $1|PF_JUMPED //forcing the player into a jumping state.
				P_SetObjectMomZ(sonicre, 13*FRACUNIT)
				if not (sonicre.player.panim == PA_ROLL) //checking if the players animation is it's spinning anim.
					sonicre.state = S_PLAY_ROLL //force the player into a spinning state.
				end
			end
			if sonicre.player.bouncenumber == 2 //if it's currently on his second bounce
			and sonicre.player.justchangedbouncenumber == 0 //if he hasnt left the ground yet
			and not (P_PlayerInPain(sonicre.player)) //not hurt are you?
				sonicre.player.justchangedbouncenumber = 1 //now he has!
				sonicre.player.bouncenumber = 0 //set it back to zero
				sonicre.state = S_PLAY_SPRING //change to spring frame, like is SLW!
				P_SetObjectMomZ(sonicre, 15*FRACUNIT) //send the player upwards
				sonicre.player.pflags = $1 & ~PF_JUMPED // No longer jumping. Don't land on an enemy!
			end
			sonicre.player.bounceattack = 0 //set it back to zero.
			sonicre.player.usedown = 1 //set it to one.
			sonicre.player.pflags = $1 & ~PF_THOKKED //uncheck the thokked flag, allowing you to bounce again.
			S_StartSound(sonicre, sfx_srebce) //play a sound c:			
			
		end
		//some quick checks
		
		if sonicre.player.bounceattack == 1 //checking our variable.
		and sonicre.health //and you're alive
		and not (P_PlayerInPain(sonicre.player)) //not hurt are you?
			P_SpawnThokMobj(sonicre.player) //spawn the players thok object
			if not (sonicre.player.panim == PA_ROLL) //checking if the players animation is it's spinning anim.
				sonicre.state = S_PLAY_ROLL //force the player into a spinning state.
			end
			if (sonicre.momz > (9000*P_MobjFlip(sonicre))) // the player is going up...?  
				P_SetObjectMomZ(sonicre, FixedMul(-35*FRACUNIT, sonicre.scale)) //not anymore >.>
			end
		else 
			sonicre.player.bounceattack = 0 //set it to 0
		end
		if sonicre.player.bounceattack == 1 //checking if hes bouncing
			sonicre.player.pflags = $1 & ~PF_SPINNING // you're no longer "spinning" if you were before
		end
		if not (sonicre.player.pflags & PF_JUMPED) // if you are not actuallly jumping
			sonicre.player.bounceattack = 0 //set this back to zero to be safe
		end
		
		if sonicre.eflags & MFE_GOOWATER //is the player in THZ goop?
		or sonicre.player.powers[pw_carry] //is the player being carried?
		//or sonicre.player.pflags & PF_ROPEHANG //is the player on a ACZ ropehang?
			sonicre.player.bounceattack = 0 //set to zero!
		end
		if not (sonicre.player.pflags & PF_JUMPED) //if the player hasnt jumped
			sonicre.player.bounceattack = 0 //set this to zero
		end
	end
end, MT_PLAYER)