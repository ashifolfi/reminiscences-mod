-- TODO: is this used?
local function getcolorflag(e1,e2,e3)
	if e1 >= e2 then
		return V_GREENMAP
	elseif e1 <= e2
	and e1 >= e3 then
		return V_ORANGEMAP
	elseif e1 < e3 then
		return V_REDMAP
	end
end


local HUDCOLOR_RED = 39

hud.add(function(v, player)
	if not (player and player.mo and player.mo.skin == "shadowre") then return end
	if (maptol & TOL_NIGHTS) then return end 
	if (player.chaosenergy == nil) then return end
	if (player.spectator) then return end
	
	local FUELHUD_X,FUELHUD_Y = 150,171
	local POSX = 290
	local FUELHUD_HEIGHT = 12
	local FUELHUD_WIDTH = 134
	
	local amount = player.chaosenergy
	local FUELHUD_AMOUNT_LIMIT = player.maxchaos
	if (amount > FUELHUD_AMOUNT_LIMIT) then
		amount = FUELHUD_AMOUNT_LIMIT
	end
	
	local FUELHUD_AMOUNT = amount * FUELHUD_WIDTH/FUELHUD_AMOUNT_LIMIT
	local FUELHUD_HALFAMOUNT = player.halfchaos * FUELHUD_WIDTH/FUELHUD_AMOUNT_LIMIT
	local FUELHUD_LOWAMOUNT = player.lowchaos * FUELHUD_WIDTH/FUELHUD_AMOUNT_LIMIT
	v.draw(FUELHUD_X - 1, 168, v.cachePatch("CHAOSBAK"), V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS)
	POSX = $ - 1
	for i = FUELHUD_AMOUNT, 1, -1 do
		if FUELHUD_AMOUNT >= i then
			v.draw(POSX, FUELHUD_Y+1, v.cachePatch("CHAOSMID"), V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS)
		end
		POSX = $ - 1
	end
	v.draw(FUELHUD_X - 1, 168, v.cachePatch("CHAOSBAR"), V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS)
end)