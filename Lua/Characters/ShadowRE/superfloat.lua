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