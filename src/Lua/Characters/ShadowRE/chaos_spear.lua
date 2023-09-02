addHook("PlayerThink", function(player, sector) // spec pet is an epic person
	
	player.weapon = MT_SPEAR
	
	player.target = P_LookForEnemies(player, false, true)
	
	if player.cooldown == nil then
		player.cooldown = 0
	end
	
	if (player.target)
	and (player.mo.skin == "shadowre") then
		P_SpawnLockOn(player, player.target, S_LOCKON4)
	end
	
	if (player.cmd.buttons & BT_CUSTOM1) and (player.mo.skin == "shadowre")
	and (not (player.cooldown)) and (player.chaosenergy > 0) and player.target then
		P_SpawnMissile(player.mo, player.target, MT_SPEAR)
		player.chaosenergy = $-15
		player.cooldown = 1
	elseif (player.cmd.buttons & BT_CUSTOM1) and (player.mo.skin == "shadowre")
	and (not (player.cooldown)) and (player.chaosenergy > 0) then
		P_SpawnPlayerMissile(player.mo, MT_SPEAR)
		player.chaosenergy = $-15
		player.cooldown = 1
	elseif not(player.cmd.buttons & BT_CUSTOM1) then
		player.cooldown = 0
	end
		
end)

freeslot("S_SPEAR", "SPR_SPER", "MT_SPEAR", "sfx_sresht")

sfxinfo[sfx_sresht].caption = "Chaos Spear"

mobjinfo[MT_SPEAR] = {
    spawnstate = S_SPEAR,
    spawnhealth = 20,
	deathstate = S_NULL,
	seesound = sfx_sresht,
    speed = 60*FRACUNIT,
    radius = 24*FRACUNIT,
    height = 24*FRACUNIT,
    damage = 4,
    flags = MF_MISSILE|MF_NOGRAVITY
}


states[S_SPEAR] = {
        sprite = SPR_SPER,
        frame = A,
        tics = -1,
        action = A_ShootBullet
}

