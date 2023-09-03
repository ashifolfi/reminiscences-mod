-- No Thok Super Float lua by TeriosSonic
-- Free to use as long as you credit me.
addHook("PlayerThink", function(player)
    if player.mo and (player.mo.skin == "sonicre" or player.mo.skin == "ssnshadow") then -- charname here
        if player.powers[pw_super] -- If you're super...
		and player.cmd.buttons & BT_SPIN -- ...and you're holding Spin...
		and not(P_IsObjectOnGround(player.mo))
		and player.pflags & PF_JUMPED then
            player.charability = CA_THOK -- ...then you'll have the Thok ability!
        else
            player.charability = CA_HOMINGTHOK -- This is the ability you'll have while these parameters are not fullfilled
        end
    end
end)

-- Super Slowfall to Float lua by TeriosSonic
-- Free to use as long as you credit me.
addHook("PlayerThink", function(player)
    if player.mo and player.mo.skin == "shadowre" then -- charname here
        if player.powers[pw_super] then
            player.charability = CA_FLOAT -- ...then you'll have the Float ability!
        else
            player.charability = CA_SLOWFALL -- This is the ability you'll have while these parameters are not fullfilled
        end
    end
end)