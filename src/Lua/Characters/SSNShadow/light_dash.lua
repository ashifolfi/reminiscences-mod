--[[
	Improved lightdash

	Badz' lightdash is reusable, so this is too. Don't forget to credit everyone

	Original by Badz
	Edited by TeriosSonic
	Cleaned up by Ashi
]]

freeslot(
	"S_PLAY_LDSH",
	"S_PLAY_LDSH2"
)

states[S_PLAY_LDSH] = {SPR_PLAY, SPR2_FALL|FF_ANIMATE|FF_SPR2MIDSTART, 1, A_HomingChase, 50*FRACUNIT, 0, S_PLAY_LDSH2}
states[S_PLAY_LDSH2] = {SPR_PLAY, SPR2_FALL|FF_ANIMATE|FF_SPR2MIDSTART, 2, A_GhostMe, 0, 0, S_PLAY_ROLL}

addHook("ThinkFrame", function()
	for player in players.iterate do
		-- no warning pls
		if not player.mo then return end

		player.lightdash = $1 --  Whether they are currently lightdashing and how many tics they have left before they stop picking up on other rings
		player.custom1down = $1 --  Whether they are currently holding down custom button 1
		
		if player.lightdash == nil then
			player.lightdash = 0
		end
		if player.custom1down == nil then
			player.custom1down = 1
		end
		
		if player.mo and player.mo.skin == "ssnshadow" then
			if (((player.cmd.buttons & BT_CUSTOM1) and not player.custom1down) or player.lightdash > 0)
			and not (player.pflags & PF_STASIS)
			and not (player.pflags & PF_JUMPSTASIS)
			and not (player.pflags & PF_SPINNING)
			and not (player.powers[pw_shield] == SH_ATTRACT)
			and not (player.mo.state == player.mo.info.painstate) then
				A_FindTarget (player.mo, MT_RING, 0)
				if player.mo.target
				and player.mo.target.type == MT_RING then -- Prevents lightdashing into bosses!
					A_CheckTrueRange (player.mo, 160, S_PLAY_LDSH)
				end
				
				if player.mo.state >= S_PLAY_LDSH and player.mo.state <= S_PLAY_LDSH2 then -- after that, if you are lightdashing, set the lightdash counter to 5 tics
					player.lightdash = 5
				end
			else
				player.lightdash = 0 --  Kill it if these conditions aren't met
			end
		end
		
		if (player.cmd.buttons & BT_CUSTOM1) then
			player.custom1down = true
		else
			player.custom1down = false
		end
		
		if (player.lightdash > 0) then
			player.lightdash = $1 - 1
		end

		-- Here I added a bit of script so you hurt enemies when lightdashing
		if player.mo.state == S_PLAY_LDSH
		or player.mo.state == S_PLAY_LDSH2
		and not (player.pflags & PF_JUMPED) then
			player.pflags = $ | PF_JUMPED
		end
	end
end)
