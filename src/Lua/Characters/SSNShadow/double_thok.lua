-- Double Thok. Thok, thok!
-- Based off of Legacy Homing Thok by TeriosSonic
-- and Vbilities by Trystan
-- Merged and edited by TeriosSonic
-- Edited by Ashi to fix formatting and syntax

addHook("AbilitySpecial", function(player)
    if player.mo.skin == "ssnshadow"
	and player.charability == CA_HOMINGTHOK then
        if P_LookForEnemies(player) then
            player.charability = CA_HOMINGTHOK
        elseif not (player.pflags & PF_THOKKED) then
            P_InstaThrust(player.mo, player.mo.angle, player.actionspd/2)
			P_SpawnThokMobj(player)
			S_StartSound(player.mo, sfx_thok, player)
			player.mo.state = S_PLAY_JUMP
			player.pflags = $ | PF_THOKKED
			return true
        end
    end
end)

addHook("ThinkFrame", function()
	for player in players.iterate do
		-- Check player validity and player skin
		if not (player.mo and player.mo.skin == "ssnshadow") then return end

		if player.mo.eflags & MFE_UNDERWATER then
			player.thokspeed = player.actionspd/2
		else
			player.thokspeed = player.actionspd
		end

		if player.mo.state == S_PLAY_SPRING
		and (player.pflags & PF_JUMPED)
		and (player.pflags & PF_JUMPDOWN)
		and not (player.mo.eflags & MFE_SPRUNG) then
			P_InstaThrust(player.mo, player.mo.angle, player.prevactionspd/3)
			P_SetObjectMomZ(player.mo, 10*FRACUNIT, false)
			player.mo.state = S_PLAY_JUMP
		elseif player.mo.state == S_PLAY_SPRING
		and (player.pflags & PF_JUMPED)
		and not (player.pflags & PF_JUMPDOWN)
		and not (player.mo.eflags & MFE_SPRUNG) then
			player.mo.state = S_PLAY_JUMP
			player.mo.momx = 0
			player.mo.momy = 0
		end

		player.prevactionspd = player.actionspd

		if player.homing then
			player.actionspd = skins[player.mo.skin].actionspd
		else
			player.actionspd = (player.speed+10*FRACUNIT)*2
		end
	end
end)