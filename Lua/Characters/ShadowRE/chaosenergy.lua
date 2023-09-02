addHook("PlayerThink", function(player)
	if not player.mo then return end -- The player should be valid.
	if not player.mo.skin == "shadowre" then return end
	
	if not player.maxchaos then
		player.maxchaos = 100
		player.chaosenergy = player.maxchaos
		player.halfchaos = player.maxchaos/2
		player.lowchaos = player.maxchaos/3
	end
	
	if player.ringcollect == nil then
		player.ringcollect = 0
	elseif player.rings < player.ringcollect then
		player.ringcollect = player.rings
	elseif player.rings > player.ringcollect then
		if player.chaosenergy < player.maxchaos then
			player.chaosenergy = $+(player.rings-player.ringcollect)
		end
		player.ringcollect = player.rings
	end
end)