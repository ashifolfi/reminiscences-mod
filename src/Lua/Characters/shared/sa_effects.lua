-- Spin Steer by ffoxD
addHook("PlayerThink", function(p)
	if not p.mo then return end
	if p.mo.skin == "sonicre"
	or p.mo.skin == "tailsre" then
		if p.pflags & PF_SPINNING and not (p.pflags & PF_STARTDASH) and P_IsObjectOnGround(p.mo) then
			p.thrustfactor = (skins[p.mo.skin].thrustfactor)*15
		else
			p.thrustfactor = skins[p.mo.skin].thrustfactor
		end
	end
end)

-- Damage Recovery by TeriosSonic
addHook("ThinkFrame", function(player)
	for player in players.iterate do
		if not player.mo then return end
		if player.mo.skin == "sonicre" or player.mo.skin == "tailsre" then
			if P_PlayerInPain(player) then
				player.paintimer = $ + 1
			else
				player.paintimer = 0
			end
			if player.paintimer > 15
			and player.cmd.buttons & BT_JUMP then
				P_DoJump(player, true)
				player.paintimer = 0
			end
		end
	end
end)