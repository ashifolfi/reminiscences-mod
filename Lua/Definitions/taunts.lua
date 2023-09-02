freeslot("S_REMINISCENCES_TAUNT", "SPR2_TANT")

states[S_REMINISCENCES_TAUNT] = {SPR_PLAY, SPR2_TANT|FF_ANIMATE, -1, nil, 5, 10, S_PLAY_STND}

local function IsReminSkin(player)
	if player.mo.skin == "sonicre"
	or player.mo.skin == "tailsre"
	or player.mo.skin == "shadowre"
	or player.mo.skin == "ssnshadow"
	or player.mo.skin == "ssnamy"
	or player.mo.skin == "amyre"
	or player.mo.skin == "sallyre"
	or player.mo.skin == "ssnblaze"
	or player.mo.skin == "mightyre"
	or player.mo.skin == "charmy" then
		return true
	else
		return false
	end
end

addHook("ThinkFrame", function(player)
	for player in players.iterate
		local button = CV_FindVar("remin_taunt_button").value
		if not player.mo return end -- The player should be valid.
		if not IsReminSkin(player) then return end
		
		if not (player.cmd.buttons & button) then
			player.tauntready = true
			player.tauntbutton = false
		elseif player.tauntready then
			player.tauntbutton = true
			player.tauntready = false
		else
			player.tauntbutton = false
		end
		
		if player.tauntbutton then
			if player.mo.state == S_REMINISCENCES_TAUNT then
				player.mo.state = S_PLAY_STND
				P_RestoreMusic(player)
			elseif player.mo.state == S_PLAY_STND
			or player.mo.state == S_PLAY_WAIT
			or player.mo.state == S_PLAY_EDGE then
				player.mo.state = S_REMINISCENCES_TAUNT
			end
		end
		
		if player.mo.state == S_REMINISCENCES_TAUNT then
			player.pflags = $ | PF_FULLSTASIS
			
			-- Taunt Sounds
			if CV_FindVar("remin_taunt_sounds").value then
				if player.mo.skin == "sonicre"
					S_ChangeMusic("GFZCRK", true, player)
				elseif player.mo.skin == "shadowre"
				or player.mo.skin == "ssnshadow"
					S_ChangeMusic("CHADOU", true, player)
				elseif player.mo.skin == "ssnamy"
					S_ChangeMusic("EARAMY", true, player)
				elseif player.mo.skin == "sallyre"
					S_ChangeMusic("SALSUS", true, player)
				end
			end
		end
	end
end)