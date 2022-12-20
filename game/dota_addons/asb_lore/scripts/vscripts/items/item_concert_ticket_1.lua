
item_concert_ticket_1 = class({})


function item_concert_ticket_1:OnSpellStart()
 local caster = self:GetCaster()
 self.caster = caster
 self.bonus_gold = 1000
 local Player = PlayerResource:GetPlayer(caster:GetPlayerID())
 	self:SpendCharge()
self.shit  = RandomInt(1,2)
self:StopAllMusic()
PlayerResource:ModifyGold( caster:GetPlayerOwnerID(), self.bonus_gold, false, DOTA_ModifyGold_Unspecified )
if self.shit == 1 then
EmitSoundOnClient("new.year_theme_1", Player) 
else
EmitSoundOnClient("new.year_theme_2", Player) 
end
end

function item_concert_ticket_1:StopAllMusic()
	local Player = PlayerResource:GetPlayer(self.caster:GetPlayerID())
	if IsServer() then
		for i = 1, 30 do
			StopSoundOn("star.theme_"..i, Player)
		end
		  for i = 1, 6  do
			StopSoundOn("horn.hero_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("horn.demon_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("horn.samurai_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("spamton.theme_"..i, Player)
		end
		 for i = 1, 8  do
			StopSoundOn("new.year_theme_"..i, Player)
		end
	
end

end